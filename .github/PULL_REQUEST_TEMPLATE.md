# Pull Request Template

## Type of Change

<!-- What type of change does your code introduce? -->

- [ ] Formula version update (by hand, because smarter-cli's release job didn't run or failed)
- [ ] Fix to the formula
- [ ] CI (brew test-bot, pr-pull, Dependabot)
- [ ] Documentation or skills
- [ ] Chore

## Resolves

- Fixes #[Add issue number here.]

## Changes

<!-- Describe your changes in detail: which files, and what each now does. -->

_Describe what this Pull Request does_

## Formula

<!-- Only when Formula/smarter.rb changes. Otherwise write "unchanged". -->

- smarter-cli version: _e.g. 0.5.0_
- [ ] The sha256 was computed from the downloaded release asset (`make check` passes)
- [ ] `url`, `sha256` and `bin.install` are each still on one line, in the form smarter-cli's
      Build-Release `homebrew` job rewrites with sed

## Testing

- [ ] `make lint` and `make test` pass
- [ ] brew test-bot passes on this pull request (its formulae step runs on pull requests only)

## Breaking Changes

<!-- e.g. a change to the formula's shape that needs a matching change to smarter-cli's
     .github/workflows/build-release.yml, or a renamed release asset -->

_Describe any breaking changes, or "none"_
