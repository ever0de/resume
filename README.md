# 최지석 이력서 / Jiseok Choi — Résumé

> **모바일 사용자**: [국문 PDF](./output/resume_ko.pdf) · [English PDF](./output/resume.pdf)

## Preview

| 국문 | English |
|------|---------|
| ![](./output/resume_ko_1.svg) | ![](./output/resume_1.svg) |
| ![](./output/resume_ko_2.svg) | ![](./output/resume_2.svg) |

## Newmetric 재직 중 작성한 문서

| 파일 | 내용 |
|------|------|
| [public/newmetric/mvcc.md](public/newmetric/mvcc.md) | Pebble 위에 MVCC를 얹은 cosmos-sdk KV 스토어에서 tombstone 키 누적으로 인한 반복자 성능 저하 문제 분석 — Key/Archive 이중 테이블, MVCC Comparer, CoW BTree 등 스키마별 트레이드오프 탐구 |
| [public/newmetric/study/](public/newmetric/study/) | Rust 스터디 자료 (스크린샷 3장) |

## 빌드

한 줄로 SVG, PDF, PNG 모두 생성:

```sh
./build.sh
```

또는 개별 컴파일:

```sh
# SVG (multi-page output)
typst compile resume_ko.typ "output/resume_ko_{p}.svg"
typst compile resume.typ "output/resume_{p}.svg"

# PDF
typst compile resume_ko.typ output/resume_ko.pdf
typst compile resume.typ output/resume.pdf

# PNG thumbnails (from SVG first page)
convert -density 300 output/resume_ko_1.svg output/resume_ko_thumb.png
convert -density 300 output/resume_1.svg output/resume_thumb.png
```
