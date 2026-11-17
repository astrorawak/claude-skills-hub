#!/usr/bin/env bash
# ============================================================================
# claude-skills-hub — installer permanen skill Claude Code (user scope)
# Sekali jalan per mesin. Skill terpasang di ~/.claude/skills sehingga
# otomatis dikenali di SEMUA sesi & project Claude Code pada mesin itu.
#
# Pakai:  bash install.sh
# Opsi:   SKIP="gstack,ECC (everything-claude-code),claude-mem" bash install.sh
#         bash install.sh --verify    (daftar skill terpasang, tanpa ubah)
# Jalankan ulang kapan saja = pull + pasang versi terbaru.
# ============================================================================
set -uo pipefail

SKILLS_DIR="${SKILLS_DIR:-$HOME/.claude/skills}"
SRC_DIR="${SRC_DIR:-$HOME/.claude/skills-src}"
HUB_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKIP="${SKIP:-}"
MODE="${1:-install}"

log()  { printf '\033[1;36m[skills-hub]\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m[skills-hub!] %s\n\033[0m' "$*"; }
fail() { printf '\033[1;31m[skills-hubX] %s\n\033[0m' "$*"; }
skipped() { [[ ",${SKIP}," == *",$1,"* ]]; }

# ---------------------------------------------------------------------------
# Pack reguler (deteksi struktur otomatis):
#   priority 1: <repo>/.claude/skills/*/SKILL.md
#   priority 2: <repo>/skills/*/SKILL.md
#   priority 3: <repo>/SKILL.md (repo = 1 skill)
#   priority 4: scan repo, folder berisi SKILL.md (prune, tanpa .git)
# ---------------------------------------------------------------------------
declare -a PACKS=(
  "prompt-master|nidhinjs/prompt-master"
  "unslop|heydamir/unslop"
  "stop-slop|hardikpandya/stop-slop"
  "replica-skill|Jakeschincariol/replica-skill"
  "blender-skills|arjun988/blender-skills"
  "ui-ux-pro-max|nextlevelbuilder/ui-ux-pro-max-skill"
  "task-observer|rebelytics/one-skill-to-rule-them-all"
  "find-skills|vercel-labs/skills"
)

mkdir -p "$SKILLS_DIR" "$SRC_DIR"
export PATH="$HOME/.local/bin:$PATH"

clone_repo() { # $1 name $2 repo -> stdout path
  local name="$1" repo="$2" dir="$SRC_DIR/$name"
  if [[ -d "$dir/.git" ]]; then
    git -C "$dir" fetch -q --depth 1 origin && git -C "$dir" reset -q --hard origin/HEAD 2>/dev/null \
      || git -C "$dir" pull -q --depth 1 origin || warn "update $name gagal (pakai cache lokal)"
  else
    rm -rf "$dir"
    git clone -q --depth 1 "https://github.com/$repo.git" "$dir" || { fail "clone gagal: $repo"; return 1; }
  fi
  echo "$dir"
}

has_skillmd() { [[ -f "$1/SKILL.md" ]]; }

find_skill_roots() { # $1 clone dir -> daftar abs folder skill
  local d="$1" b
  for b in "$d/.claude/skills" "$d/skills"; do
    [[ -d "$b" ]] && { find "$b" -mindepth 1 -maxdepth 1 -type d -exec sh -c 'test -f "$1/SKILL.md"' _ {} \; -print; return; }
  done
  if has_skillmd "$d"; then echo "$d"; return; fi
  find "$d" \( -name .git -o -name node_modules -o -name assets -o -name examples \) -prune -o \
       -type d -exec sh -c 'test -f "$1/SKILL.md"' _ {} \; -prune -print
}

install_pack() { # $1 name $2 repo
  local name="$1" repo="$2"
  if skipped "$name"; then warn "SKIP $name"; return 0; fi
  log "Pasang $name ($repo) ..."
  local dir roots; dir="$(clone_repo "$name" "$repo")" || return 1
  roots="$(find_skill_roots "$dir")"
  if [[ -z "$roots" ]]; then warn "$name: tidak ada SKILL.md — cek README $repo"; return 0; fi
  local n=0
  while IFS= read -r sd; do
    local tgt="$SKILLS_DIR/$(basename "$sd")"
    rm -rf "$tgt"; mkdir -p "$tgt"
    cp -R "$sd/." "$tgt/"
    n=$((n+1))
  done <<< "$roots"
  log "  $n skill terpasang"
}

if [[ "$MODE" == "--verify" ]]; then
  log "Skill di $SKILLS_DIR:"
  find "$SKILLS_DIR" -maxdepth 2 -name SKILL.md 2>/dev/null | sed "s|$SKILLS_DIR/||;s|/SKILL.md||" | sort
  log "Total: $(find "$SKILLS_DIR" -maxdepth 2 -name SKILL.md 2>/dev/null | wc -l | tr -d ' ') skill"
  exit 0
fi

command -v git >/dev/null || { fail "git tidak ditemukan. Install git dulu."; exit 1; }

for pack in "${PACKS[@]}"; do
  IFS='|' read -r name repo <<< "$pack"
  install_pack "$name" "$repo" || true
done

