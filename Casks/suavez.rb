# Homebrew cask. Lives in a tap (github.com/kidchenko/homebrew-tap) as
# Casks/suavez.rb, then: brew install --cask kidchenko/tap/suavez
#
# The tap's bump workflow rewrites `version` and `sha256` from the latest release.
cask "suavez" do
  version "0.0.3"
  sha256 "5a62fa8626af5476f30ce4eb20c31910eebddda3decb4a50baa627ab4b6a6e77"

  url "https://github.com/kidchenko/suavez/releases/download/v#{version}/SuaVez-#{version}.dmg"
  name "Sua Vez"
  desc "Menu bar icon that lights up when a coding agent finishes or needs you"
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

  # Take the hooks out of every agent's settings before the binary goes.
  # Left behind, every agent turn would try to run a missing file. This also
  # runs on upgrade: --package forgets the first connection too, so the new
  # version reconnects on launch. No launchctl here, or every upgrade would
  # delete "Run at login"; --zap still removes the LaunchAgent plist.
  uninstall quit:   "com.kidchenko.suavez",
            script: {
              executable:   "#{appdir}/SuaVez.app/Contents/MacOS/suavez",
              args:         ["uninstall", "--package"],
              must_succeed: false,
            }

  zap trash: [
    "~/Library/Application Support/SuaVez",
    "~/Library/LaunchAgents/com.kidchenko.suavez.plist",
  ]
end
