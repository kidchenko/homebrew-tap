# Homebrew cask. Lives in a tap (github.com/kidchenko/homebrew-tap) as
# Casks/cota.rb, then: brew install --cask kidchenko/tap/cota
#
# The tap's bump workflow rewrites `version` and `sha256` from the latest release.
cask "cota" do
  version "0.0.4"
  sha256 "65dad7f41cca69cb939b9d5e8c73df2b37cd19b680e1263109f7492b5d619be1"

  url "https://github.com/kidchenko/cota/releases/download/v#{version}/Cota-#{version}.dmg"
  name "Cota"
  desc "Claude usage limits in the menu bar"
  homepage "https://github.com/kidchenko/cota"

  livecheck do
    url :url
    strategy :github_latest
  end

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
