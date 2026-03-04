# AGENTS

이 이력서는 두 파일로 내용이 나뉘어 있으며, **반드시 동시에 수정**해야 합니다.

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
