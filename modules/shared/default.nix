{ rust-overlay, llm-agents, ... }:

{

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowBroken = false;
      allowInsecure = false;
    };

    overlays =
      # Apply each overlay found in the /overlays directory
      let path = ../../overlays; in with builtins;
      map (n: import (path + ("/" + n)))
          (filter (n: match ".*\\.nix" n != null ||
                      pathExists (path + ("/" + n + "/default.nix")))
                  (attrNames (readDir path)))
      ++ [ rust-overlay.overlays.default llm-agents.overlays.shared-nixpkgs ];
  };
}
