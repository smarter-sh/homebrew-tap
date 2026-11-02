---
name: homebrew-tap-development
description: Start here for any change to the Smarter Homebrew tap (smarter-sh/homebrew-tap) - Formula/smarter.rb, the brew test-bot and brew pr-pull workflows, or the README - and when a test-bot run fails. Gives the rules, the repository map, how the smarter-cli release job updates the formula, what each workflow job does, how to verify locally, and which narrower skill to load.
---

# Smarter Homebrew Tap Development

This repository is the tap `smarter-sh/tap`. Users install the Smarter cli with:

```bash
brew tap smarter-sh/tap
brew install smarter
```

It holds one formula, `Formula/smarter.rb`. The formula builds nothing: it downloads one prebuilt
macOS binary, `smarter-macos-latest-<version>`, from a GitHub release of
[smarter-sh/smarter-cli](https://github.com/smarter-sh/smarter-cli), checks its sha256, and installs
it as `bin/smarter`. Its `test do` block runs `smarter version`.

## How the formula is updated

The formula is kept current by smarter-cli, not here (see `../smarter-cli/skills/smarter-cli-release/SKILL.md`):

1. semantic-release tags `v<version>` in smarter-cli.
2. A maintainer runs smarter-cli's **Build-Release** workflow by hand. Its `mac_linux` job uploads
   `smarter-macos-latest-<version>` to the GitHub release.
3. Its `homebrew` job then clones this repository with the `PAT` secret, downloads the binary to
   compute its sha256, and rewrites three lines of `Formula/smarter.rb` with GNU `sed`:
   - `url "..."`
   - `sha256 "..."`
   - `bin.install "smarter-macos-latest-.*" => "smarter"`
4. It commits as `GitHub Actions <actions@github.com>` with the message
   `[CI/CD] release <version>`, and pushes straight to `main`. That push runs `tests.yml` here.

Consequences:

- **Those three lines are an interface.** Keep each on one line, with double quotes, in exactly
  that form. If a regular expression stops matching, `sed` changes nothing, the job still commits
  and pushes, and the tap silently stays on the old version (or ends up with a url and a sha256
  from different releases). A change to the formula's shape goes together with a change to the
  `homebrew` job in `../smarter-cli/.github/workflows/build-release.yml`; say so before making one.
- Don't copy the `[CI/CD] release` message style. It belongs to the robot.
- The README's "First Time Publication" and "Republication" sections describe the manual process
  from before the job existed.

## Repository map

| Path                            | What lives there                                                               |
| ------------------------------- | ------------------------------------------------------------------------------ |
| `Formula/smarter.rb`            | The formula: desc, homepage, url, sha256, license (AGPL-3.0), install, test    |
| `.github/workflows/tests.yml`   | `brew test-bot` on ubuntu-24.04 and macos-15                                   |
| `.github/workflows/publish.yml` | `brew pr-pull` when a pull request gets the `pr-pull` label                    |
| `.github/dependabot.yml`        | Monthly updates of the actions, pre-commit hooks and `requirements/`, to main  |
| `README.md`                     | Install instructions and the manual publication steps                          |
| `Makefile`, `.pre-commit-config.yaml` | `make init`, `lint`, `check`, `test`; the lint standard                  |

## The workflows

**`tests.yml` (brew test-bot)** runs on pushes to `main`, on pull requests, and on
`workflow_dispatch`. The nightly Repository Tests workflow of `smarter-sh/automation`
(`../automation/scripts/repository_tests.py`) starts every repository's `tests.yml` through
`workflow_dispatch`, so that trigger must stay. Its steps, on both runners:

| Step                                  | Runs on             | What it checks                                                    |
| ------------------------------------- | ------------------- | ----------------------------------------------------------------- |
| `--only-cleanup-before`, `--only-setup` | every event       | The runner's Homebrew is healthy                                  |
| `--only-tap-syntax`                   | every event         | Ruby syntax and `brew style` (RuboCop) of every file in the tap   |
| `--only-formulae`                     | pull requests only  | Downloads, installs, audits and tests changed formulae, builds bottles |

So a push to `main` or a nightly run checks style only. A pull request also installs the binary,
which is the only place the sha256 and `smarter version` are tested in CI.

`Homebrew/actions/setup-homebrew` is pinned to a commit sha. When updating it, pin the new sha too.

**`publish.yml` (brew pr-pull)** is Homebrew's standard bottle-publishing workflow from
`brew tap-new`. It isn't part of the release path: the cli's job pushes to `main` directly. Never
add the `pr-pull` label yourself.

## When test-bot fails

Read the failed step's log (the user may paste it, or give a run url). Usual causes:

- **tap-syntax:** a RuboCop offense. Reproduce with `brew style Formula/smarter.rb`, fix it, and
  keep the three release lines in their form.
- **A Homebrew or runner change:** test-bot's rules move with Homebrew. A failure in
  `--only-setup` or `--only-cleanup-before` on a commit that didn't touch the formula is usually
  the runner's image or a new Homebrew; check whether the same step fails on the previous commit.
- **formulae (pull requests):** a sha256 mismatch means the url and sha256 come from different
  files; see `homebrew-tap-formula`. The formula installs a macOS binary only, so it can't work on
  the ubuntu-24.04 leg; say so rather than guessing at a fix.

Without `gh` credentials you can't download logs; ask the user to paste the failing step.

## Verify locally

```bash
make lint     # ruby -c, and brew style on every tracked folder (not ".", which lints venv/ too)
make check    # skills/homebrew-tap-formula/scripts/check-formula.sh
make test     # both
```

`brew style .` lints more than the formula, and CI's tap-syntax step fails on any of it:

- **Shell scripts** (`*.sh`, anywhere, `skills/` included) get Homebrew's strict shellcheck
  (`[[ ]]`, `"${var}"`) and shfmt. `brew style --fix <file>` reformats one script.
- **`ruby` code blocks in Markdown files** must be valid Ruby. Use a `text` block for templates
  with placeholders.
- A `.rb` file outside `Formula/` (or a `Casks/` folder) could be read as a formula. Don't add one.

`brew audit --formula smarter-sh/tap/smarter` audits the copy that `brew tap` cloned under
`$(brew --repository)/Library/Taps/smarter-sh/homebrew-tap`, not this checkout, so it says nothing
about uncommitted edits. Don't `brew install`, `reinstall`, `uninstall` or `untap` unless the user
asks: it changes their machine.

## Which skill to load

| Task                                                                 | Skill                      |
| -------------------------------------------------------------------- | -------------------------- |
| Pointing the formula at another release, or checking url and sha256  | `homebrew-tap-formula`     |
| Writing a commit message                                             | `homebrew-tap-git-commits` |

Changes to the cli itself, its release workflow or its binaries belong in `../smarter-cli`, whose
`smarter-cli-development` and `smarter-cli-release` skills cover them.

## Definition of done

- `ruby -c`, `brew style` and `check-formula.sh` pass.
- The three release lines are still in the form the cli's job rewrites.
- `tests.yml` still has its `workflow_dispatch` trigger.
- Your summary says what changed, what you verified, and what you skipped.
