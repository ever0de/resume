# 최지석 이력서 / Jiseok Choi — Résumé

<table>
<tr>
<td><b>국문</b></td>
<td><b>English</b></td>
</tr>
<tr>
<td><img alt="국문 이력서 (1/2)" src="./resume_ko_1.svg" width="400"></td>
<td><img alt="English résumé (1/2)" src="./resume_1.svg" width="400"></td>
</tr>
<tr>
<td><img alt="국문 이력서 (2/2)" src="./resume_ko_2.svg" width="400"></td>
<td><img alt="English résumé (2/2)" src="./resume_2.svg" width="400"></td>
</tr>
</table>

## 빌드

```sh
# SVG for multi-page output (adds page number into filename)
typst compile resume_ko.typ "resume_ko_{p}.svg"
typst compile resume.typ "resume_{p}.svg"

# or produce single-file PDF
typst compile resume_ko.typ
typst compile resume.typ
```
