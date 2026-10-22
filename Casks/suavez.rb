# Homebrew cask. Lives in a tap (github.com/kidchenko/homebrew-tap) as
# Casks/suavez.rb, then: brew install --cask kidchenko/tap/suavez
#
# The tap's bump workflow rewrites `version` and `sha256` from the latest release.
cask "suavez" do
  version "0.0.2"
  sha256 "b12394a81255fdd9434d016761ee2a310c6ed39a2cd39d5715e2f02c71a3bb12"

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
  # Left behind, every agent turn would try to run a missing file.
  uninstall launchctl: "com.kidchenko.suavez",
            quit:      "com.kidchenko.suavez",
            script:    {
              executable:   "#{appdir}/SuaVez.app/Contents/MacOS/suavez",
              args:         ["uninstall"],
              must_succeed: false,
            }

  zap trash: [
    "~/Library/Application Support/SuaVez",
    "~/Library/LaunchAgents/com.kidchenko.suavez.plist",
  ]
end
