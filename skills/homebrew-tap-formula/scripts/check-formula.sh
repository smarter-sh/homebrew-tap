#!/usr/bin/env bash
# Check that Formula/smarter.rb points at a real smarter-cli release:
# the url's version and file name agree with bin.install, the url downloads,
# and the sha256 matches the downloaded file. Then run ruby -c and brew style.
# Changes no files and installs nothing.
#
# Usage: skills/homebrew-tap-formula/scripts/check-formula.sh [Formula/smarter.rb]
set -euo pipefail

formula="${1:-Formula/smarter.rb}"
[[ -f "${formula}" ]] || {
  echo "error: ${formula} not found (run from the repository root)" >&2
  exit 2
}

url=$(sed -nE 's/^[[:space:]]*url "([^"]+)".*/\1/p' "${formula}" | head -1)
sha=$(sed -nE 's/^[[:space:]]*sha256 "([0-9a-f]{64})".*/\1/p' "${formula}" | head -1)
bin=$(sed -nE 's/^[[:space:]]*bin\.install "([^"]+)" => "smarter".*/\1/p' "${formula}" | head -1)

fail() {
  echo "FAIL: $*" >&2
  exit 1
}

[[ -n "${url}" ]] || fail "no single-line url \"...\" found"
[[ -n "${sha}" ]] || fail "no single-line sha256 \"<64 hex>\" found"
[[ -n "${bin}" ]] || fail "no bin.install \"...\" => \"smarter\" line found"

case "${url}" in
  https://github.com/smarter-sh/smarter-cli/releases/download/v*/smarter-macos-latest-*) ;;
  *) fail "url is not a smarter-cli release asset: ${url}" ;;
esac

tag_version=$(printf %s "${url}" | sed -E 's|.*/download/v([^/]+)/.*|\1|')
file_name=${url##*/}
file_version=${file_name#smarter-macos-latest-}

echo "url:         ${url}"
echo "sha256:      ${sha}"
echo "bin.install: ${bin}"

[[ "${tag_version}" = "${file_version}" ]] || fail "tag v${tag_version} and file name ${file_name} disagree"
[[ "${bin}" = "${file_name}" ]] || fail "bin.install ${bin} doesn't match the downloaded file ${file_name}"
echo "ok: url tag, file name and bin.install agree on ${tag_version}"

tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
curl -fsSL -o "${tmp}/${file_name}" "${url}" || fail "could not download ${url}"
actual=$(shasum -a 256 "${tmp}/${file_name}" | cut -d ' ' -f 1)
[[ "${actual}" = "${sha}" ]] || fail "sha256 mismatch: formula has ${sha}, file is ${actual}"
echo "ok: sha256 matches the release asset"

ruby -c "${formula}" >/dev/null || fail "ruby -c"
echo "ok: ruby syntax"

if command -v brew >/dev/null 2>&1
then
  brew style "${formula}" >/dev/null || {
    brew style "${formula}" >&2 || true
    fail "brew style"
  }
  echo "ok: brew style"
else
  echo "skip: brew not installed, brew style not run"
fi

cli_version_file="../smarter-cli/VERSION"
if [[ -f "${cli_version_file}" ]]
then
  cli_version=$(tr -d '[:space:]' <"${cli_version_file}")
  if [[ "${cli_version}" = "${tag_version}" ]]
  then
    echo "ok: formula matches ../smarter-cli/VERSION (${cli_version})"
  else
    echo "note: formula is ${tag_version}, ../smarter-cli/VERSION is ${cli_version}"
  fi
fi
