class Smarter < Formula
  desc "Command-line interface for working with Smarter resources"
  homepage "https://smarter.sh/"
  url "https://github.com/smarter-sh/smarter-cli/releases/download/v0.1.0/smarter-macos-latest-0.1.0"
  sha256 "35419ee231667235a226e97c98741610d172de7006b81e965465665bd4c18f73"
  license "AGPL-3.0"

  def install
    bin.install "smarter-macos-latest-0.1.0" => "smarter"
  end

  test do
    system "#{bin}/smarter", "version"
  end
end
