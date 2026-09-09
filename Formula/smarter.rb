class Smarter < Formula
  desc "Command-line interface for working with Smarter resources"
  homepage "https://smarter.sh/"
  url "https://github.com/smarter-sh/smarter-cli/releases/download/v0.3.0/smarter-macos-latest-0.3.0"
  sha256 "986199af3a20388aca90d286d2b86ddcbfe813cd9a0a5921cb048d0ba6e92054"
  license "AGPL-3.0"

  def install
    bin.install "smarter-macos-latest-0.3.0" => "smarter"
  end

  test do
    system "#{bin}/smarter", "version"
  end
end
