class Fazrepo < Formula
  desc "A fast CLI tool to check package manager versions"
  homepage "https://github.com/avadakedavra-wp/fazrepo"
  url "https://github.com/avadakedavra-wp/fazrepo/archive/v0.1.1.tar.gz"
  sha256 "REPLACE_WITH_ACTUAL_SHA256"
  license "MIT"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "#{bin}/fazrepo", "--version"
    system "#{bin}/fazrepo", "--help"
  end
end
