{ agenix, pkgs, lib, ... }:

let user = "edoardo"; in

{

  imports = [
    ../../modules/darwin/secrets.nix
    ../../modules/darwin/home-manager.nix
    ../../modules/shared
    agenix.darwinModules.default
  ];

  # Nix itself is managed by Determinate (determinateNix.enable = true makes
  # nix-darwin stand down; it owns /etc/nix/nix.conf). Custom nix.conf settings
  # go through customSettings, which is written to /etc/nix/nix.custom.conf.
  determinateNix = {
    enable = true;
    customSettings = {
      # numtide cache — supplies the llm-agents.nix prebuilts (codex, …).
      extra-substituters = [ "https://cache.numtide.com" ];
      extra-trusted-public-keys = [ "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g=" ];
    };
  };

  # Load configuration that is shared across systems
  environment.systemPackages = [
    agenix.packages."${pkgs.stdenv.hostPlatform.system}".default
  ] ++ (import ../../modules/shared/packages.nix { inherit pkgs lib; });

  system = {
    checks.verifyNixPath = false;
    primaryUser = user;
    stateVersion = 4;

    defaults = {
      NSGlobalDomain = {
        AppleShowAllExtensions = true;
        ApplePressAndHoldEnabled = false;

        # 120, 90, 60, 30, 12, 6, 2
        KeyRepeat = 2;

        # 120, 94, 68, 35, 25, 15
        InitialKeyRepeat = 15;
      };

      dock = {
        autohide = false;
        show-recents = false;
        launchanim = true;
        orientation = "bottom";
        tilesize = 48;
      };

      finder = {
        _FXShowPosixPathInTitle = false;
      };

      trackpad = {
        TrackpadThreeFingerDrag = true;
      };
    };
  };

  networking = {
    computerName = "MacBook Pro of Edoardo";
    hostName = "edoardos-macbook-pro";
    knownNetworkServices = [
      "Wi-Fi"
      "USB 10/100/1000 LAN"
    ];
    dns = [
      "1.1.1.1"
      "8.8.8.8"
    ];
  };

  # Add ability to used TouchID for sudo authentication
  security.pam.services.sudo_local.touchIdAuth = true;

  fonts.packages = with pkgs; [
    nerd-fonts.caskaydia-cove
    nerd-fonts.fira-code
    nerd-fonts.monaspace
    font-awesome
  ];
}
