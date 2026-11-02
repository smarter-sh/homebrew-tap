---
name: homebrew-tap-formula
description: Use when Formula/smarter.rb in the Smarter Homebrew tap must point at another smarter-cli release (e.g. the cli's Build-Release homebrew job failed or was skipped, and the tap is behind), when its url, sha256 or bin.install line looks wrong, or when asked to check the formula. Covers finding the latest release, computing the sha256, editing the three release lines without breaking the cli job's sed, and the check-formula.sh script.
---

# The smarter Formula

`Formula/smarter.rb` pins one release of the cli in three lines:

```text
  url "https://github.com/smarter-sh/smarter-cli/releases/download/v<version>/smarter-macos-latest-<version>"
  sha256 "<sha256 of that file>"
  ...
    bin.install "smarter-macos-latest-<version>" => "smarter"
```

(A `ruby` code block in any Markdown file of this repository must be valid Ruby: `brew style`,
which CI runs on the whole tap, lints them too. Use `text` for templates like this one.)

All three name the same version. smarter-cli's Build-Release `homebrew` job normally rewrites them
(see `homebrew-tap-development`). Edit them by hand only when that job didn't run or failed, and
the user asks.

## Is the tap behind?

```bash
grep -E '^\s*url ' Formula/smarter.rb
cat ../smarter-cli/VERSION                       # the version semantic-release last tagged
git -C ../smarter-cli tag --sort=-v:refname | head -3
```

A tag isn't enough: the binary exists only after a maintainer ran Build-Release for it. Check that
the asset downloads before pointing the formula at it:

```bash
curl -sIL -o /dev/null -w '%{http_code}\n' \
  https://github.com/smarter-sh/smarter-cli/releases/download/v<version>/smarter-macos-latest-<version>
```

`200` means it exists. `404` means Build-Release hasn't run for that version: tell the user, and
don't edit the formula. Running it is their call.

## Updating to a release by hand

1. Download the binary into your scratchpad and compute its sha256:

   ```bash
   curl -sSL -o "$SCRATCHPAD/smarter-macos-latest-<version>" <url>
   shasum -a 256 "$SCRATCHPAD/smarter-macos-latest-<version>"
   ```

2. Edit the three lines with the Edit tool. Keep each on one line, in double quotes, exactly in the
   form above, so the cli job's `sed` still matches them next time.
3. Run `skills/homebrew-tap-formula/scripts/check-formula.sh`. It must pass.
4. Remove the downloaded binary from your scratchpad.

Never invent or copy a sha256 from anywhere but the downloaded file. A wrong sha256 makes every
`brew install smarter` fail; a right sha256 for the wrong file installs the wrong program.

## Other changes to the formula

- `desc`, `homepage`, `license` and the `test do` block can change freely, within `brew style`.
- Adding an Intel or Linux binary (`on_arm`/`on_intel`, `on_macos`/`on_linux` blocks) means more
  than one `url` and `sha256` line, which the cli job's `sed` would rewrite all to the same value.
  It needs a matching change to `../smarter-cli/.github/workflows/build-release.yml`. Propose it;
  don't make it alone.
- Renaming the binary must happen in the cli's `mac_linux` job, its `homebrew` job, and here,
  together.

## The check script

```bash
skills/homebrew-tap-formula/scripts/check-formula.sh [Formula/smarter.rb]
```

It reads the formula, checks that the url's version, the file name in the url and the
`bin.install` file name all agree, downloads the url into a temporary folder, compares the
sha256, and runs `ruby -c` and `brew style`. It exits non-zero on the first failure, changes no
files, and installs nothing. It also prints the cli's `../smarter-cli/VERSION`, when that checkout
exists, so you can see whether the tap is behind.
