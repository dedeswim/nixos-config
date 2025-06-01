{ config, pkgs, ... }:

let
  user = "edoardo";
  # Define the content of your file as a derivation
  sharedFiles = import ../shared/files.nix { inherit config pkgs; };
  additionalFiles = import ./files.nix { inherit user config pkgs; };
in
{
  imports = [
   ./dock
  ];

  # It me
  users.users.${user} = {
    name = "${user}";
    home = "/Users/${user}";
    isHidden = false;
    shell = pkgs.nushell;
  };

  homebrew = {
    enable = true;
    casks = pkgs.callPackage ./casks.nix {};
    # onActivation.cleanup = "uninstall";

    # These app IDs are from using the mas CLI app
    # mas = mac app store
    # https://github.com/mas-cli/mas
    #
    # $ nix shell nixpkgs#mas
    # $ mas search <app name>
    #
    # If you have previously added these apps to your Mac App Store profile (but not installed them on this system),
    # you may receive an error message "Redownload Unavailable with This Apple ID".
    # This message is safe to ignore. (https://github.com/dustinlyons/nixos-config/issues/83)

    masApps = {
      Amphetamine = 1666309574;
      Bitwarden = 1352778147;
      Keynote = 409183694;
      Numbers = 409203825;
      Pages = 409201541;
      "Prime Video" = 1666309574;
      "Rocket.Chat" = 1086818840;
      Slack = 803453959;
      "Spark Desktop" = 6445813049;
      Telegram = 747648890;
      "Yubico Authenticator" = 1497506650;
      WhatsApp = 1147396723;
    };
  };

  # Enable home-manager
  home-manager = {
    useGlobalPkgs = true;
    users.${user} = { pkgs, config, lib, ... }:{
      home = {
        enableNixpkgsReleaseCheck = false;
        packages = pkgs.callPackage ./packages.nix { inherit pkgs lib; };
        file = lib.mkMerge [
          sharedFiles
          additionalFiles
        ];

        stateVersion = "25.05";
      };
      programs = {} // import ../shared/home-manager.nix { inherit config pkgs lib; };

      # Marked broken Oct 20, 2022 check later to remove this
      # https://github.com/nix-community/home-manager/issues/3344
      manual.manpages.enable = false;
    };
  };

  # Fully declarative dock using the latest from Nix Store
  local = {
    dock = {
      enable = true;
      username = user;
      entries = [
        { path = "/Applications/Safari.app/"; }
        { path = "/System/Applications/Calendar.app/"; }
        { path = "/System/Applications/Music.app/"; }
        { path = "/System/Applications/System Settings.app/"; }
        { path = "/Applications/TIDAL.app/"; }
        { path = "/Applications/Slack.app/"; }
        { path = "/Applications/Ghostty.app/"; }
        { path = "/Applications/Zed.app/"; }
        { path = "/Applications/Spark Desktop.app/"; }
      ];
    };
  };
}
