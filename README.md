# smarter-sh Tap

## How do I install these formulae?

`brew install smarter-sh/tap/<formula>`

Or `brew tap smarter-sh/tap` and then `brew install <formula>`.

## Documentation

`brew help`, `man brew` or check [Homebrew's documentation](https://docs.brew.sh).

## Smarter CLI Installation Instructions

```console
brew tap smarter-sh/homebrew-tap
brew install smarter
```

## First Time Publication

1. `brew tap --force homebrew/core`
2. `brew create https://github.com/smarter-sh/smarter-cli/releases/download/<tag>/smarter-macos-latest-<version>`
3. update smarter.rb in this repo
4. test your results: `brew install /opt/homebrew/Library/Taps/homebrew/homebrew-core/Formula/s/smarter.rb`
5. `brew developer off`


## Republication

1. Edit smarter.rb in this repo. set url to the tag address for the latest macOS release.
2. Generate a new sha256 value. In a Homebrew formula, the sha256 field is used to provide a SHA-256 hash of the file that's being downloaded. SHA-256 is a cryptographic hash function that produces a 256-bit (32-byte) hash value. It's commonly used to verify the integrity of data.

When you install a package using Homebrew, it downloads the file specified in the url field. After the file is downloaded, Homebrew calculates the SHA-256 hash of the downloaded file and compares it to the value in the sha256 field of the formula.

    ```console
    wget https://github.com/smarter-sh/smarter-cli/releases/download/<tag>/smarter-macos-latest-<version> .
    shasum -a 256 smarter-macos-latest-<version>
    ```
