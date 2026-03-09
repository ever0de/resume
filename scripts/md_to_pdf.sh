#!/usr/bin/env bash
# public/newmetric 하위 README.md → PDF 일괄 변환
# 사용: ./scripts/md_to_pdf.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATE="$SCRIPT_DIR/md_template.typ"
ROOT="$SCRIPT_DIR/../public/newmetric"

dirs=(cache pebble postmortem)

for d in "${dirs[@]}"; do
  src="$ROOT/$d/README.md"
  out="$ROOT/$d/$d.pdf"
  if [[ ! -f "$src" ]]; then
    echo "skip: $src not found"
    continue
  fi
  echo "converting $d ..."
  # 내부 앵커 링크(#anchor) 제거 후 변환 — typst label 불일치 방지
  sed -E 's/\[([^]]+)\]\(#[^)]+\)/\1/g' "$src" \
    | pandoc --pdf-engine=typst --template="$TEMPLATE" -o "$out"
  echo "  → $out"
done

echo "done."
