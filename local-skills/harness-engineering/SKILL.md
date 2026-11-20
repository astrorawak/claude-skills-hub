---
name: harness-engineering
description: Build and run a reliable agent harness for any repository, based on the Learn Harness Engineering course (walkinglabs/learn-harness-engineering). Bootstraps harness files (AGENTS.md/CLAUDE.md, init.sh, feature_list.json, claude-progress.md), enforces one-feature-at-a-time scope, requires verification evidence before claiming done, and keeps clean multi-session continuity with handoff notes. Use when starting work in a new or bare repo, when a project lacks structure, when work spans multiple sessions, when previous sessions lost context or re-did work, or when the user says harness, bootstrap harness, /harness-engineering.
---

# Harness Engineering

The model decides what code to write. The harness governs when, where, and how it writes it. Your job in this skill: make agent output reliable — not by better prompting, but by building the system the model operates inside.

## Five subsystems → concrete files

| Subsystem | Job | Lives in |
|---|---|---|
| Instructions | What to do, in what order, what to read first | `AGENTS.md` (+ `CLAUDE.md` symlink/pointer if Claude Code) |
| State | What's done, in progress, next — persisted so the next session resumes exactly | `feature_list.json`, `claude-progress.md`, git log |
| Verification | No victory without runnable proof | tests + lint + type-check + smoke (`init.sh` runs these) |
| Scope | One feature at a time, no overreach, never rewrite the list to hide unfinished work | active flag in `feature_list.json` |
| Session lifecycle | Init at start, clean state at end, handoff for the next session | `init.sh` + finish checklist below |

## Modes (invoke `/harness-engineering <mode>` or detect intent)

### Mode: bootstrap (idempotent — only create what's missing)
1. Inspect the repo: stack, scripts, test command, existing docs. Never assume.
2. Create/refresh at project root:

- `AGENTS.md` — operating manual: project one-liner, commands (setup/test/lint/run), rules: *one active feature, verify before done, update progress log before commit, commit only at safe resume points*. Progressive disclosure: point to `docs/` instead of inlining everything.
- `feature_list.json` — schema below.
- `claude-progress.md` — newest session on top.
- `init.sh` — `set -e`; install deps, type-check, lint, test, boot smoke check; print PASS summary. Must exit non-zero on any failure.

3. Run `init.sh` once; fix what breaks; commit the harness as its own first commit ("chore: bootstrap agent harness").

`feature_list.json`:
```json
{
  "features": [
    {
      "id": "F01",
      "title": "…",
      "status": "todo | active | done",
      "done_criteria": ["observable, testable statements"],
      "evidence": "command + result once done"
    }
  ]
}
```
At most ONE feature with `status: "active"`.

`claude-progress.md` entry format:
```
## Session 2026-11-20 — F03
- Done: …
- In progress: … (exact file/function state)
- Next: …
- Open questions / risks: …
- Verification: `npm test` → 42 passed
```

### Mode: start (beginning of ANY working session in a harness repo)
1. Read `claude-progress.md` (top entry), `feature_list.json`, then `git log --oneline -10`.
2. Run `init.sh` (or the project's verify command) to confirm clean state before touching anything.
3. Announce: the one active feature you will work on and its done_criteria. Do not start other features.

### Mode: finish (end of ANY working session)
1. Verify: run tests/lint/type-check; paste real output into the progress entry as evidence. A feature flips to `done` only when every done_criterion has evidence.
2. Update `feature_list.json` statuses and `claude-progress.md` with the entry (Done / In progress / Next / Open questions / Verification).
3. Clean-state checklist: `git status` shows no unintended changes; no temp/debug files; build passes from scratch (`init.sh`).
4. Commit only at safe resume points, message referencing the feature id. Write the handoff note for the next session.

### Mode: audit (when work is going wrong)
Diagnose which subsystem is missing/weak — lost context (State), random scope (Scope), false "done" (Verification), no clean restart (Lifecycle) — then patch just that file, and re-run. If the agent ignores instructions, the harness is at fault first, not the model.

## Hard rules (always)
- One feature at a time. No half-finishing three things.
- Never claim completion without runnable proof in this session.
- Never delete or rewrite `feature_list.json` history to hide unfinished work; add a new entry instead.
- Progress log is append-style per session; newest on top; keep it short (bullets, not prose).
- Keep `AGENTS.md` as a map, not an encyclopedia — link to docs for depth (progressive disclosure).
- If the repo is someone else's and lacks structure, propose bootstrap and ask before creating harness files.

## Deep material (read on demand, not by default)
- Course docs: https://walkinglabs.github.io/learn-harness-engineering/
- Repo + resource templates: https://github.com/walkinglabs/learn-harness-engineering
- Advanced (loop & graph orchestration after the base harness works): projects P07 (automated loops, maker-checker) and P08 (workflow as graph: nodes/edges/fan-out/rollback/human-in-the-loop) in the repo's docs/en/projects/.
