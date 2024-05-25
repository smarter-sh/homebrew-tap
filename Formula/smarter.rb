class Smarter < Formula
  desc "Command-line interface for working with Smarter resources"
  homepage "https://smarter.sh/"
  url "https://github.com/smarter-sh/smarter-cli/releases/download/v0.0.2/smarter-macos-latest-0.0.2"
  sha256 "a55d557c11c31dfd28dcfa48a6fac77982f56644ce5c90a99a833f76977b5bbb"
  license "AGPL-3.0"

  def install
    bin.install "smarter-macos-latest-0.0.2" => "smarter"
  end

  test do
    system "#{bin}/smarter", "version"
  end
end
