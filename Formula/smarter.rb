class Smarter < Formula
  desc "Command-line interface for working with Smarter resources"
  homepage "https://smarter.sh/"
  url "https://github.com/smarter-sh/smarter-cli/releases/download/v0.3.0/smarter-macos-latest-0.3.0"
  sha256 "1c191d8eba049d7bfa4b2ad83652e375e277cb3ccd7d02f0bd10ee648eea3d8f"
  license "AGPL-3.0"

  def install
    bin.install "smarter-macos-latest-0.3.0" => "smarter"
  end

  test do
    system "#{bin}/smarter", "version"
  end
end
