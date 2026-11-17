class Smarter < Formula
  desc "Command-line interface for working with Smarter resources"
  homepage "https://smarter.sh/"
  url "https://github.com/smarter-sh/smarter-cli/releases/download/v0.5.1/smarter-macos-latest-0.5.1"
  sha256 "9b4e5cc521c9dd4bacd88d0fed387a6d73819cbf22d758134d6ef95641d6bd3d"
  license "AGPL-3.0"

  def install
    bin.install "smarter-macos-latest-0.5.1" => "smarter"
  end

  test do
    system "#{bin}/smarter", "version"
  end
end
