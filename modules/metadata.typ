// ─────────────────────────────────────────────────────────────────────────────
// 개인 정보 및 이력서 데이터 (Personal Metadata)
// ─────────────────────────────────────────────────────────────────────────────

#let metadata = (
  name: (
    korean: "최지석",
    english: "Jiseok Choi",
  ),
  role: (
    ko: "소프트웨어 엔지니어",
    en: "Software Engineer",
  ),
  contact: (
    email: "jiseok.dev@gmail.com",
    github: "ever0de",
  ),
  bio: (
    ko: "시스템 내부가 실제로 어떻게 작동하는지 파고드는 것을 즐기는 프로그래머입니다.",
    en: "A programmer who enjoys digging into how systems actually work under the hood.",
  ),
  skills: (
    (label-ko: "언어", label-en: "Languages", value: "Rust, Go, TypeScript"),
    (label-ko: "스토리지 엔진", label-en: "Storage Engines", value: "LSM-Tree, pager-based B+Tree"),
    (label-ko: "데이터베이스", label-en: "Databases", value: "MySQL, PostgreSQL"),
  ),
  work: (
    (
      title-ko: "소프트웨어 엔지니어",
      title-en: "Software Engineer",
      org-ko: "Newmetric",
      org-en: "Newmetric",
      period-ko: "2023년 3월 – 2026년 3월",
      period-en: "Mar 2023 – Mar 2026",
      tags: ("Rust", "Go", "gRPC", "pebble"),
      body-ko: [
        분산 KV 스토리지 시스템 전체를 처음부터 설계·구현 및 운영.

        - #link(
            "https://github.com/ever0de/resume/tree/9bd13a2/public/newmetric/cache",
          )[수평 확장이 불가능한 단일 노드 구조를 수평 확장 가능하게 전환 — 동일 하드웨어 기존 구현 대비 17.5× 처리량 개선 (약 140k ops/s, p90 26.1ms; 프로덕션 spike 패턴 트래픽 기준).]
          write(주기적 batch)·read(상시 고빈도) 비대칭 워크로드에서 벤치마크·프로파일링으로 lock-based in-memory 프로토타입의 경합 병목을 확인한 뒤, lock-free 기반 MVCC 캐시 레이어를 설계·구현:
          - lock-free arena skiplist MVCC — write lock 없이 read/write를 동시 처리. 메모리 상한 도달 시 ring-buffer 방식의 슬롯 관리와 atomic reference counting으로 진행 중인 읽기의 snapshot consistency를 보장하면서 arena를 안전하게 교체.
          - sparse key space에서 range query 캐시 정합성 확보 — 이미 조회한 구간 정보를 별도 인덱스로 추적해 불필요한 DB 재조회를 방지.
        - 기존 time travel query 구현에서 각 버전을 독립 저장하는 구조상 iterator가 버전 경계마다 tombstone을 전부 스캔해야 하는 비효율을 copy-on-write 스냅샷 체크포인트 도입으로 해소 — 주기적 기준점을 확보하고 체크포인트 사이 버전은 delta merge-on-read로 서빙해, 스캔 비용과 스토리지 풋프린트를 함께 최소화.
        - #link(
            "https://github.com/ever0de/resume/tree/9bd13a2/public/newmetric/pebble",
          )[Pebble iterator latency가 기준치(494µs–2ms) 대비 10–50×로 급등(22–26ms) — 실제 레코드 1,120개를 읽어야 하는 쿼리에서 iterator stats의 point count가 213,040으로 폭증함을 먼저 확인한 뒤 compaction picker 소스를 직접 추적해 move compaction 조건에서 tombstone이 미처리인 채 L6에 누적되는 구조와, snapshot 보존 설정이 elision-only compaction을 차단하는 상호작용을 식별. L6 tombstone 전용 compaction을 적용해 정상 latency로 복구.]
        - arbitrary computation에 대한 partial·stateless 검증이 가능한 데이터 구조 설계 및 구현.
        - #link(
            "https://github.com/ever0de/resume/tree/9bd13a2/public/newmetric/postmortem",
          )[약 18건의 프로덕션 장애 postmortem — 증상이 아닌 원인 수준까지 추적: Fiber 메모리 풀 재사용 + 비동기 채널 타이밍으로 인한 캐시 키 변조, Pebble WAL 오염으로 인한 무한 재시작 루프 등.]
      ],
      body-en: [
        Designed and built a distributed KV storage system from the ground up.

        - #link(
            "https://github.com/ever0de/resume/tree/9bd13a2/public/newmetric/cache",
          )[Converted a non-horizontally-scalable single-node architecture into a horizontally scalable one — 17.5× throughput improvement over prior implementation on identical hardware (≈140k ops/s, p90 26.1ms under production spike-pattern traffic).]
          Under write-batch / continuous-read asymmetric workloads, benchmarking and profiling confirmed a lock-based in-memory prototype as the contention bottleneck; designed and implemented a lock-free MVCC cache layer:
          - Lock-free arena skiplist MVCC — concurrent read/write without write locks. On memory limit: ring-buffer slot management with atomic reference counting ensures snapshot consistency for in-flight reads while safely rotating arenas.
          - Sparse key space cache coherence for range queries — a dedicated index tracks which ranges have already been fetched to prevent redundant DB reads.
        - The existing time travel query implementation stored each version independently, forcing iterators to scan tombstones across every version boundary; replaced with CoW snapshot checkpoints as periodic baselines and delta merge-on-read for intermediate versions — minimising both scan overhead and storage footprint.
        - #link(
            "https://github.com/ever0de/resume/tree/9bd13a2/public/newmetric/pebble",
          )[Pebble iterator latency spiked 10–50× over baseline (494µs–2ms) to 22–26ms — a query reading 1,120 records showed point count of 213,040 in iterator stats, revealing excessive tombstone scanning; traced the compaction picker source to find tombstones accumulating in L6 unprocessed under move compaction conditions and snapshot retention blocking elision-only compaction. Applied L6-tombstone-targeted compaction to restore normal latency.]
        - Designed and implemented a data structure enabling partial, stateless verification of arbitrary computation.
        - #link(
            "https://github.com/ever0de/resume/tree/9bd13a2/public/newmetric/postmortem",
          )[Root-cause analysis across ~18 production incidents: Fiber memory-pool reuse + async channel timing corrupting cache keys; Pebble WAL corruption causing an infinite restart loop; etc.]
      ],
    ),
    (
      title-ko: "소프트웨어 엔지니어",
      title-en: "Software Engineer",
      org-ko: "Manythings (구 Casting 인수)",
      org-en: "Manythings (acq. Casting)",
      period-ko: "2021년 10월 – 2023년 2월",
      period-en: "Oct 2021 – Feb 2023",
      tags: ("Rust", "Go", "TypeScript"),
      body-ko: [
        - 파츠 우선순위에 따라 개별 레이어 이미지를 SVG로 합성 후 PNG로 렌더링하는 이미지 서버 구현 — 아이템 장착·해제 요청마다 즉시 재렌더링.
        - 외부 서버의 이벤트를 폴링해 정제한 뒤 MySQL에 적재하는 인덱서 구현 — 이벤트 상태 전이 기반으로 처리 보장.
        - Fastify 기반 REST API 서버 구현 — 아이템 조합 트랜잭션, 메타데이터 관리, 서명 검증 포함.
        - JS로 구현된 이미지 조합기의 성능 문제(수 시간 소요)를 Rust로 재구현 — 병렬 스레드풀로 생성 시간을 분 단위로 단축.
        - 마켓플레이스 서버 구현 — 외부 서버 이벤트를 폴링해 정제·가공 후 MySQL에 적재하는 인덱서와 Fastify API 서버로 데이터 서빙.
      ],
      body-en: [
        - Built an image compositing server: stacks individual layer images as SVG in priority order, renders to PNG on demand; re-renders on every item equip/unequip action.
        - Implemented an event-polling indexer against an external server — refines and ingests events into MySQL with state-machine-based delivery guarantees.
        - Built a Fastify REST API server covering item crafting transactions, metadata management, and signature verification.
        - Rewrote a JS image compositor (hours-long runtime) in Rust — thread-pool-based parallel compositing reduced generation time from hours to minutes.
        - Built a marketplace server: event-polling indexer that refines and ingests external server events into MySQL, served via a Fastify API.
      ],
    ),
    (
      title-ko: "소프트웨어 엔지니어",
      title-en: "Software Engineer",
      org-ko: "HYPERITHM Co., Ltd. · 산업기능요원",
      org-en: "HYPERITHM Co., Ltd. · Industrial Technical Personnel",
      period-ko: "2019년 1월 – 2021년 10월",
      period-en: "Jan 2019 – Oct 2021",
      tags: ("Rust", "Go", "TypeScript"),
      body-ko: [
        - 중앙화 거래소(CEX) REST·WebSocket·FIX 프로토콜 클라이언트 Rust로 구현.
        - OrderServer 추상화로 다중 거래소를 지원하는 Order Execution System 구축 — actix-web HTTP API로 전략에 주문 생성·취소·잔고·포지션 조회 제공, MongoDB 기반 주문 상태 관리.
        - alpha strategy 백테스팅을 위한 S3 + MongoDB + Parquet 데이터 파이프라인 구축 — crossbeam 기반 병렬 실행.
      ],
      body-en: [
        - Implemented Rust REST, WebSocket, and FIX protocol clients for centralized exchanges (CEX).
        - Built a multi-exchange Order Execution System with an OrderServer abstraction — actix-web HTTP API exposing order create/cancel, balance, and position queries to strategies; MongoDB-backed order state management.
        - Built an S3 + MongoDB + Parquet data pipeline for alpha strategy backtesting — parallel execution via crossbeam.
      ],
    ),
  ),
  contributhon: (
    (year: "2021", org: "GlueSQL", role-ko: "멘티", role-en: "Mentee"),
    (year: "2022", org: "GlueSQL", role-ko: "멘토", role-en: "Mentor"),
    (year: "2023", org: "GlueSQL", role-ko: "멘토", role-en: "Mentor"),
  ),
  oss: (
    (
      project: "RustPython",
      repo: "RustPython/RustPython",
      url: "https://github.com/RustPython/RustPython/commits/main/?author=ever0de",
      period-ko: "2025.07 – 현재",
      period-en: "Jul 2025 – Present",
      tags: ("Rust", "Python"),
      stats: "★21.8k · 56 PRs",
      about-ko: "Rust로 구현한 CPython 호환 Python 인터프리터.",
      about-en: "CPython-compatible Python interpreter written in Rust.",
      contrib-ko: "sqlite3 stdlib CPython 동작 일치화 집중 기여.",
      contrib-en: "sqlite3 stdlib CPython-parity focus.",
    ),
    (
      project: "python/cpython",
      repo: "python/cpython",
      url: "https://github.com/python/cpython/pull/136538",
      period-ko: "2025.10",
      period-en: "Oct 2025",
      tags: ("C", "Python"),
      stats: "★71.8k · 1 PR",
      about-ko: "CPython 공식 저장소.",
      about-en: "The official CPython repository.",
      contrib-ko: "test_class.py의 Py_TPFLAGS_MANAGED_DICT 상수 잘못된 레이블 수정 (#136538).",
      contrib-en: "Fixed Py_TPFLAGS_MANAGED_DICT constant mislabeled in test_class.py (#136538).",
    ),
    (
      project: "GlueSQL",
      repo: "gluesql/gluesql",
      url: "https://github.com/gluesql/gluesql/commits/main/?author=ever0de",
      period-ko: "2021.08 – 2024.11",
      period-en: "Aug 2021 – Nov 2024",
      tags: ("Rust",),
      stats: "★3k · 89 PRs",
      about-ko: "Rust 기반 이식형 SQL 쿼리 엔진.",
      about-en: "Portable SQL query engine in Rust.",
      contrib-ko: "컨트리뷰톤 2021 멘티 → 2022–2023 멘토, 콜라보레이터.",
      contrib-en: "OSS Contributhon: 2021 mentee → 2022–2023 mentor, collaborator.",
    ),
    (
      project: "cdb64-rs",
      repo: "ever0de/cdb64-rs",
      url: "https://github.com/ever0de/cdb64-rs",
      period-ko: "2024 – 현재",
      period-en: "2024 – Present",
      tags: ("Rust",),
      stats: "author · ★17",
      about-ko: "cdb(cr.yp.to) 64비트 오프셋 확장 Rust 구현체.",
      about-en: "Rust implementation of cdb (cr.yp.to) with 64-bit offset extension.",
      contrib-ko: "기능 구현·바인딩·테스트·문서화 담당. 정해진 스펙에 따라 구현을 수행하고 호환성 및 테스트를 검증함.",
      contrib-en: "Implemented features, bindings, tests, and documentation. Implemented according to provided specs; validated compatibility and tests.",
    ),
    (
      project: "InjectiveLabs/cosmos-sdk",
      repo: "InjectiveLabs/cosmos-sdk",
      url: "https://github.com/InjectiveLabs/cosmos-sdk/pull/77",
      period-ko: "2025.09 – 2025.10",
      period-en: "Sep – Oct 2025",
      tags: ("Go",),
      stats: "1 PR",
      about-ko: "Injective 메인넷 구동 cosmos-sdk 포크.",
      about-en: "cosmos-sdk fork powering Injective mainnet.",
      contrib-ko: "CoW 인메모리 캐시(MemStore) warmup·lifecycle 구현 (#77).",
      contrib-en: "CoW in-memory cache (MemStore) warmup and lifecycle (#77).",
    ),
    (
      project: "cockroachdb/pebble",
      repo: "cockroachdb/pebble",
      url: "https://github.com/cockroachdb/pebble/pull/5458",
      period-ko: "2025.10",
      period-en: "Oct 2025",
      tags: ("Go",),
      stats: "★5.8k · 1 PR",
      about-ko: "CockroachDB 구동 Go LSM 스토리지 엔진.",
      about-en: "Go LSM storage engine powering CockroachDB.",
      contrib-ko: "TombstoneDenseCompactionThreshold 런타임 재설정을 옵션으로 노출 (#5458).",
      contrib-en: "Exposed TombstoneDenseCompactionThreshold as a runtime-reconfigurable option (#5458).",
    ),
    (
      project: "stc",
      repo: "dudykr/stc",
      url: "https://github.com/dudykr/stc/commits/main/?author=ever0de",
      period-ko: "2022.11",
      period-en: "Nov 2022",
      tags: ("Rust", "TypeScript"),
      stats: "★5.7k · 2 PRs",
      about-ko: "Rust 기반 TypeScript 타입 체커 (SWC 팀).",
      about-en: "Rust-based TypeScript type checker by the SWC team.",
      contrib-ko: "template literal type intrinsics 구현, 배열 패턴 기본값 오류 수정.",
      contrib-en: "Template literal type intrinsics and array pattern default value fix.",
    ),
    (
      project: "apache/opendal",
      repo: "apache/opendal",
      url: "https://github.com/apache/opendal/pull/5388",
      period-ko: "2024.12",
      period-en: "Dec 2024",
      tags: ("Rust",),
      stats: "★4.9k · 1 PR",
      about-ko: "다양한 스토리지 서비스를 단일 레이어로 추상화하는 Apache 프로젝트.",
      about-en: "Apache project providing a unified access layer over diverse storage services.",
      contrib-ko: "NonContiguous Buffer의 to_bytes에서 단일 청크일 때 불필요한 복사 제거 (#5388).",
      contrib-en: "Eliminated unnecessary copy in to_bytes when NonContiguous Buffer contains a single chunk (#5388).",
    ),
    (
      project: "tree-sitter-go-mod",
      repo: "camdencheek/tree-sitter-go-mod",
      url: "https://github.com/camdencheek/tree-sitter-go-mod/issues/16",
      period-ko: "2023.12 – 2024.06",
      period-en: "Dec 2023 – Jun 2024",
      tags: ("Rust",),
      stats: "★62 · 1 PR, 1 Issue",
      about-ko: "go.mod 파일용 tree-sitter 문법.",
      about-en: "tree-sitter grammar for go.mod files.",
      contrib-ko: "replace_directive 내 comment 파싱 오류 리포트 및 수정 방향 제안 (#16).",
      contrib-en: "Reported and proposed a fix for incorrect comment parsing inside replace_directive (#16).",
    ),
    (
      project: "simperby",
      repo: "postech-dao/simperby",
      url: "https://github.com/postech-dao/simperby/commits/main/?author=ever0de",
      period-ko: "2023.03",
      period-en: "Mar 2023",
      tags: ("Rust",),
      stats: "★74 · 3 PRs",
      about-ko: "분산 조직을 위한 BFT 블록체인 엔진.",
      about-en: "BFT blockchain engine for decentralized organizations.",
      contrib-ko: "ExtraAgendaTransaction 생성 통합 테스트 추가.",
      contrib-en: "Added integration test for ExtraAgendaTransaction creation.",
    ),
    (
      project: "sqlparser-rs",
      repo: "sqlparser-rs/sqlparser-rs",
      url: "https://github.com/sqlparser-rs/sqlparser-rs/pull/334",
      period-ko: "2021.08",
      period-en: "Aug 2021",
      tags: ("Rust",),
      stats: "★3.3k · 2 PRs",
      about-ko: "Rust 기반 확장 가능한 SQL 렉서·파서.",
      about-en: "Extensible SQL lexer and parser in Rust.",
      contrib-ko: "TRIM 표현식 파싱용 TrimWhereField 추가 및 테스트 작성 (#334).",
      contrib-en: "Added TrimWhereField for parse_trim_expr with tests (#334).",
    ),
  ),
)
