{ pkgs, lib }:

lib.attrValues {
  inherit (pkgs)
    # General packages for development and system management
    aspell
    bat
    btop
    carapace
    claude-code
    coreutils
    difftastic
    killall
    neofetch
    openssh
    pandoc
    podman
    wget
    zip

    # Encryption and security tools
    age
    age-plugin-yubikey
    gnupg
    libfido2

    # Cloud-related tools and SDKs
    google-cloud-sdk

    # Media-related packages
    dejavu_fonts
    ffmpeg
    fd
    font-awesome
    hack-font
    noto-fonts
    noto-fonts-color-emoji
    meslo-lgs-nf

    # Node.js development tools
    nodejs

    # Text and terminal utilities
    curl
    dust
    hunspell
    iftop
    jetbrains-mono
    jq
    mosh
    ripgrep
    tealdeer
    tree
    tmux
    unrar
    unzip
    zenith
    zoxide

    # Nix utilities
    comma
    nil
    nixd
    nixpkgs-fmt

    scrcpy

    # Rust stuff
    rust-analyzer

    # Python dev tools
    uv
    ;

  # Packages with dots in their names
  inherit (pkgs.aspellDicts) en;
  inherit (pkgs.nodePackages) prettier;
  inherit (pkgs.texlive.combined) scheme-full;

  # Custom packages
  rust = pkgs.rust-bin.stable.latest.default.override {
    extensions = [ "rust-src" ];
  };

  mcp-language-server = pkgs.buildGoModule {
    pname = "mcp-language-server";
    version = "0.1.1";

    src = pkgs.fetchFromGitHub {
      owner = "isaacphi";
      repo = "mcp-language-server";
      rev = "v0.1.1";
      sha256 = "sha256-T0wuPSShJqVW+CcQHQuZnh3JOwqUxAKv1OCHwZMr7KM=";
    };

    vendorHash = "sha256-3NEG9o5AF2ZEFWkA9Gub8vn6DNptN6DwVcn/oR8ujW0=";

    # Exclude test directories from build
    excludedPackages = [ "integrationtests" ];

    # Only build the main binary
    subPackages = [ "." ];

    meta = with pkgs.lib; {
      description = "MCP Language Server gives MCP enabled clients access semantic tools";
      homepage = "https://github.com/isaacphi/mcp-language-server";
      license = licenses.bsd3;
    };
  };
}
