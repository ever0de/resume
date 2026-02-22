// ─────────────────────────────────────────────────────────────────────────────
// 공통 UI 컴포넌트 (Shared UI Components)
// ─────────────────────────────────────────────────────────────────────────────

// ── 색상 팔레트 ──────────────────────────────────────────────────────────────
#let accent = rgb("#1c7ed6")
#let subtle = luma(110)
#let tag-bg = luma(235)

// ── 링크 스타일 ──────────────────────────────────────────────────────────────
#let link-styled(url, label) = {
  show link: underline
  link(url)[#text(fill: accent)[#label]]
}

// ── 섹션 헤더 (한글/영문 공통) ───────────────────────────────────────────────
#let section(title, lang: "ko") = {
  block(above: 1.2em, below: 0em)[
    #if lang == "ko" {
      text(size: 11.5pt, weight: 800, tracking: 0.5pt)[#title]
    } else {
      text(size: 11.5pt, weight: 800, tracking: 1pt)[#upper(title)]
    }
    #line(length: 100%, stroke: 0.5pt + luma(200))
  ]
}

// ── 태그 칩 ─────────────────────────────────────────────────────────────────
#let tag(body) = box(
  inset: (x: 4pt, y: 1.5pt),
  radius: 3pt,
  fill: tag-bg,
)[#text(size: 7.5pt, weight: 600)[#body]]

// ── 경력/프로젝트 엔트리 ─────────────────────────────────────────────────────
#let entry(
  title: "",
  org: "",
  period: "",
  tags: (),
  body,
) = {
  grid(
    columns: (1fr, auto),
    gutter: 6pt,
    [
      #text(size: 10.5pt, weight: 700)[#title]
      #if org != "" [ #h(3pt) #text(fill: subtle, size: 9.5pt)[#sym.at #org] ]
    ],
    align(right)[#text(fill: subtle, size: 8.5pt)[#period]],
  )
  if tags.len() > 0 {
    block(above: 2pt, below: 3pt)[
      #tags.map(t => tag(t)).join(h(3pt))
    ]
  }
  block(above: 3pt)[#body]
  v(5pt)
}

// ── 기술 스택 그리드 (메타데이터 기반) ──────────────────────────────────────
#let skills-grid(skills, lang: "ko") = {
  let col-w = if lang == "ko" { 80pt } else { 90pt }
  grid(
    columns: (col-w, 1fr),
    rows: auto,
    row-gutter: 5pt,
    column-gutter: 6pt,
    ..skills
      .map(s => {
        let label = if lang == "ko" { s.label-ko } else { s.label-en }
        (
          text(weight: 700, size: 9pt, fill: luma(30))[#label],
          text(size: 9pt)[#s.value],
        )
      })
      .flatten(),
  )
}

// ── 경력 목록 (메타데이터 기반) ───────────────────────────────────────────────
#let work-list(work, lang: "ko") = {
  for w in work {
    let title = if lang == "ko" { w.title-ko } else { w.title-en }
    let org = if lang == "ko" { w.org-ko } else { w.org-en }
    let period = if lang == "ko" { w.period-ko } else { w.period-en }
    let body = if lang == "ko" { w.body-ko } else { w.body-en }
    entry(title: title, org: org, period: period, tags: w.tags, body)
  }
}

// ── OSS 기여 테이블 (한 줄 요약 형식) ────────────────────────────────────────
#let oss-table(items, lang: "ko") = {
  set par(leading: 0.52em)
  table(
    columns: (auto, auto, auto, 1fr, 1fr),
    inset: (x: 4pt, y: 3pt),
    stroke: none,
    fill: (col, row) => if calc.even(row) { luma(248) } else { white },
    // 헤더
    table.cell[
      #text(size: 7.5pt, weight: 700, fill: subtle)[#if lang == "ko" { "프로젝트" } else { "Project" }]
    ],
    table.cell[
      #text(size: 7.5pt, weight: 700, fill: subtle)[#if lang == "ko" { "기간" } else { "Period" }]
    ],
    table.cell[
      #text(size: 7.5pt, weight: 700, fill: subtle)[#if lang == "ko" { "기여 규모" } else { "Scale" }]
    ],
    table.cell[
      #text(size: 7.5pt, weight: 700, fill: subtle)[#if lang == "ko" { "프로젝트 소개" } else { "About" }]
    ],
    table.cell[
      #text(size: 7.5pt, weight: 700, fill: subtle)[#if lang == "ko" { "기여 내용" } else { "Contribution" }]
    ],
    // 데이터 행
    ..items
      .map(item => {
        let period = if lang == "ko" { item.period-ko } else { item.period-en }
        let about = if lang == "ko" { item.about-ko } else { item.about-en }
        let contrib = if lang == "ko" { item.contrib-ko } else { item.contrib-en }
        (
          table.cell[
            #link("https://github.com/" + item.repo)[
              #text(size: 8pt, weight: 700, fill: accent)[#item.project]
            ]
            #linebreak()
            #item.tags.map(t => tag(t)).join(h(2pt))
          ],
          table.cell[
            #text(size: 7.5pt, fill: subtle)[#period]
          ],
          table.cell[
            #text(size: 7.5pt, weight: 600)[#item.stats]
          ],
          table.cell[
            #set text(size: 8pt)
            #about
          ],
          table.cell[
            #set text(size: 8pt)
            #contrib
          ],
        )
      })
      .flatten(),
  )
}
