class Smarter < Formula
  desc "Command-line interface for working with Smarter resources"
  homepage "https://smarter.sh/"
  url "https://github.com/smarter-sh/smarter-cli/releases/download/v0.5.0/smarter-macos-latest-0.5.0"
  sha256 "7b026356bc8b2a8ce643026371eb0ca8912d30d3cca612007b01a428ab035fde"
  license "AGPL-3.0"

  def install
    bin.install "smarter-macos-latest-0.5.0" => "smarter"
  end

  test do
    system "#{bin}/smarter", "version"
  end
end
