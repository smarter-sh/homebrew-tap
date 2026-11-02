---
name: homebrew-tap-git-commits
description: Use whenever the user asks you to "write a git commit" (or a commit message, or the git add) in the Smarter Homebrew tap repository (smarter-sh/homebrew-tap). Covers the never-execute rule, authorship, the multiple -m command format, the conventional-commit types used here, the 72-character header, and the body.
---

# Homebrew Tap Git Commits

## The rule: write, never execute

"Write a git commit", in any wording or tone, means **output the command as text**. It never means
run it. Never execute `git commit`, `git add`, `git reset`, `git restore --staged`, `git push`,
`git tag`, `git stash` or any other git command that writes. Read-only commands (`git status`,
`git diff`, `git log`) are fine for working out what changed. Don't volunteer commit messages.

## Authorship

You are the author. Lawrence McDaniel is the co-author, as in the smarter repository:

- `--author="Claude <noreply@anthropic.com>"`
- The last `-m` is `Co-authored-by: Lawrence McDaniel <lpm0073@gmail.com>`.

## Command format

Exactly one `git commit` command in one code block, one `-m` per paragraph:

```console
git commit --author="Claude <noreply@anthropic.com>" \
  -m "ci: allow the nightly repository tests to start test-bot" \
  -m "The organization's nightly Repository Tests workflow (smarter-sh/automation, scripts/repository_tests.py) starts every repository's tests.yml with a workflow_dispatch event. tests.yml had no such trigger, so the tap was reported as not started every night." \
  -m "Added workflow_dispatch to the triggers of .github/workflows/tests.yml. A dispatched run takes the same path as a push to main: setup and tap-syntax (brew style) on ubuntu-24.04 and macos-15; the formulae step still runs on pull requests only." \
  -m "Co-authored-by: Lawrence McDaniel <lpm0073@gmail.com>"
```

- When the user asks for the `git add` too, write it as a separate block with explicit paths.
  Leave out files that don't belong to the change (e.g. `.DS_Store`).
- Avoid backticks, `$` and `!` inside the double quotes. The user's shell is zsh, where `!` in
  double quotes is history expansion and aborts the command. Reword instead.
- Never write a CI skip instruction anywhere in the message (`[skip ci]` and its variants, even to
  describe one): GitHub would start no workflow for the push.

## Types

There is no semantic-release here, so the type only describes the change. commitlint
(`commitlint.config.js`, the same as the other smarter-sh repositories) checks the header at the
commit-msg hook, once `make init` has installed it:

- `fix`: the formula installs the wrong thing, or fails (a bad sha256, a broken test block).
- `chore`: pointing the formula at a newer release by hand, or housekeeping. Scope `formula` when
  it helps: `chore(formula): update smarter to 0.5.0`.
- `ci`: the workflows. `docs`: the README, `CLAUDE.md` or `skills/`.
- `feat`: rare; a new formula, or a new platform (Intel, Linux) for the existing one.
- Never `[CI/CD] release <version>`: that message belongs to smarter-cli's release job.

Header: 72 characters or fewer, imperative, lower case, no trailing period. Measure it:
`printf %s "<header>" | wc -c`.

## Body

The problem first (what was wrong or missing, and how it showed), then what changed and why, file
by file, then how it was verified (`brew style`, `check-formula.sh`). For a formula update, name
the version and say the sha256 was computed from the downloaded release asset.

Start your reply with a one-line `Written for:` audience note.
