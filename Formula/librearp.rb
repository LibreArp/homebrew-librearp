require 'fileutils'
require 'os'

class Librearp < Formula
  desc "A pattern-based arpeggio generator plugin"
  homepage "https://librearp.gitlab.io/"
  license "GPL-3.0-or-later"
  url "https://gitlab.com/LibreArp/LibreArp.git",
    using: :git,
    tag: "2.1"

  depends_on "gcc" => :build
  depends_on "cmake" => :build
  depends_on "curl"

  def install
    mkdir "build" do
      system "cmake", ".."
      system "cmake",
        "--build", ".",
        "--target", "LibreArp_VST3",
        "--config", "Release"

      if os.mac?
        main_outdir = "/Users/#{ENV["USER"]}/Library/Audio/Plug-ins/"
        vst3_outdir = main_outdir + "VST3/"
      else
        main_outdir = "/home/#{ENV["USER"]}/"
        vst3_outdir = main_outdir + ".vst3/"
      end

      FileUtils.cp_r "LibreArp_artefacts/VST3/LibreArp.vst3", vst3_outdir
    end
  end
end
