# Homebrew cask. Lives in a tap (github.com/kidchenko/homebrew-tap) as
# Casks/luz.rb, then: brew install --cask kidchenko/tap/luz
#
# The tap's bump workflow rewrites `version` and `sha256` from the latest release.
cask "luz" do
  version "0.0.1"
  sha256 "2e027f789b10837b05c5162cbf1e2ae9997e3ff21a951d75c27b4833b481e02c"

  url "https://github.com/kidchenko/luz/releases/download/v#{version}/Luz-#{version}.dmg"
  name "Luz"
  desc "Warms the screen at night, like f.lux"
  homepage "https://github.com/kidchenko/luz"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on :macos

  app "Luz.app"

  # Ad-hoc signed, not notarized: without this, Gatekeeper refuses to open it.
  postflight_steps do
    run "/usr/bin/xattr",
        args:           ["-dr", "com.apple.quarantine", "{{appdir}}/Luz.app"],
        writable_paths: ["{{appdir}}/Luz.app"]
  end

  uninstall launchctl: "com.kidchenko.luz",
            quit:      "com.kidchenko.luz"

  zap trash: [
    "~/Library/Application Support/Luz",
    "~/Library/LaunchAgents/com.kidchenko.luz.plist",
  ]
end
