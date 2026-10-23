# Homebrew cask. Lives in a tap (github.com/kidchenko/homebrew-tap) as
# Casks/cantos.rb, then: brew install --cask kidchenko/tap/cantos
#
# The tap's bump workflow rewrites `version` and `sha256` from the latest release.
cask "cantos" do
  version "0.0.3"
  sha256 "2ae1e64ff5d289e89c2a911d197cfa9447fd0a4767b764d447a64cffd7850257"

  url "https://github.com/kidchenko/cantos/releases/download/v#{version}/Cantos-#{version}.dmg"
  name "Cantos"
  desc "Hot corners that run an action when the pointer reaches a screen corner"
  homepage "https://github.com/kidchenko/cantos"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on :macos

  app "Cantos.app"

  # Ad-hoc signed, not notarized: without this, Gatekeeper refuses to open it.
  postflight_steps do
    run "/usr/bin/xattr",
        args:           ["-dr", "com.apple.quarantine", "{{appdir}}/Cantos.app"],
        writable_paths: ["{{appdir}}/Cantos.app"]
  end

  uninstall launchctl: "com.kidchenko.cantos",
            quit:      "com.kidchenko.cantos"

  zap trash: [
    "~/Library/Application Support/Cantos",
    "~/Library/LaunchAgents/com.kidchenko.cantos.plist",
  ]
end
