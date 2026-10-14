class Smarter < Formula
  desc "Command-line interface for working with Smarter resources"
  homepage "https://smarter.sh/"
  url "https://github.com/smarter-sh/smarter-cli/releases/download/v0.4.2/smarter-macos-latest-0.4.2"
  sha256 "38d7f474b62e6cf89541662421509e76e0af4429868b3c6bcd581b303bfeb146"
  license "AGPL-3.0"

  def install
    bin.install "smarter-macos-latest-0.4.2" => "smarter"
  end

  test do
    system "#{bin}/smarter", "version"
  end
end
