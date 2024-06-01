class Smarter < Formula
  desc "Command-line interface for working with Smarter resources"
  homepage "https://smarter.sh/"
  url "https://github.com/smarter-sh/smarter-cli/releases/download/v0.1.0/smarter-macos-latest-0.1.0"
  sha256 "6ef63be73806e811a4595c456eee2a1205c99d1cb27ac86fc1e4afa541d24941"
  license "AGPL-3.0"

  def install
    bin.install "smarter-macos-latest-0.0.2" => "smarter"
  end

  test do
    system "#{bin}/smarter", "version"
  end
end
