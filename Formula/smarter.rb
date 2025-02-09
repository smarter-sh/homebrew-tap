class Smarter < Formula
  desc "Command-line interface for working with Smarter resources"
  homepage "https://smarter.sh/"
  url "https://github.com/smarter-sh/smarter-cli/releases/download/v0.1.2/smarter-macos-latest-0.1.2"
  sha256 "2d41de22a65555f647bcc8865d9ebc1dbb9f5bd7c576ad74fe409b0973e30eec"
  license "AGPL-3.0"

  def install
    bin.install "smarter-macos-latest-0.1.2" => "smarter"
  end

  test do
    system "#{bin}/smarter", "version"
  end
end
