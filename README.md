# claude-skills-hub

Satu repo untuk memasang **semua skill Claude Code hasil riset** (Nov 2026) sekaligus, **permanen di level user** — aktif di semua project, semua sesi, semua window Claude Code di mesin kamu. Sekali jalan per mesin; jalankan ulang kapan saja = update.

## Isi skill pack

| Pack | Source repo | Fungsi singkat |
|---|---|---|
| unslop | [heydamir/unslop](https://github.com/heydamir/unslop) | UI hasil AI → terlihat didesain profesional |
| stop-slop | [hardikpandya/stop-slop](https://github.com/hardikpandya/stop-slop) | Hapus pola tulisan "AI" dari prose |
| prompt-master | [nidhinjs/prompt-master](https://github.com/nidhinjs/prompt-master) | Prompt presisi, hemat token/kredit |
| replica-skill (11 skill) | [Jakeschincariol/replica-skill](https://github.com/jakeschincariol/replica-skill) | Clone aplikasi clean-room end-to-end |
| blender-skills (94 skill) | [arjun988/blender-skills](https://github.com/arjun988/blender-skills) | 3D di Blender via agent (perlu BlenderMCP) |
| ui-ux-pro-max | [nextlevelbuilder/ui-ux-pro-max-skill](https://github.com/nextlevelbuilder/ui-ux-pro-max-skill) | Design intelligence UI/UX lintas platform |
| task-observer | [rebelytics/one-skill-to-rule-them-all](https://github.com/rebelytics/one-skill-to-rule-them-all) | Meta-skill: buat & perbaiki skill otomatis |
| find-skills | [vercel-labs/skills](https://github.com/vercel-labs/skills) | Temukan & install skill dari registry |
| graphify | [Graphify-Labs/graphify](https://github.com/Graphify-Labs/graphify) | Knowledge graph codebase → hemat token |
| gstack (23 role) | [garrytan/gstack](https://github.com/garrytan/gstack) | Tim virtual: CEO/Eng/Design/QA/Security/Release |
| ECC plugin | [affaan-m/ECC](https://github.com/affaan-m/ECC) | 229 skills + 63 agents + hooks (via plugin) |
| claude-mem plugin | [thedotmack/claude-mem](https://github.com/thedotmack/claude-mem) | Memori persisten antar sesi |

Katalog lengkap + tabel routing (kapan pakai apa): **[SKILLS.md](SKILLS.md)**. Master prompt siap-paste untuk Claude Code: **[MASTER-PROMPT.md](MASTER-PROMPT.md)**. Panduan langkah-demi-langkah khusus **macOS**: **[SETUP-MAC.md](SETUP-MAC.md)**.

## Cara install — pilih salah satu

### A. Manual, satu baris (di terminal mesin kamu)

```bash
git clone https://github.com/astrorawak/claude-skills-hub.git ~/claude-skills-hub && bash ~/claude-skills-hub/install.sh
```

### B. Lewat Claude Code (paling gampang — di PC, laptop, atau Claude Code on web)

Paste ini ke Claude Code sesi baru:

```
https://github.com/astrorawak/claude-skills-hub
install skill — clone repo ini, jalankan install.sh, laporkan hasil --verify
```

Claude membaca `CLAUDE.md` di repo ini sebagai panduan, menjalankan installer, lalu memverifikasi.

### C. Update rutin

```bash
bash ~/.claude/skills-src/claude-skills-hub/install.sh        # tarik versi terbaru semua pack
bash ~/.claude/skills-src/claude-skills-hub/install.sh --verify  # lihat daftar skill terpasang
```

## Kenapa permanen & lintas sesi

- Skill dipasang ke **`~/.claude/skills/` (user scope)** — bukan per project. Semua project & sesi baru otomatis memuatnya; kamu tidak perlu menjelaskan ulang.
- Installer menambahkan blok pointer ke **`~/.claude/CLAUDE.md`** (global memory) agar Claude di sesi mana pun *tahu* katalog ini ada dan cara me-repair-nya.
- Repo ini juga tempat menyimpan daftar sumber resmi — tinggal clone di mesin baru.

**Lihat "HP":** aplikasi Claude di HP bukan Claude Code — skill tidak jalan di sana. Yang dipakai lintas perangkat adalah **Claude Code** (desktop/web). Di tiap mesin tempat Claude Code berjalan, jalankan installer sekali. Setelah itu tidak ada langkah tambahan.

## Prasyarat

- `git` (wajib)
- `claude` CLI (untuk plugin ECC & claude-mem — skrip mencetak perintah manual bila tidak ada)
- `bun` (untuk `./setup` gstack)
- `uv` + Blender + addon [BlenderMCP](https://github.com/ahujasid/blender-mcp) (hanya bila pakai skill 3D)

Catatan konteks: gstack + ECC + 94 blender skills = ratusan skill metadata (lazy, ringan), tapi **jangan aktifkan semua MCP sekaligus**. Rekomendasi: pilih gstack *atau* ECC sebagai workflow utama — detail di SKILLS.md.

## Uninstall

```bash
bash ~/.claude/skills-src/claude-skills-hub/uninstall.sh
```

## Lisensi

Skrip hub ini MIT; setiap skill tunduk pada lisensi repo asalnya (mayoritas MIT, unslop CC-BY-4.0).
