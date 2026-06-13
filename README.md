# eddieparc/homebrew-tap

Personal Homebrew tap for project forks and one-off formulae.

## Available formulae

| Formula | Description |
|---------|-------------|
| `aoe-ko` | Korean-localized fork of [Agent of Empires](https://github.com/agent-of-empires/agent-of-empires). Built from [eddieparc/agent-of-empires `feat/i18n-korean`](https://github.com/eddieparc/agent-of-empires/tree/feat/i18n-korean). |

## Usage

```bash
# One-time tap registration
brew tap eddieparc/tap

# Install Korean-localized Agent of Empires
brew install eddieparc/tap/aoe-ko
```

`aoe-ko` is installed as a separate binary from upstream `aoe` (no conflict). Both share `~/.agent-of-empires/` state, so sessions, tokens, and config are interchangeable.
