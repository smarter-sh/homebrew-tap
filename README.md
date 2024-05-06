# QueriumCorp Tap

## How do I install these formulae?

`brew install queriumcorp/tap/<formula>`

Or `brew tap queriumcorp/tap` and then `brew install <formula>`.

## Documentation

`brew help`, `man brew` or check [Homebrew's documentation](https://docs.brew.sh).

## Smarter CLI Installation Instructions

```console
brew tap QueriumCorp/homebrew-tap
brew install smarter
```

## Publication

1. `brew tap --force homebrew/core`
2. `brew create https://github.com/QueriumCorp/smarter-cli/releases/download/<tag>/smarter-macos-latest-<version>`
3. update smarter.rb in this repo
4. test your results: `brew install /opt/homebrew/Library/Taps/homebrew/homebrew-core/Formula/s/smarter.rb`
5. `brew developer off`
