class Smarter < Formula
  desc "Command-line interface for working with Smarter resources"
  homepage "https://smarter.sh/"
  url "https://github.com/smarter-sh/smarter-cli/releases/download/v0.6.0/smarter-macos-latest-0.6.0"
  sha256 "abe87a1175fa594ba639e6cef943f558690a85b8a7b793be42cee976fb859d67"
  license "AGPL-3.0"

  def install
    bin.install "smarter-macos-latest-0.6.0" => "smarter"
  end

  test do
    system "#{bin}/smarter", "version"
  end
end
