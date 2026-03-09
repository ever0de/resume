// ─────────────────────────────────────────────────────────────────────────────
// Jiseok Choi — Résumé (English)
// Korean version: resume_ko.typ
// Modules: modules/metadata.typ, modules/components.typ
// ─────────────────────────────────────────────────────────────────────────────

#import "modules/metadata.typ": metadata
#import "modules/components.typ": *

// ── Page & Text setup ────────────────────────────────────────────────────────
#set document(title: "Jiseok Choi - Resume", author: "Jiseok Choi")
#set page(
  paper: "a4",
  margin: (top: 1.4cm, left: 1.6cm, right: 1.6cm, bottom: 1.6cm),
  footer: context [
    #set text(size: 7.5pt, fill: luma(150))
    #text[As of #datetime.today().display("[year].[month].[day]")]
    #h(1fr)
    #link("https://github.com/ever0de/resume")[Korean: resume_ko.typ]
    #h(8pt)
    #box(fill: luma(40), radius: 2pt, inset: (x: 5pt, y: 2pt))[
      #text(fill: white, weight: 700)[#counter(page).display("1")]
    ]
  ],
)
#set text(
  font: ("Pretendard", "Helvetica Neue", "Arial"),
  size: 9.5pt,
  lang: "en",
)
#set par(leading: 0.62em)
#show heading: set block(above: 1.0em, below: 0.4em)

// ─────────────────────────────────────────────────────────────────────────────
// HEADER
// ─────────────────────────────────────────────────────────────────────────────

#grid(
  columns: (1fr, auto),
  [
    #text(size: 26pt, weight: 900)[#metadata.name.english]
    #v(-5pt)
    #text(size: 10.5pt, weight: 500, fill: subtle)[#metadata.role.en]
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
#v(3pt)
#text(size: 9pt, fill: luma(80), style: "italic")[#metadata.bio.en]
#v(6pt)

// ─────────────────────────────────────────────────────────────────────────────
// SKILLS
// ─────────────────────────────────────────────────────────────────────────────

#section("Skills", lang: "en")

#skills-grid(metadata.skills, lang: "en")

#v(2pt)

// ─────────────────────────────────────────────────────────────────────────────
// WORK EXPERIENCE
// ─────────────────────────────────────────────────────────────────────────────

#section("Work Experience", lang: "en")

#work-list(metadata.work, lang: "en")

// ─────────────────────────────────────────────────────────────────────────────
// OPEN SOURCE
// ─────────────────────────────────────────────────────────────────────────────

#pagebreak()
#section("Open Source", lang: "en")

#oss-table(metadata.oss, lang: "en")
