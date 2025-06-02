{ pkgs, lib }:

let shared-packages = import ../shared/packages.nix { inherit pkgs lib; }; in
shared-packages ++ lib.attrValues {
  inherit (pkgs)
    dockutil
    ;

  inherit (pkgs.jetbrains)
    pycharm-professional
    rust-rover
    ;
}
