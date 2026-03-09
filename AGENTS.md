# AGENTS

이 이력서는 국문/영문으로 내용이 나뉘어 있으며, **반드시 동시에 수정**해야 합니다.

## 파일 구조

| 파일 | 역할 |
|------|------|
| `resume_ko.typ` | 국문 이력서 레이아웃 |
| `resume.typ` | 영문 이력서 레이아웃 |
| `modules/metadata.typ` | 이름·연락처·기술스택·경력·OSS 기여 등 모든 이력서 데이터 (국/영문 동시 보유) |
| `modules/components.typ` | section, work-list, skills-grid, oss-table 등 레이아웃 컴포넌트 |

## 빌드

`.typ` 파일 수정 후 **반드시 SVG와 PDF 모두 컴파일**해야 합니다.

```sh
# SVG (다중 페이지, 페이지 번호 삽입)
typst compile resume_ko.typ "output/resume_ko_{p}.svg"
typst compile resume.typ "output/resume_{p}.svg"

# PDF (output/에 코미트)
typst compile resume_ko.typ output/resume_ko.pdf
typst compile resume.typ output/resume.pdf
```

## GitHub Permalink 가이드라인

이력서 내 `#link()`로 `public/` 문서를 참조할 때는 `main` 브랜치 대신 **특정 커밋 해시를 permalink로 사용**해야 합니다.  
`main`은 mutable이라 나중에 내용이 바뀌면 이력서에서 가리키는 문서가 달라질 수 있습니다.

### 해시 결정 방법

링크 대상 디렉토리를 **마지막으로 수정한 커밋 해시**를 사용합니다.

```sh
# 각 디렉토리별 마지막 커밋 해시 확인
git log --oneline -1 -- public/newmetric/cache/
git log --oneline -1 -- public/newmetric/pebble/
git log --oneline -1 -- public/newmetric/postmortem/
```

### 링크 형식

```typst
// ✅ Permalink (권장)
#link("https://github.com/ever0de/resume/tree/<HASH>/public/newmetric/cache")[링크 텍스트]

// ❌ main 사용 금지
#link("https://github.com/ever0de/resume/tree/main/public/newmetric/cache")[링크 텍스트]
```

### 해시 업데이트 시점

`public/` 하위 문서를 수정하고 새 커밋을 push한 뒤에는, `git log --oneline -1 -- <path>` 로 새 해시를 확인하고 `metadata.typ`의 링크를 갱신합니다.
