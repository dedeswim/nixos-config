{ pkgs, lib }:

let shared-packages = import ../shared/packages.nix { inherit pkgs lib; }; in
shared-packages ++ lib.attrValues {
  inherit (pkgs)
    # Security and authentication
    yubikey-agent
    keepassxc

    # App and package management
    appimage-run
    gnumake
    cmake
    home-manager

    # Media and design tools
    vlc
    fontconfig
    font-manager

    # Productivity tools
    bc # old school calculator
    galculator

    # Audio tools
    pavucontrol # Pulse audio controls

    # Testing and development tools
    direnv
    rofi
    rofi-calc
    postgresql

    # Screenshot and recording tools
    flameshot

    # Text and terminal utilities
    feh # Manage wallpapers
    screenkey
    tree

    # File and system utilities
    inotify-tools # inotifywait, inotifywatch - For file system events
    i3lock-fancy-rapid
    libnotify
    pcmanfm # File browser
    sqlite
    xdg-utils

    # Other utilities
    yad # yad-calendar is used with polybar
    xdotool
    google-chrome

    # PDF viewer
    zathura

    # Music and entertainment
    spotify
    ;

  # Packages with dots in their names
  inherit (pkgs.unixtools) ifconfig netstat;
  inherit (pkgs.xorg) xwininfo xrandr;
}
