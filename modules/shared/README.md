## Shared
Base configuration that `modules/darwin` builds on. Some configuration examples include `git`, `zsh`, `vim`, and `tmux`.

## Layout
```
.
├── default.nix        # Defines how we import overlays 
├── files.nix          # Non-Nix, static configuration files (now immutable!)
├── home-manager.nix   # The goods; most all shared config lives here
├── packages.nix       # List of packages to share

```
