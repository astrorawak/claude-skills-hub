# MASTER PROMPT — jalankan di Claude Code dalam repo claude-skills-hub

Copy seluruh blok di bawah `===PROMPT START===` sampai `===PROMPT END===`, paste sebagai pesan pertama Claude Code setelah kamu membuka repo ini (`cd claude-skills-hub && claude`). Prompt ini bekerja penuh end-to-end dengan checkpoint.

===PROMPT START===

You are operating in the **claude-skills-hub** repository — a one-run installer that permanently installs a curated set of Claude Code skills (user scope, `~/.claude/skills`) for my machine. Complete ALL phases below in order. Report a checkpoint line after each phase. Stop and ask me ONLY where explicitly marked [ASK]. Use Indonesian for your replies to me.

## Phase 0 — Environment sanity
1. Read `CLAUDE.md`, `SKILLS.md`, and `README.md` in this repo. Follow their guardrails strictly.
2. Check and report versions/availability of: `git`, `claude` (CLI, `claude --version`), `bun`, `uv` or `pip3`, `node/npm`.
3. If `bun` is missing (needed only for gstack setup) or python tooling is missing (needed only for graphify CLI): [ASK] whether to install them now (suggest `curl -fsSL https://bun.sh/install | bash`), or continue skipping those parts.
4. Detect duplicates BEFORE installing: run `bash install.sh --verify` if `~/.claude/skills` already exists, and check whether ECC/claude-mem plugins are already registered (`claude plugin list` if available). Never stack a plugin install on top of a manual copy of the same pack, or vice versa.

## Phase 1 — Core installer
5. Run `bash install.sh` from the repo root. It is idempotent; each pack installs from its official GitHub source only (listed in install.sh PACKS — do NOT substitute mirrors or re-uploads).
6. Watch the per-pack output. Any pack that prints a warning is NOT a failure — collect warnings into the final report.
7. If the script needs `sudo`, network retries, or hits a rate limit: retry once, then continue with remaining packs and log the failure.

## Phase 2 — Plugins (ECC & claude-mem)
8. If `claude` CLI is present and functional headless: install the two plugins per the script output:
   - `claude plugin marketplace add https://github.com/affaan-m/ECC` then `claude plugin install ecc@ecc`
   - `claude plugin marketplace add thedotmack/claude-mem` then `claude plugin install claude-mem@claude-mem`
9. If headless plugin install is not possible, output the exact two `/plugin ...` commands for me to run inside a Claude Code session, and note them as PENDING in the report.
10. [ASK] before enabling claude-mem: it spawns a shadow agent that consumes extra tokens. Offer to keep it installed but disabled, or skip it, per my workflow preference (my machine already uses graphify for context efficiency).

## Phase 3 — Verification
11. Run `bash install.sh --verify`. Expected baseline (± small drift after upstream updates): ~118 skills including unslop, stop-slop, prompt-master, 11×replica-*, 94×blender skills, ui-ux-pro-max (7), task-observer, find-skills, graphify, gstack tooling.
12. Verify the pointer block exists in `~/.claude/CLAUDE.md` exactly once (marker `claude-skills-hub-begin`...`end`). If duplicated by graphify's own installer registering a line, that is fine — do not remove either, just confirm the hub block exists once.
13. Spot-check 3 installed SKILL.md files render valid frontmatter: `unslop`, `replica-recon`, `blender-director`.

## Phase 4 — Repair loop
14. For every pack reported missing/wrong in Phase 3: re-run its install step alone (`SKIP` everything else), up to 2 attempts. If still failing, write the pack, repo, and error into a file `install-report.md` in this repo root as KNOWN-ISSUES, continue, do not block the rest.

## Phase 5 — Final report (to me, in Indonesian, as a table)
- Status per pack: OK / PENDING / FAILED + count skill
- Prasyarat yang belum terpenuhi di mesin ini + perintah memperbaiki
- 3 contoh kalimat pemicu skill yang langsung bisa saya pakai (mis. `/unslop dashboard ini`, `graphify: /graphify .`, `/replica-recon <app>`)
- Cara update rutin: `bash ~/.claude/skills-src/claude-skills-hub/install.sh` (jalankan ulang repo ini di mesin lain = install sekali)
- Reminder context-budget: jangan aktifkan semua MCP sekaligus; gstack vs ECC — tanyakan mana yang mau dijadikan workflow utama, sisanya biarkan tersedia on-demand.

Hard rules (from CLAUDE.md): install only from the official repos listed in install.sh; never install ECC/gstack twice into the same harness; do not simulate Blender 3D work without a live BlenderMCP connection; do not touch my existing project configs beyond the global pointer block described above.

===PROMPT END===

## Versi paling singkat (kalau malas paste panjang)

```
https://github.com/astrorawak/claude-skills-hub
baca CLAUDE.md repo ini, lalu jalankan install.sh end-to-end sampai
verifikasi --verify bersih, laporkan tabel status per pack, dan
jelaskan cara update rutin. Ikuti semua guardrail & checkpoint-nya.
```

## Catatan pemakaian lintas perangkat

| Kondisi | Langkah |
|---|---|
| Claude Code desktop di PC (folder repo ini sudah ada) | buka Claude Code di folder itu, paste MASTER PROMPT |
| Mesin baru | `git clone https://github.com/astrorawak/claude-skills-hub.git && cd claude-skills-hub` → paste prompt |
| Claude Code on web (HP/browser) | sambungkan repo `astrorawak/claude-skills-hub` sebagai environment, lalu paste versi singkat |
