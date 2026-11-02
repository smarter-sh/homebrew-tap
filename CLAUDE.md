# CLAUDE.md

Guidance for Claude Code (and other coding agents) working in this repository.

This is the Homebrew tap of the Smarter project, `smarter-sh/tap`. It holds one formula,
`Formula/smarter.rb`, which installs the `smarter` command-line interface on macOS
(`brew tap smarter-sh/tap && brew install smarter`). The formula doesn't build anything: it
downloads the prebuilt macOS binary from a GitHub release of
[smarter-sh/smarter-cli](https://github.com/smarter-sh/smarter-cli) (usually checked out beside
this repository as `../smarter-cli`) and pins its sha256.

**The formula is maintained by a robot.** The `homebrew` job of smarter-cli's Build-Release
workflow (`../smarter-cli/.github/workflows/build-release.yml`) clones this repository, rewrites
the formula's `url`, `sha256` and `bin.install` lines with `sed`, and pushes a
`[CI/CD] release <version>` commit straight to `main`.

Detailed know-how lives in the Agent Skills under `skills/` (symlinked to `.claude/skills`).
**Load `homebrew-tap-development` first for any change.**

## Hard rules

1. **Never run git write commands.** "Write a git commit" means print the command as text. See
   `homebrew-tap-git-commits`.
2. **Never publish.** No `gh workflow run`, `gh release`, `brew bump-formula-pr`, `brew pr-pull`, or
   adding the `pr-pull` label. Releases start in smarter-cli, by hand, and are the user's call.
3. **Keep the formula's three lines sed-friendly.** `url "..."`, `sha256 "..."` and
   `bin.install "smarter-macos-latest-<version>" => "smarter"` must each stay on one line, in that
   form, or the cli's release job stops updating them without failing. A change to the formula's
   shape is made together with the `homebrew` job in `../smarter-cli`.
4. **A hand-edited version must match a real release.** The url must download, and the sha256 must
   be that file's. Check both with `skills/homebrew-tap-formula/scripts/check-formula.sh`.
5. **Don't install or uninstall anything with brew** (`brew install`, `brew reinstall`,
   `brew uninstall`, `brew untap`) on the user's machine unless they ask. Verify with `brew style`,
   `brew audit` and the check script.
6. **`tests.yml` needs its `workflow_dispatch` trigger.** The organization's nightly Repository
   Tests (`../automation/scripts/repository_tests.py`) start it that way.
7. **This repository is public.** No tokens or private hostnames.

## Repository map

| Path                             | Contents                                                                   |
| -------------------------------- | -------------------------------------------------------------------------- |
| `Formula/smarter.rb`             | The `smarter` formula: url and sha256 of the macOS binary, install, test   |
| `.github/workflows/tests.yml`    | `brew test-bot` on pushes, pull requests and nightly dispatch              |
| `.github/workflows/publish.yml`  | `brew pr-pull` when a pull request is labeled `pr-pull` (bottles; unused)  |
| `.github/dependabot.yml`         | Monthly updates of actions, pre-commit hooks and `requirements/`, to main  |
| `README.md`                      | Install instructions, and the manual publication steps                     |
| `Makefile`                       | `init`, `lint`, `check`, `test`, `pre-commit-run`                          |
| `.pre-commit-config.yaml`        | The lint standard: codespell, shellcheck, brew style, commitlint, ...      |
| `skills/`                        | Agent Skills for this repository                                           |

Homebrew loads only `Formula/`. Everything else is developer tooling, and must never add a `.rb`
file outside `Formula/` or a `Casks/` folder, which Homebrew would try to load.

## Common commands

```bash
make init                     # pre-commit and its hooks, in venv/
make lint                     # ruby -c and brew style on the formula, *.sh and ruby blocks in *.md, as CI does
make check                    # the url downloads, the sha256 matches, the versions agree
make test                     # lint and check
make pre-commit-run           # every hook on every file
cat ../smarter-cli/VERSION    # the cli's latest version, to compare
```

`.env` holds `GH_TOKEN` for `gh` (e.g. to read a failed run's log). Never print it or commit it.

## Definition of done

- `make test` passes, and the pre-commit hooks pass on the changed files.
- The formula's three release lines are still in the form the cli's release job rewrites.
- Your summary says what changed, what you verified, and what you skipped.
