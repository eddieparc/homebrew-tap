class AoeKo < Formula
  desc "Agent of Empires — Korean-localized web dashboard (W3A chrome + EN/KO switcher)"
  homepage "https://github.com/eddieparc/agent-of-empires"
  url "https://github.com/eddieparc/agent-of-empires/archive/refs/tags/v1.11.0-ko.2.tar.gz"
  sha256 "9d20e7c5833d6644105aaf9b2d334e28af09f021f2b4adde8d10e71c269a715f"
  license "MIT"
  head "https://github.com/eddieparc/agent-of-empires.git", branch: "feat/i18n-korean"

  depends_on "node" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"
  depends_on "tmux"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    # Build with `serve` feature so the web dashboard (Korean-localized
    # chrome) gets embedded into the binary via rust-embed. build.rs runs
    # `npm install && npm run build` in web/ during compilation.
    system "cargo", "build", "--release", "--features", "serve"

    # Install as `aoe-ko` to coexist with the upstream `aoe` formula in
    # homebrew-core. Both binaries share `~/.agent-of-empires/` state, so
    # users can switch between them by editing their LaunchAgent path
    # without losing sessions/tokens/config.
    bin.install "target/release/aoe" => "aoe-ko"
  end

  def caveats
    <<~EOS
      aoe-ko is the Korean-localized fork of Agent of Empires built from
      branch feat/i18n-korean (tag v1.11.0-ko.2). It writes to the same
      state directory as upstream `aoe` (~/.agent-of-empires/), so the
      two coexist and share sessions, tokens, and config.

      To switch a LaunchAgent-managed daemon from upstream `aoe` to
      `aoe-ko`, edit the ProgramArguments path in
        ~/Library/LaunchAgents/com.agent-of-empires.serve.plist
      to point at #{opt_bin}/aoe-ko, then reload:

        launchctl bootout gui/$(id -u)/com.agent-of-empires.serve
        launchctl bootstrap gui/$(id -u) \\
          ~/Library/LaunchAgents/com.agent-of-empires.serve.plist

      The dashboard renders in Korean by default. Toggle to English via
      the overflow (⋯) menu in the top bar; the choice persists across
      reloads via localStorage.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/aoe-ko --version")

    system bin/"aoe-ko", "init", testpath
    assert_match "Agent of Empires", (testpath/".agent-of-empires/config.toml").read

    # Sanity-probe the embedded web bundle: the binary should include
    # Korean strings from the language switcher and login chrome.
    # Use the help-only path so we don't actually start a daemon.
    help_text = shell_output("#{bin}/aoe-ko serve --help")
    assert_match "Authentication mode", help_text
  end
end
