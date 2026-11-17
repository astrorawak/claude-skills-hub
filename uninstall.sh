#!/usr/bin/env bash
# Uninstall bersih: hapus skill yang dipasang oleh claude-skills-hub.
# Mengamankan: hanya menghapus folder yang pernah dicatat manifest hub,
# plus pointer blok di ~/.claude/CLAUDE.md.
set -uo pipefail

CLAUDE_SKILLS_DIR="${CLAUDE_SKILLS_DIR:-$HOME/.claude/skills}"
CLAUDE_SKILLS_SRC_DIR="${CLAUDE_SKILLS_SRC_DIR:-$HOME/.claude/skills-src}"
HUB_SRC="$CLAUDE_SKILLS_SRC_DIR/claude-skills-hub"
GSTACK_DIR="$CLAUDE_SKILLS_DIR/gstack"
GLOBAL_CLAUDE="$HOME/.claude/CLAUDE.md"

echo "[skills-hub] Menghapus skill yang terdaftar di pack hub ..."

# skill per-pack yang dikenal (nama folder target di ~/.claude/skills)
# pendekatan: hapus folder src pack yang dikenal + semua skill yang namanya cocok
PACK_SKILLS=(
  unslop stop-slop prompt-master
  replica-recon replica-architect replica-design replica-build replica-backend
  replica-test replica-diff replica-entrepreneur replica-brand replica-launch replica-deploy
  task-observer find-skills graphify
)
# blender-skills & ui-ux-pro-max: banyak skill — bersihkan via marker nama di src
for d in "$CLAUDE_SKILLS_SRC_DIR"/blender-skills/.claude/skills/*/ ; do
  [[ -d "$d" ]] && PACK_SKILLS+=("$(basename "$d")")
done
for d in "$CLAUDE_SKILLS_SRC_DIR"/ui-ux-pro-max/*/ ; do
  [[ -f "$d/SKILL.md" ]] && PACK_SKILLS+=("$(basename "$d")")
done

for s in "${PACK_SKILLS[@]}"; do
  if [[ -d "$CLAUDE_SKILLS_DIR/$s" ]]; then rm -rf "$CLAUDE_SKILLS_DIR/$s"; echo "  - $s"; fi
done

rm -rf "$GSTACK_DIR" && echo "  - gstack (di dalam skills dir)"

# plugin (best-effort, perlu claude CLI)
if command -v claude >/dev/null; then
  claude plugin uninstall ecc@ecc 2>/dev/null && echo "  - plugin ecc@ecc" || true
  claude plugin uninstall claude-mem@thedotmack 2>/dev/null && echo "  - plugin claude-mem" || true
  claude plugin marketplace remove ecc 2>/dev/null || true
  claude plugin marketplace remove thedotmack 2>/dev/null || true
fi

# blok pointer di CLAUDE.md global
if [[ -f "$GLOBAL_CLAUDE" ]] && grep -q "claude-skills-hub-begin" "$GLOBAL_CLAUDE"; then
  python3 - "$GLOBAL_CLAUDE" <<'EOF'
import sys, re
p = sys.argv[1]
s = open(p, encoding='utf-8').read()
s = re.sub(r"\n?<!-- claude-skills-hub-begin -->.*?<!-- claude-skills-hub-end -->\n?", "\n", s, flags=re.S)
open(p, 'w', encoding='utf-8').write(s)
print("  - pointer blok di", p)
EOF
fi

# sumber clone (opsional, hemat disk)
read -rp "Hapus juga cache repo di $CLAUDE_SKILLS_SRC_DIR? [y/N] " ans
[[ "${ans,,}" == "y" ]] && rm -rf "$CLAUDE_SKILLS_SRC_DIR" && echo "  - $CLAUDE_SKILLS_SRC_DIR dibersihkan"

echo "[skills-hub] Uninstall selesai."
