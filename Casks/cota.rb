# Homebrew cask. Lives in a tap (github.com/kidchenko/homebrew-tap) as
# Casks/cota.rb, then: brew install --cask kidchenko/tap/cota
#
# The tap's bump workflow rewrites `version` and `sha256` from the latest release.
cask "cota" do
  version "0.0.3"
  sha256 "0f7b85eee602eeec3fd8fafa3f042347c3c27a81d312ae6ffe90a204789ef5d0"

  url "https://github.com/kidchenko/cota/releases/download/v#{version}/Cota-#{version}.dmg"
  name "Cota"
  desc "Claude usage limits in the menu bar"
  homepage "https://github.com/kidchenko/cota"

  livecheck do
    url :url
    strategy :github_latest
  end

  # The release workflow builds on an Apple silicon runner, without --universal.
  depends_on arch: :arm64
  depends_on :macos

  app "Cota.app"

  # Ad-hoc signed, not notarized: without this, Gatekeeper refuses to open it.
  postflight_steps do
    run "/usr/bin/xattr",
        args:           ["-dr", "com.apple.quarantine", "{{appdir}}/Cota.app"],
        writable_paths: ["{{appdir}}/Cota.app"]
  end

  uninstall launchctl: "com.kidchenko.cota",
            quit:      "com.kidchenko.cota"

  zap trash: [
    "~/Library/Application Support/Cota",
    "~/Library/LaunchAgents/com.kidchenko.cota.plist",
  ]
end
