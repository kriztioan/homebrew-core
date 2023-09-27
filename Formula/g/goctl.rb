class Goctl < Formula
  desc "Generates server-side and client-side code for web and RPC services"
  homepage "https://go-zero.dev"
  url "https://github.com/zeromicro/go-zero/archive/refs/tags/tools/goctl/v1.5.6.tar.gz"
  sha256 "9e0567ecc2d24c8146172db2f534a2366d2ecda90ab9e519133d6b6fd7a96d20"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "820aea5687351bf1ac3f45f204069ace118502e9e9868e296859ce9f72574978"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d669957e6e74e8031b3d7b63f55ca7c66bcc231e4b9905748957527e3320993d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "85a62baf8988c0e5dde0c36b9bbb4fe80a3c84a7ca72ebc75c461b9a3c2ccc0b"
    sha256 cellar: :any_skip_relocation, ventura:        "7f1f5c1c480d78c09355f26b7ead9d464eeda86e5e014fc16a3e2d093b11a04c"
    sha256 cellar: :any_skip_relocation, monterey:       "c9748e511e75b39724f32dd4fb58ac7b449545743410cb6ac542744a3833dc61"
    sha256 cellar: :any_skip_relocation, big_sur:        "9b481f652a752b433483fadd80f3eb1d44ea759d0b9f06b5c3f0adcf3c37d65c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1eb087fcf87ddd2331ee56a72627dd4ffb77c974017b77527a0060df25ba6fed"
  end

  depends_on "go" => :build

  def install
    chdir "tools/goctl" do
      system "go", "build", *std_go_args(ldflags: "-s -w"), "goctl.go"
    end

    generate_completions_from_executable(bin/"goctl", "completion")
  end

  test do
    assert_match "goctl version #{version}", shell_output("#{bin}/goctl --version")
    # configure project path
    %w[api model rpc docker kube mongo newapi gateway].each do |f|
      mkdir_p testpath/"#{version}/#{f}"
    end
    system bin/"goctl", "template", "init", "--home=#{testpath}"
    assert_predicate testpath/"api/main.tpl", :exist?, "goctl install fail"
  end
end
