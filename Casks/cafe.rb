# Homebrew cask. Lives in a tap (github.com/kidchenko/homebrew-tap) as
# Casks/cafe.rb, then: brew install --cask kidchenko/tap/cafe
#
# The tap's bump workflow rewrites `version` and `sha256` from the latest release.
cask "cafe" do
  version "0.0.1"
  sha256 "7942e9b7b4baa3e945f57b5dbc52f6ef9eaba7f30097263df8c4e3db4c98e583"

  url "https://github.com/kidchenko/cafe/releases/download/v#{version}/Cafe-#{version}.dmg"
  name "Cafe"
  desc "Menu bar toggle that keeps the computer awake"
  homepage "https://github.com/kidchenko/cafe"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on :macos

  app "Cafe.app"

  # Ad-hoc signed, not notarized: without this, Gatekeeper refuses to open it.
  postflight_steps do
    run "/usr/bin/xattr",
        args:           ["-dr", "com.apple.quarantine", "{{appdir}}/Cafe.app"],
        writable_paths: ["{{appdir}}/Cafe.app"]
  end

  uninstall launchctl: "com.kidchenko.cafe",
            quit:      "com.kidchenko.cafe"

  zap trash: [
    "~/Library/Application Support/Cafe",
    "~/Library/LaunchAgents/com.kidchenko.cafe.plist",
  ]
end
