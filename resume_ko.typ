// ─────────────────────────────────────────────────────────────────────────────
// 최지석 — 이력서 (국문)
// 영문 버전: resume.typ
// 모듈: modules/metadata.typ, modules/components.typ
// ─────────────────────────────────────────────────────────────────────────────

#import "modules/metadata.typ": metadata
#import "modules/components.typ": *

// ── 페이지 & 텍스트 설정 ─────────────────────────────────────────────────────
#set document(title: "최지석 이력서", author: "최지석")
#set page(
  paper: "a4",
  margin: (top: 1.4cm, left: 1.6cm, right: 1.6cm, bottom: 1.6cm),
  footer: context [
    #h(1fr)
    #box(fill: luma(40), radius: 2pt, inset: (x: 5pt, y: 2pt))[
      #text(fill: white, weight: 700, size: 7.5pt)[#counter(page).display("1")]
    ]
  ],
)
#set text(
  font: ("Pretendard", "Apple SD Gothic Neo"),
  size: 9.5pt,
  lang: "ko",
)
#set par(leading: 0.72em)
#show heading: set block(above: 1.0em, below: 0.4em)
#show link: it => text(fill: accent)[#it]

// ─────────────────────────────────────────────────────────────────────────────
// 헤더
// ─────────────────────────────────────────────────────────────────────────────

#grid(
  columns: (1fr, auto),
  [
    #text(size: 26pt, weight: 900)[#metadata.name.korean]
    #h(10pt)
    #text(size: 13pt, weight: 300, fill: luma(80))[#metadata.name.english]
    #v(-5pt)
    #text(size: 10.5pt, weight: 500, fill: subtle)[#metadata.role.ko]
  ],
  align(right + horizon)[
    #set text(size: 8.5pt)
    #link("mailto:" + metadata.contact.email)[#metadata.contact.email] \
    #link-styled(
      "https://github.com/" + metadata.contact.github,
      "github.com/" + metadata.contact.github,
    ) \
  ],
)

#line(length: 100%, stroke: 1pt)
#v(4pt)
#text(size: 9pt, fill: luma(80), style: "italic")[#metadata.bio.ko]
#v(6pt)

// ─────────────────────────────────────────────────────────────────────────────
// 기술 스택
// ─────────────────────────────────────────────────────────────────────────────

#section("기술 스택")

#skills-grid(metadata.skills, lang: "ko")

#v(2pt)

// ─────────────────────────────────────────────────────────────────────────────
// 경력
// ─────────────────────────────────────────────────────────────────────────────

#section("경력")

#work-list(metadata.work, lang: "ko")

// ─────────────────────────────────────────────────────────────────────────────
// 오픈소스 기여
// ─────────────────────────────────────────────────────────────────────────────

#pagebreak()
#section("오픈소스 기여")

#oss-table(metadata.oss, lang: "ko")
