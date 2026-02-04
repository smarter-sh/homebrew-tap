class Smarter < Formula
  desc "Command-line interface for working with Smarter resources"
  homepage "https://smarter.sh/"
  url "https://github.com/smarter-sh/smarter-cli/releases/download/v0.2.1/smarter-macos-latest-0.2.1"
  sha256 "7c787c0e81e0b12dc8ceaad807dadf94e9ac41cd85cfb69b022decbdc9469f93"
  license "AGPL-3.0"

  def install
    bin.install "smarter-macos-latest-0.2.1" => "smarter"
  end

  test do
    system "#{bin}/smarter", "version"
  end
end
