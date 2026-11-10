class Smarter < Formula
  desc "Command-line interface for working with Smarter resources"
  homepage "https://smarter.sh/"
  url "https://github.com/smarter-sh/smarter-cli/releases/download/v0.5.1/smarter-macos-latest-0.5.1"
  sha256 "bd9e131dba762d1e6a8c1c589cc58ed7911b7cad40d6e2bd4704e58619c54f17"
  license "AGPL-3.0"

  def install
    bin.install "smarter-macos-latest-0.5.1" => "smarter"
  end

  test do
    system "#{bin}/smarter", "version"
  end
end
