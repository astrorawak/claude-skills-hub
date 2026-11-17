# SETUP-MAC — pasang semua skill di Claude Code pada Mac kamu

Hasil akhir: `~/.claude/skills` berisi ±118 skill (user scope) → otomatis tersedia di **setiap sesi & setiap project** Claude Code di Mac ini, termasuk sesi baru di terminal mana pun. Sekali jalan. Update cukup jalankan ulang.

## Langkah 1 — Prasyarat (buka Terminal / iTerm)

```bash
# git + toolchain (dialog Apple, klik Install)
xcode-select --install 2>/dev/null || true

# bun — dibutuhkan ./setup gstack
curl -fsSL https://bun.sh/install | bash

# uv — cara bersih install CLI graphify di macOS (menghindari PEP668 pip sistem)
curl -LsSf https://astral.sh/uv/install.sh | sh

# Claude Code CLI — kalau belum ada
curl -fsSL https://claude.ai/install.sh | bash   # atau: npm install -g @anthropic-ai/claude-code

# MUAT TERLEBIH DAHULU PATH baris baru, lalu TUTUP-BUKA terminal
source ~/.zshrc
command -v bun && command -v uv && claude --version
```

## Langkah 2 — Installer sekali jalan

```bash
git clone https://github.com/astrorawak/claude-skills-hub.git ~/claude-skills-hub
bash ~/claude-skills-hub/install.sh
```

Yang dilakukan skrip (semua dari sumber resmi, terdaftar di `install.sh`):
1. Clone + pasang 8 pack ke `~/.claude/skills` (unslop, stop-slop, prompt-master, replica ×11, blender ×94, ui-ux-pro-max, task-observer, find-skills).
2. graphify: `uv tool install graphifyy` lalu `graphify install` (mendaftarkan skill + hook-nya sendiri).
3. gstack: clone ke `~/.claude/skills/gstack` + `./setup` (butuh bun dari Langkah 1).
4. ECC & claude-mem: dicoba via `claude plugin ...`; bila CLI menolak headless, skrip mencetak 2 perintah untuk Langkah 3.
5. Menyuntik blok pointer `claude-skills-hub` ke `~/.claude/CLAUDE.md` (global memory) — sekali saja, tidak dobel.

## Langkah 3 — Dua plugin di dalam sesi Claude Code

Jalankan `claude` di folder mana saja, lalu ketik:

```
/plugin marketplace add https://github.com/affaan-m/ECC
/plugin install ecc@ecc
/plugin marketplace add thedotmack/claude-mem
/plugin install claude-mem@claude-mem
/reload-plugins
```

Pilihan saya untuk workflow kamu: **ECC install; claude-mem install tapi biarkan OFF** dulu — shadow agent-nya menyedot token dan fungsi memorinya di Mac kamu sudah dilapisi graphify + blok pointer CLAUDE.md. Nyalakan kalau ternyata benar-benar butuh.

## Langkah 4 — Verifikasi

```bash
bash ~/.claude/skills-src/claude-skills-hub/install.sh --verify
```

Cek cepat di dalam Claude Code: ketik `/` dan pastikan muncul `/unslop`, `/replica-recon`, `/graphify`, `/ship` (gstack). Skill dengan trigger-deskripsi (prompt-master, stop-slop, ui-ux-pro-max, task-observer, find-skills, blender-*) tidak muncul sebagai command — mereka auto-invoked saat request cocok, sesuai tabel routing `SKILLS.md`.

## Troubleshooting umum di macOS

| Gejala | Solusi |
|---|---|
| `bun: command not found` saat ./setup gstack | tutup-buka terminal, atau `export PATH="$HOME/.bun/bin:$PATH"` lalu `cd ~/.claude/skills/gstack && ./setup` |
| graphify terpasang tapi `/graphify` tidak ada | jalankan manual: `graphify install` (dari repo project kamu) |
| claude-mem terasa menyedot token | `/plugin` → disable claude-mem; aman |
| /plugin install ECC konflik scope scope | jangan campur manual-copy; jalankan `claude plugin list` dulu, uninstall duplikatnya |
| Blender skill menolak eksekusi | nyalakan Blender → sidebar `N` → BlenderMCP → Connect to Claude (plus addon dari [ahujasid/blender-mcp](https://github.com/ahujasid/blender-mcp), `uv` sudah ada dari Langkah 1) |
| Skill tidak muncul di sesi baru | pastikan kamu menjalankan Claude Code dengan user macOS yang sama (skill per-user, bukan per-sistem) |

## Update & mesin lain

- Update semua pack: `bash ~/claude-skills-hub/install.sh` (idempoten).
- Pasang di Mac kedua / laptop: ulangi Langkah 1–2 di sana.
- Claude Code on web: sambungkan repo `astrorawak/claude-skills-hub` per task, jalankan Langkah 2 (±2 menit).
