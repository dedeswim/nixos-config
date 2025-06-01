{ pkgs, lib }:

lib.attrValues {
  inherit (pkgs)
    # General packages for development and system management
    aspell
    bat
    btop
    claude-code
    coreutils
    difftastic
    killall
    neofetch
    openssh
    wget
    zip

    # Encryption and security tools
    age
    age-plugin-yubikey
    gnupg
    libfido2

    # Cloud-related tools and SDKs
    docker
    docker-compose
    google-cloud-sdk

    # Media-related packages
    dejavu_fonts
    ffmpeg
    fd
    font-awesome
    hack-font
    noto-fonts
    noto-fonts-emoji
    meslo-lgs-nf

    # Node.js development tools
    nodejs

    # Text and terminal utilities
    curl
    du-dust
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

    # Rust stuff
    rust-analyzer

    # Python dev tools
    uv
    ;

  # Packages with dots in their names
  inherit (pkgs.aspellDicts) en;
  inherit (pkgs.nodePackages) npm prettier;
  inherit (pkgs.texlive.combined) scheme-full;

  # Custom packages
  rust = pkgs.rust-bin.stable.latest.default.override {
    extensions = [ "rust-src" ];
  };
}
