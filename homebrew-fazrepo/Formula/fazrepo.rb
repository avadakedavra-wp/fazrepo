class Fazrepo < Formula
  desc "A fast CLI tool to check package manager versions"
  homepage "https://github.com/avadakedavra-wp/fazrepo"
  url "https://github.com/avadakedavra-wp/fazrepo/archive/v0.2.0.tar.gz"
  sha256 "23c3743003886919f73b92f5ffcab91b24ff8d0ce91e24dfc72b9ae43718a794"
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
