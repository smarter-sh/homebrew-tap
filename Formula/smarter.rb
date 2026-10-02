class Smarter < Formula
  desc "Command-line interface for working with Smarter resources"
  homepage "https://smarter.sh/"
  url "https://github.com/smarter-sh/smarter-cli/releases/download/v0.4.0/smarter-macos-latest-0.4.0"
  sha256 "23cfc6e7208a40863918f8051c6d9319f5d2ce4577878147dd62cfdd9ff50005"
  license "AGPL-3.0"

  def install
    bin.install "smarter-macos-latest-0.4.0" => "smarter"
  end

  test do
    system "#{bin}/smarter", "version"
  end
end
