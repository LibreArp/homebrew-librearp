require "fileutils"
require "os"

class Librearp < Formula
  desc "Pattern-based arpeggio generator plugin"
  homepage "https://librearp.gitlab.io/"
  url "https://gitlab.com/LibreArp/LibreArp.git",
    tag:      "2.1",
    revision: "5ee3c1477b06f68392e829770093a654be9348a2"
  license "GPL-3.0-or-later"

  depends_on "cmake" => :build
  depends_on "gcc" => :build
  depends_on "curl"
  depends_on "freetype" if OS.linux?

  def install
    mkdir "build" do
      system "cmake", ".."
      system "cmake",
        "--build", ".",
        "--target", "LibreArp_VST3",
        "--config", "Release"
      prefix.install "LibreArp_artefacts/VST3/LibreArp.vst3"

      vst3_name = "LibreArp.vst3"
      if OS.mac?
        main_outdir = "/Users/#{ENV["USER"]}/Library/Audio/Plug-ins/"
        vst3_outdir = main_outdir + "VST3/"
      else
        main_outdir = "/home/#{ENV["USER"]}/"
        vst3_outdir = main_outdir + ".vst3/"
      end

      vst3_path = Pathname.new(vst3_outdir + vst3_name)

      mkdir_p vst3_outdir
      rm vst3_path if vst3_path.exist?
      ln_s "#{prefix}/LibreArp.vst3", vst3_path, force: true
    end
  end

  test do
    # TODO: Add a proper test
    assert_true true
  end
end
