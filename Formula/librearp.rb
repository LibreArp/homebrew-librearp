require "fileutils"
require "os"

class Librearp < Formula
  desc "Pattern-based arpeggio generator plugin"
  homepage "https://librearp.gitlab.io/"
  url "https://gitlab.com/LibreArp/LibreArp.git",
    tag:      "2.5",
    revision: "2d96a74f54b8ccc5189e157cb669841a854625aa"
  license "GPL-3.0-or-later"
  head "https://gitlab.com/LibreArp/LibreArp.git",
    branch: "develop"

  depends_on "cmake" => :build
  depends_on "gcc" => :build
  depends_on "curl"
  depends_on "freetype" if OS.linux?

  def install
    mkdir "build" do
      system "cmake", "..",
        "-DCMAKE_OSX_ARCHITECTURES=arm64;x86_64"
      system "cmake",
        "--build", ".",
        "--target", "LibreArp_VST3",
        "--config", "Release"

      librearp_lib = lib/"librearp"
      mkdir_p librearp_lib
      librearp_lib.install "LibreArp_artefacts/VST3/LibreArp.vst3" => "LibreArp.vst3"
    end

    bin.install "Scripts/update-librearp.sh" => "update-librearp"
  end

  def caveats
    <<~EOS
      To finish installing LibreArp, please run the `update-librearp' command to link the plugin into the standard user-specific plugin directory.
      You may also use `sudo update-librearp install global' to link the plugin for all users.

      For further information, please consult the user guide: https://librearp.gitlab.io/guide/install/
    EOS
  end
end
