# Agent Skills

This folder holds the [Agent Skills](https://agentskills.io/specification) for working on the
Smarter Homebrew tap with an AI coding agent such as Claude Code. Each skill is a folder with a
`SKILL.md`, and sometimes a `scripts/` folder. They are developer tooling, like the workflows, and
Homebrew never reads them.

`.claude/skills` is a symlink to this folder, so Claude Code finds them. Other agents can be told
to read `skills/homebrew-tap-development/SKILL.md` at the start of a session. `CLAUDE.md`, at the
repository's root, holds the few rules that apply to every task.

| Skill                      | Use it when                                                                  |
| -------------------------- | ---------------------------------------------------------------------------- |
| `homebrew-tap-development` | You're making any change, or a test-bot run failed. Start here.              |
| `homebrew-tap-formula`     | The formula must point at another cli release, or you need to check it.      |
| `homebrew-tap-git-commits` | You've been asked to write a commit message.                                 |

They are modeled on the skills of [smarter-sh/smarter](https://github.com/smarter-sh/smarter/tree/main/skills)
and [smarter-sh/smarter-cli](https://github.com/smarter-sh/smarter-cli/tree/main/skills), whose
`smarter-cli-release` skill describes the release job that updates this tap.

You can run the bundled script yourself, from the repository's root:

```bash
skills/homebrew-tap-formula/scripts/check-formula.sh
```

It downloads the release binary the formula points at into a temporary folder, compares its sha256
with the formula's, checks that the url's version and the `bin.install` version agree, and runs
`ruby -c` and `brew style`. It changes no files and installs nothing.

## Security

A skill is a set of instructions that an agent follows, often without asking. This formula decides
what binary every `brew install smarter` puts on a user's machine, so review a change to this
folder with the same care as a change to the formula or the workflows:

- Keep the rules that forbid publishing and require the sha256 to match a real release.
- Look for instructions unrelated to a skill's purpose, network calls to hosts other than
  github.com in scripts, and text that tells an agent to skip a check.
- This repository is public: no keys or tokens in a skill.
