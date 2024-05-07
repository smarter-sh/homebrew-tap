class Smarter < Formula
  desc "A multi-platform command-line interface for working with Smarter resources."
  version "0.0.1"
  homepage "https://smarter.sh/"
  url "https://github.com/QueriumCorp/smarter-cli/releases/download/v0.0.1/smarter-macos-latest-0.0.1"
  sha256 "47f3c5eee50922651dd2617cf7a462625f2fadad860ad55bc12d27a67b1e8a0f"
  license "AGPL-3.0"

  def install
    bin.install "smarter-macos-latest-0.0.1" => "smarter"
  end

  test do
    system "#{bin}/smarter", "version"
  end
end