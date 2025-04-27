class Smarter < Formula
  desc "Command-line interface for working with Smarter resources"
  homepage "https://smarter.sh/"
  url "https://github.com/smarter-sh/smarter-cli/releases/download/v0.2.0/smarter-macos-latest-0.2.0"
  sha256 "6ff81076b7bc4d7f89c36e7633d943e0dfec9467427b9adea0183baedb285bbd"
  license "AGPL-3.0"

  def install
    bin.install "smarter-macos-latest-0.2.0" => "smarter"
  end

  test do
    system "#{bin}/smarter", "version"
  end
end
