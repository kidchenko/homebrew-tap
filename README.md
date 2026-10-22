# kidchenko/tap

Homebrew casks for [kidchenko](https://github.com/kidchenko)'s apps.

```bash
brew tap kidchenko/tap
brew install --cask cafe cota suavez
```

Or one at a time, without tapping first:

```bash
brew install --cask kidchenko/tap/cota
```

| Cask | |
|---|---|
| [`cafe`](Casks/cafe.rb) | [Cafe](https://github.com/kidchenko/cafe) keeps your Mac awake from the menu bar. |
| [`cota`](Casks/cota.rb) | [Cota](https://github.com/kidchenko/cota) shows your Claude usage limits in the menu bar. Apple silicon only. |
| [`suavez`](Casks/suavez.rb) | [Sua Vez](https://github.com/kidchenko/suavez) lights up the menu bar when your coding agent finishes or needs you. |

The apps are ad-hoc signed, not notarized; each cask clears the quarantine flag
after install so Gatekeeper lets them open.

## Updates

[`bump`](.github/workflows/bump.yml) runs daily and moves each cask to its
app's latest GitHub release, hashing the new DMG. An app's release workflow can
trigger it straight away:

```bash
gh workflow run bump.yml --repo kidchenko/homebrew-tap -f cask=cota
```

To bump locally: `.github/scripts/bump.sh [cask...]`.

[`ci`](.github/workflows/ci.yml) runs `brew style`, `brew audit` and an
install/uninstall of every cask on each push and pull request.
