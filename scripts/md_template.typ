// pandoc markdown → typst → PDF 변환용 템플릿
// 이미지 최대 너비 제한, 제목 자동 생성 없음

#let horizontalrule = line(length: 100%, stroke: 0.5pt + luma(180))

#set page(
  paper: "a4",
  margin: (x: 2.5cm, y: 2.5cm),
)

#set text(
  font: ("Pretendard", "Apple SD Gothic Neo"),
  size: 10.5pt,
  lang: "ko",
)

#set par(
  leading: 0.8em,
  justify: true,
)

#set heading(numbering: none)

#show heading.where(level: 1): it => {
  v(1.2em)
  text(weight: "bold", size: 16pt)[#it.body]
  v(0.5em)
}

#show heading.where(level: 2): it => {
  v(0.8em)
  text(weight: "bold", size: 13pt)[#it.body]
  v(0.3em)
}

#show heading.where(level: 3): it => {
  v(0.5em)
  text(weight: "bold", size: 11pt)[#it.body]
  v(0.2em)
}

// 이미지를 페이지 너비에 맞게 제한 (빈 페이지 방지)
#show figure.where(kind: image): it => {
  block(width: 100%, breakable: false)[
    #align(center)[
      #box(width: 100%)[#it.body]
    ]
    #if it.caption != none {
      v(0.3em)
      align(center)[#text(size: 9pt, fill: luma(100))[#it.caption]]
    }
  ]
}

#show figure.where(kind: table): set figure.caption(position: top)

#set table(
  inset: 6pt,
  stroke: 0.5pt + luma(200),
)

#show table: set text(size: 9.5pt)

#show link: underline

#show terms.item: it => block(breakable: false)[
  #text(weight: "bold")[#it.term]
  #block(inset: (left: 1.5em, top: -0.4em))[#it.description]
]

// blockquote 스타일
#show quote.where(block: true): it => {
  block(
    inset: (left: 1em, y: 0.5em),
    stroke: (left: 3pt + luma(180)),
    fill: luma(245),
    radius: 2pt,
    width: 100%,
  )[
    #text(fill: luma(80))[#it.body]
  ]
}

$body$
