# Temporary: opencode 2.2.5's node_modules FOD hash is wrong in nixpkgs
# (https://github.com/NixOS/nixpkgs/issues/582673). The pending fix
# (NixOS/nixpkgs#582675) uses a different hash than darwin produces, so pin
# the darwin hash here. Remove once nixpkgs builds opencode on darwin again.
self: super: {
  opencode =
    if super.stdenv.hostPlatform.isDarwin && super.opencode.version == "2.2.5" then
      super.opencode.overrideAttrs (old: {
        node_modules = old.node_modules.overrideAttrs {
          outputHash = "sha256-dIveiaiPFGSItwLyeMuPDxTE9gpvvnlTCB/+nG24qCc=";
        };
      })
    else
      super.opencode;
}
