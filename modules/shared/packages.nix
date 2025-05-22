{ pkgs }:

with pkgs; [
  # General packages for development and system management
  aspell
  aspellDicts.en
  bat
  btop
  coreutils
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
  nodePackages.npm # globally install npm
  nodePackages.prettier
  nodejs

  # Text and terminal utilities
  btop
  claude-code
  curl
  difftastic
  du-dust
  fd
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

  # Nix utilities
  comma
  nil
  nixd
  nixpkgs-fmt

  # Rust stuff
  rust-bin.stable.latest.default
  rust-analyzer

  # Python dev tools
  uv
]
