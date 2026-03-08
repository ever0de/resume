# Pebble LSM-tree Tombstone 누적 문제 분석 및 해결

Pebble LSM-tree에서 tombstone이 L5/L6에 누적되어 iterator 성능이 저하되는 문제를 분석하고 해결한 과정을 정리한 문서입니다.

## 배경

- Pebble v1.1.2 사용, 총 데이터 5GB, 키 약 3600만개
- Write 패턴: 약 0.6초마다 600KB~800KB의 batch 데이터 생성, Set/Delete를 사용
- 특정 key section들을 반복적으로 쓰고 지우는 패턴
- **문제**: 1,120개 레코드를 iterator로 검색하는데 총 지연 22~26ms (정상 시 494µs~2ms)
- Iterator stats에서 point count가 213,040으로 폭증 — 대부분이 tombstone
- **원인 검증**: 문제가 발생한 특정 key range에 대해 수동으로 compaction을 트리거 했을 때 지연이 즉시 해소됨 — tombstone 누적이 원인임을 확인

## 문제 분석: Pebble의 Compaction 전략과 Tombstone

### Compensated Size

Pebble의 compaction picker는 [`compensatedSize`](https://github.com/cockroachdb/pebble/blob/v1.1.2/compaction_picker.go#L720-L729)를 사용합니다:

```
파일 크기 + PointDeletionsBytesEstimate + RangeDeletionsBytesEstimate
```

이 보정된 크기가 레벨의 fill factor를 높여서 해당 레벨이 compaction 대상이 되게 합니다.

**핵심**: 이 보정 크기는 tombstone이 **다음 레벨의 데이터를 삭제할 수 있는 바이트**를 추정한 것입니다. 즉 Ln의 tombstone이 Ln+1의 데이터를 얼마나 정리할 수 있는지를 기반으로 합니다.

### Move Compaction의 함정

[`newCompaction`](https://github.com/cockroachdb/pebble/blob/v1.1.2/compaction.go#L759-L790)에서 default compaction이 아래 **4가지 조건을 모두 만족**하면 move compaction(trivial move)으로 변환됩니다:

```go
c.kind == compactionKindDefault &&
    c.outputLevel.files.Empty() &&   // 출력 레벨에 겹치는 파일 없음
    !c.hasExtraLevelData() &&        // 중간 레벨 데이터 없음
    c.startLevel.files.Len() == 1 && // 입력 파일이 정확히 1개
    c.grandparents.SizeSum() <= c.maxOverlapBytes // 손자 레벨 겹침도 적음
```

- Move compaction은 SSTable을 **재작성하지 않고** manifest만 수정해 다음 레벨로 이동시킴
- 따라서 SSTable 내부의 tombstone은 **처리되지 않은 채** 더 깊은 레벨로 내려감
- 우리 패턴(특정 key range를 반복 Set/Delete)에서는 각 배치가 flush될 때 파일 크기가 작고 해당 key range가 하위 레벨에 아직 정착하지 않은 경우가 많아, 위 4가지 조건을 충족하는 빈도가 높았음
- 결과적으로 tombstone이 L5/L6까지 지연 처리된 채 쌓임

### Elision-Only Compaction의 한계

Pebble v1.1.2의 [`pickAuto`](https://github.com/cockroachdb/pebble/blob/v1.1.2/compaction_picker.go#L1379)는 score 기반 compaction이 선택되지 않을 때 **최후 fallback**으로 elision-only compaction을 시도합니다. bottommost level(L6)에서 tombstone을 정리하는 유일한 자동 fallback 메커니즘입니다.

- Elision-only compaction은 SSTable을 다른 레벨과 머지하지 않고 단독으로 재작성하여 tombstone을 제거하지만, 발동에는 두 단계 검사를 모두 통과해야 합니다:

**1단계 — 임계값 검사** ([`elisionOnlyAnnotator`](https://github.com/cockroachdb/pebble/blob/v1.1.2/compaction_picker.go#L1487-L1490)):
```go
if f.Stats.RangeDeletionsBytesEstimate*10 < f.Size &&
    f.Stats.NumDeletions*10 <= f.Stats.NumEntries {
    return dst, true  // 후보 제외
}
```
`NumDeletions`는 point delete(`Delete`, `SingleDelete`, `DeleteSized`)의 총 카운트입니다.

**2단계 — Snapshot 차단** ([`pickElisionOnlyCompaction`](https://github.com/cockroachdb/pebble/blob/v1.1.2/compaction_picker.go#L1569)):
```go
if candidate.IsCompacting() || candidate.LargestSeqNum >= env.earliestSnapshotSeqNum {
    return nil
}
```
파일의 `LargestSeqNum`이 가장 오래된 snapshot의 seq num 이상이면 elision이 차단됩니다. 우리는 최근 10개 height를 Pebble snapshot으로 유지하고 있었습니다. move compaction으로 L6에 도달한 파일들은 최근에 flush된 것이므로 LargestSeqNum이 높고, 이 값이 earliestSnapshotSeqNum 이상이 되어 **elision이 차단됩니다**. 즉 임계값 조건은 충족하더라도, 10개 height snapshot 유지가 실질적인 차단 원인이었습니다.

> **왜 delete-only compaction도 도움이 안 됐나?**  
> [`checkDeleteCompactionHints`](https://github.com/cockroachdb/pebble/blob/v1.1.2/compaction.go#L2644)는 `for l := h.tombstoneLevel + 1; l < numLevels; l++` 로 L6까지 스캔하므로, delete-only compaction 자체는 L6 파일도 대상으로 삼을 수 있습니다. 그러나 [`compactionHintFromKeys`](https://github.com/cockroachdb/pebble/blob/v1.1.2/compaction.go#L2434)에서 hint는 오직 `RangeDelete`·`RangeKeyDelete` span에서만 생성됩니다. 우리 패턴은 **point `Delete`** 를 사용했으므로 hint 자체가 생성되지 않아, L6 적용 가능 여부와 무관하게 delete-only compaction은 한 번도 트리거되지 않았습니다.

### DeleteSized를 시도했지만 효과 없었던 이유

[`DeleteSized`](https://github.com/cockroachdb/pebble/blob/v1.1.2/db.go#L104-L118)는 tombstone에 삭제할 값의 크기를 기록하여 `PointDeletionsBytesEstimate`를 높이고, 이를 통해 `compensatedSize`를 더 정확하게 만듭니다. 그러나 **estimate가 정확해지더라도 실제 compaction이 트리거되지 않는 구조**였기 때문에 효과가 없었습니다:

1. [`pickAuto`](https://github.com/cockroachdb/pebble/blob/v1.1.2/compaction_picker.go#L1335)의 score-based compaction 루프는 `if info.level == numLevels-1 { continue }` 로 **L6를 명시적으로 건너뜁니다**. 즉 L6 파일의 `compensatedSize`가 아무리 높아도 score-based compaction 대상이 되지 않음
2. elision-only compaction은 `PointDeletionsBytesEstimate`가 아닌 `NumDeletions`와 `RangeDeletionsBytesEstimate`를 기준으로 삼으므로, `DeleteSized`로 estimate를 정확하게 해도 elision 발동 조건에 직접 영향을 주지 않음
3. `compensatedSize`는 L6보다 상위 레벨(Ln)의 tombstone이 Ln+1을 얼마나 정리할 수 있는지를 score에 반영하는 용도입니다. 이미 L6에 도달한 파일의 tombstone에 대해서는 "다음 레벨"이 없으므로 이 보정 크기가 compaction을 유발하는 경로가 존재하지 않음

## 해결

- 이 이슈를 Pebble GitHub에 보고: https://github.com/cockroachdb/pebble/issues/3881
- 임시 검증: tombstone이 생겨있는 key section을 수동으로 compaction trigger하면 정상으로 돌아옴 (494µs~2ms) — tombstone이 정리되면 성능이 돌아옴을 확인하여 원인을 검증
- **근본 해결**: Pebble 신버전으로 업그레이드. 해당 버전에 도입된 **[Tombstone Density Compaction](https://github.com/cockroachdb/pebble/commit/28840262ebcf55013b726e584cd9218400dd5eca)**이 tombstone 밀도가 높은 SSTable을 감지해 자동으로 compaction을 스케줄링하도록 함

## 파일 설명

| 파일 | 설명 |
|------|------|
| `pebble-tombstone.png` | tombstone density compaction이 L6에 적용되지 않았던 문제 파악 |
| `pebble-latency.png` | iterator 지연 시간 그래프 |
| `pebble-L6-tombstone-debug.png` | L6 tombstone 디버깅 스크린샷 |
| `multi-version-snapshot-research.md` | MVCC 스냅샷 스키마 리서치 (이 tombstone 문제의 원인이 된 MVCC 설계에 대한 연구) |

## 관련 링크

- https://github.com/cockroachdb/pebble/issues/3881
