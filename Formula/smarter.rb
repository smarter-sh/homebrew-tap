class Smarter < Formula
  desc "Command-line interface for working with Smarter resources"
  homepage "https://smarter.sh/"
  url "https://github.com/smarter-sh/smarter-cli/releases/download/v0.5.0/smarter-macos-latest-0.5.0"
  sha256 "48dd6d138726344c4e563ce9a968c056535cecd9dbf3b6d4c1b2d367b94f665d"
  license "AGPL-3.0"

  def install
    bin.install "smarter-macos-latest-0.5.0" => "smarter"
  end

  test do
    system "#{bin}/smarter", "version"
  end
end
