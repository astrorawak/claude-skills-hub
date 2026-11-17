# CLAUDE.md — instruksi untuk Claude Code saat membuka repo ini

Kamu (Claude) sedang berada di repo **claude-skills-hub**: installer satu-kali-jalan untuk sekumpulan skill Claude Code hasil riset user.

## Bila user memintamu "install / pasang / repair / update skills"

1. Jalankan: `bash install.sh` (idempoten — clone ulang + refresh, aman dijalankan berkali-kali).
2. Setelah selesai jalankan: `bash install.sh --verify` dan tampilkan daftar skill ke user.
3. Untuk lewati pack berat: `SKIP="ECC (everything-claude-code),gstack" bash install.sh` (nama harus persis seperti di `install.sh` bagian PACKS/plugin).
4. Plugin ECC & claude-mem butuh Claude Code CLI; jika `claude` tidak ada di PATH, instruksikan user menjalankan dua perintah `/plugin ...` yang dicetak skrip.

## Setelah install berhasil, biasakan diri kamu

- Baca `SKILLS.md` (katalog + routing table) dan terapkan tabelnya saat memilh skill di sesi mana pun.
- Skill terpasang di `~/.claude/skills` (user scope) → otomatis dikenali Claude Code di semua project. Kamu tidak perlu menyalin apa pun ke project.
- Skrip ini juga menambahkan blok pointer `claude-skills-hub-begin/end` ke `~/.claude/CLAUDE.md`. Jangan duplikat blok itu; bila user minta uninstall, jalankan `bash uninstall.sh`.

## Larangan (guardrails)

- Jangan install sumber selain repo resmi yang terdaftar di `install.sh` (proyek ECC & unslop memperingatkan mirror pihak ketiga).
- Jangan menggabungkan install plugin + manual untuk pack yang sama (duplikasi hooks/skills).
- blender-skills tidak berguna tanpa BlenderMCP aktif — verifikasi koneksi dulu sebelum memakai, dan jangan klaim sudah memodelkan 3D bila MCP tidak tersambung.
- replica-skill: patuhi batasan clean-room (tidak menyalin kode/logo/copy/content pemilik aslinya) sebelum membantu user cloning.

## Referensi cepat

- Katalog: `SKILLS.md`
- Uninstall bersih: `uninstall.sh`
- Update rutin: jalankan ulang `install.sh` (pull semua repo)
