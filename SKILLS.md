# Skill Catalog & Routing — claude-skills-hub

Semua skill di bawah terpasang permanen di `~/.claude/skills` (user scope = berlaku di semua project & sesi). Tabel ini adalah panduan untuk Claude: **kapan memakai skill mana**.

| Kapan kebutuhan ini muncul | Pakai skill / command | Repo asal | Catatan |
|---|---|---|---|
| UI hasil AI terlihat "generic / AI slop" (gradient ungu, glow, emoji) | `unslop` → `/unslop this dashboard`, `/unslop <url>` | [heydamir/unslop](https://github.com/heydamir/unslop) | Audit → arah desain → pass spacing/warna/copy/type. CC-BY-4.0 |
| Tulisan terasa "AI banget" (prosa, email, dokumentasi) | `stop-slop` | [hardikpandya/stop-slop](https://github.com/hardikpandya/stop-slop) | Hapus AI tells dari prose |
| Prompt user vague / boros token, minta "perbaiki prompt ini" | `prompt-master` → `/prompt-master` | [nidhinjs/prompt-master](https://github.com/nidhinjs/prompt-master) | Ubah jadi Objective/Output/Scope/Stop-when; 37 pola pemboros kredit |
| Bikin aplikasi clone app lain (clean-room) | `/replica-recon` → architect → design → build → backend → test → diff → entrepreneur → brand → launch → deploy | [Jakeschincariol/replica-skill](https://github.com/jakeschincariol/replica-skill) | Wajib rebrand sebelum deploy (sweep.py) |
| Model 3D / scene Blender lewat agent | `blender-director` (meng-routing: hard-surface, character-artist, environment-artist, lighting, geometry-nodes, rigging, unreal-export, dst. — 94 skill) | [arjun988/blender-skills](https://github.com/arjun988/blender-skills) | **Prasyarat:** uv + BlenderMCP addon di Blender (N sidebar → BlenderMCP → Connect). Tanpa MCP aktif, skill tidak bisa eksekusi |
| Design system UI/UX untuk halaman/aplikasi baru | `ui-ux-pro-max` | [nextlevelbuilder/ui-ux-pro-max-skill](https://github.com/nextlevelbuilder/ui-ux-pro-max-skill) | 50+ style, 97 palet, lintas platform |
| Pola kerja berulang → jadikan skill baru; perbaiki skill lama otomatis | `task-observer` | [rebelytics/one-skill-to-rule-them-all](https://github.com/rebelytics/one-skill-to-rule-them-all) | Meta-skill |
| "Ada tidak ya skill siap pakai untuk X?" | `find-skills` / `npx skills` | [vercel-labs/skills](https://github.com/vercel-labs/skills) | Registry + installer skill ekosistem Vercel |
| AI membaca seluruh codebase tiap sesi (boros token) | `graphify` → `/graphify`, `graphify path "A" "B"` | [Graphify-Labs/graphify](https://github.com/Graphify-Labs/graphify) | Knowledge graph code+docs+PDF, query dulu bukan grep. Tool CLI: `npx graphify` / `pip install graphifyy` |
| Workflow startup penuh: review, QA, security, rilis | gstack: `/office-hours` `/review` `/qa` `/cso` `/ship` `/land-and-deploy` `/autoplan` `/pair-agent` `/browse` | [garrytan/gstack](https://github.com/garrytan/gstack) | 23 role. Butuh Bun v1.4.2+. **Pilih salah satu: gstack ATAU ECC** untuk workflow utama (tumpang tindih) |
| Toolbox kolektif (229 skills, 63 agents, hooks) | plugin `ecc@ecc` | [affaan-m/ECC](https://github.com/affaan-m/ECC) | Install via `/plugin marketplace add https://github.com/affaan-m/ECC` + `/plugin install ecc@ecc`. Jangan stack manual + plugin |
| Claude lupa konteks antar sesi | plugin `claude-mem` | [thedotmack/claude-mem](https://github.com/thedotmack/claude-mem) | Spawn sesi shadow → konsumsi token tambahan; nyalakan hanya bila butuh |

## Aturan pemasangan untuk Claude

1. Cek dulu `ls ~/.claude/skills` — **jangan install ulang** skill yang sudah ada.
2. Skill yang hilang/rusak → jalankan `bash ~/.claude/skills-src/claude-skills-hub/install.sh` (idempoten, ikut update channel repo masing-masing).
3. Plugin (`ecc@ecc`, `claude-mem`, `unslop` varian plugin) di-manage lewat `/plugin`, jangan disalin manual ke skills folder (duplikasi command).
4. blender-skills: sebelum memakai skill Blender, verifikasi BlenderMCP tersambung (Blender berjalan + addon Connect). Bila tidak, beritahu user, jangan simulasi.
5. Context budget: aktifkan MCP seperlunya (<10 server, <80 tools). graphify dan claude-mem sama-sama hemat konteks — jangan keduanya full-on kecuali perlu.

## Per-machine, permanen

Installer ini memasang ke **home folder user scope**, jadi:
- Semua sesi baru di mesin yang sama: skill langsung tersedia, tanpa install ulang.
- Mesin baru (PC kantor, laptop): jalankan repo ini sekali.
- Claude Code on web / device lain yang home-nya tidak sinkron: paste link repo ini + kata "install" — Claude akan clone dan menjalankan `install.sh` sendiri.
