class Marc < Formula
  desc "Map Reprojections and Conversions"
  homepage "https://sourceforge.net/projects/marc/"
  url "https://downloads.sourceforge.net/project/marc/marc/0.9.9/marc-0.9.9.tar.gz"
  sha256 "5dd19d84a97ef9116b95526d08eb9ae7d36c4402216ba08b9657db029c511cbb"
  head "https://github.com/ossama-othman/MaRC.git"

  depends_on "pkg-config" => :build
  depends_on "cfitsio"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"

    system "make", "install"
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! For Homebrew/homebrew-core
    # this will need to be a test that verifies the functionality of the
    # software. Run the test with `brew test marc`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    system "false"
  end
end
