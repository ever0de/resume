# 최지석 이력서 / Jiseok Choi — Résumé

<table>
<tr>
<td><b>국문</b></td>
<td><b>English</b></td>
</tr>
<tr>
<td><img alt="국문 이력서 (1/2)" src="./output/resume_ko_1.svg" width="400"></td>
<td><img alt="English résumé (1/2)" src="./output/resume_1.svg" width="400"></td>
</tr>
<tr>
<td><img alt="국문 이력서 (2/2)" src="./output/resume_ko_2.svg" width="400"></td>
<td><img alt="English résumé (2/2)" src="./output/resume_2.svg" width="400"></td>
</tr>
</table>

## Newmetric 재직 중 작성한 문서

| 파일 | 내용 |
|------|------|
| [public/newmetric/mvcc.md](public/newmetric/mvcc.md) | Pebble 위에 MVCC를 얹은 cosmos-sdk KV 스토어에서 tombstone 키 누적으로 인한 반복자 성능 저하 문제 분석 — Key/Archive 이중 테이블, MVCC Comparer, CoW BTree 등 스키마별 트레이드오프 탐구 |
| [public/newmetric/study/](public/newmetric/study/) | Rust 스터디 자료 (스크린샷 3장) |

## 빌드

```sh
# SVG for multi-page output (adds page number into filename)
typst compile resume_ko.typ "output/resume_ko_{p}.svg"
typst compile resume.typ "output/resume_{p}.svg"

# or produce single-file PDF
typst compile resume_ko.typ
typst compile resume.typ
```