# --- graphify: pakai installer resmi (CLI + skill registration) -------------
install_graphify() {
  if skipped "graphify"; then warn "SKIP graphify"; return 0; fi
  log "Pasang graphify (Graphify-Labs/graphify) ..."
  if ! command -v graphify >/dev/null; then
    (command -v pip3 >/dev/null && pip3 install --user -q graphifyy) >/dev/null 2>&1 \
      || (command -v uv >/dev/null && uv tool install -q graphifyy) >/dev/null 2>&1 \
      || warn "pip install graphifyy gagal (mungkin perlu python3-venv)"
    hash -r 2>/dev/null || true
  fi
  if command -v graphify >/dev/null && graphify install; then
    log "  graphify skill diregistrasi oleh installer resmi"
  else
    # fallback manual dari sumber repo
    local dir; dir="$(clone_repo graphify Graphify-Labs/graphify)" || return 1
    if [[ -f "$dir/graphify/skill-claude.md" ]]; then
      mkdir -p "$SKILLS_DIR/graphify"
      cp "$dir/graphify/skill-claude.md" "$SKILLS_DIR/graphify/SKILL.md"
      log "  1 skill (fallback dari skill-claude.md). CLI graphify belum ada — jalankan: pip install --user graphifyy"
    else
      warn "graphify: butuh CLI resmi — jalankan manual: pip install --user graphifyy && graphify install"
    fi
  fi
}
install_graphify || true

# --- gstack: clone ke skills dir + ./setup resmi -----------------------------
if ! skipped "gstack"; then
  log "Pasang gstack (garrytan/gstack) ..."
  gdir="$SKILLS_DIR/gstack"
  if [[ -d "$gdir/.git" ]]; then git -C "$gdir" pull -q origin || warn "pull gstack gagal"
  else rm -rf "$gdir"; git clone -q --single-branch --depth 1 https://github.com/garrytan/gstack.git "$gdir" || fail "clone gstack gagal"; fi
  if [[ -x "$gdir/setup" ]]; then
    if command -v bun >/dev/null; then ( cd "$gdir" && ./setup ) || warn "./setup gstack gagal — jalankan manual"
    else warn "Bun belum terpasang -> ./setup gstack DILEWATI. Install bun (https://bun.sh), lalu: cd $gdir && ./setup"; fi
  fi
fi

# --- plugin via Claude Code CLI (ECC & claude-mem) ---------------------------
install_plugin() { # $1 marketplace $2 slug $3 label
  if skipped "$3"; then warn "SKIP $3"; return 0; fi
  if command -v claude >/dev/null; then
    log "Pasang plugin $3 ..."
    claude plugin marketplace add "$1" 2>/dev/null || true
    claude plugin install "$2" 2>/dev/null \
      || warn "$3 gagal via CLI — di dalam Claude Code jalankan: /plugin marketplace add $1 lalu /plugin install $2"
  else
    warn "$3: butuh Claude Code CLI. Jalankan di terminal PC kamu: claude plugin marketplace add \"$1\" && claude plugin install $2"
  fi
}
install_plugin "https://github.com/affaan-m/ECC" "ecc@ecc" "ECC (everything-claude-code)"
install_plugin "thedotmack/claude-mem" "claude-mem@claude-mem" "claude-mem"

# --- catatan blender MCP -------------------------------------------------------
warn "blender-skills: skill 3D butuh Blender berjalan + addon BlenderMCP tersambung (N sidebar > BlenderMCP > Connect). Setup: https://github.com/ahujasid/blender-mcp"

# --- simpan salinan hub + pointer global ---------------------------------------
mkdir -p "$SRC_DIR/claude-skills-hub"
rsync -a --exclude '.git' "$HUB_DIR/" "$SRC_DIR/claude-skills-hub/" 2>/dev/null || cp -R "$HUB_DIR"/. "$SRC_DIR/claude-skills-hub/" 2>/dev/null || true

GLOBAL_CLAUDE="$HOME/.claude/CLAUDE.md"
mkdir -p "$HOME/.claude"; touch "$GLOBAL_CLAUDE"
if ! grep -q "claude-skills-hub-begin" "$GLOBAL_CLAUDE"; then
  cat >> "$GLOBAL_CLAUDE" <<'EOF'

<!-- claude-skills-hub-begin -->
## Skill Hub (permanent install)
A curated skill pack set is installed at ~/.claude/skills (user scope, all projects & sessions).
Catalog & routing guide: ~/.claude/skills-src/claude-skills-hub/SKILLS.md — consult it before picking a skill.
If a skill is missing or broken, run: bash ~/.claude/skills-src/claude-skills-hub/install.sh
Do not re-download or duplicate skills already present under ~/.claude/skills.
<!-- claude-skills-hub-end -->
EOF
  log "Pointer Skill Hub ditambahkan ke $GLOBAL_CLAUDE"
fi

N="$(find "$SKILLS_DIR" -maxdepth 2 -name SKILL.md 2>/dev/null | wc -l | tr -d ' ')"
log "SELESAI. Total $N skill tersedia di $SKILLS_DIR — otomatis aktif di sesi Claude Code baru."
log "Mesin baru: jalankan repo ini sekali. Update: jalankan ulang install.sh."
