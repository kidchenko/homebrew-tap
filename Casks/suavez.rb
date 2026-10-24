# Homebrew cask. Lives in a tap (github.com/kidchenko/homebrew-tap) as
# Casks/suavez.rb, then: brew install --cask kidchenko/tap/suavez
#
# The tap's bump workflow rewrites `version` and `sha256` from the latest release.
cask "suavez" do
  version "0.0.3"
  sha256 "5a62fa8626af5476f30ce4eb20c31910eebddda3decb4a50baa627ab4b6a6e77"

  url "https://github.com/kidchenko/suavez/releases/download/v#{version}/SuaVez-#{version}.dmg"
  name "Sua Vez"
  desc "Menu bar light for when your coding agent finishes or needs you"
  homepage "https://github.com/kidchenko/suavez"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on :macos

  app "SuaVez.app"

  # Ad-hoc signed, not notarized: without this, Gatekeeper refuses to open it.
  postflight_steps do
    run "/usr/bin/xattr",
        args:           ["-dr", "com.apple.quarantine", "{{appdir}}/SuaVez.app"],
        writable_paths: ["{{appdir}}/SuaVez.app"]
  end

  uninstall launchctl: "com.kidchenko.suavez",
            quit:      "com.kidchenko.suavez"

  zap trash: [
    "~/Library/Application Support/SuaVez",
    "~/Library/LaunchAgents/com.kidchenko.suavez.plist",
  ]
end
