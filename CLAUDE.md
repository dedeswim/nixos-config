# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a flake-based **nix-darwin** configuration for a single Apple Silicon Mac (`aarch64-darwin`). (It was forked from a template that also supported NixOS; the Linux side has been removed.)

Configuration is split into a shared base module and a macOS module. Key features include agenix for secrets management, home-manager for user-level configuration, and nix-homebrew for Homebrew casks.

## Common Development Commands

### Building and Switching

```bash
nix run .#build          # Build without switching (test changes)
nix run .#build-switch   # Build and activate new configuration (needs sudo)
nix run .#rollback       # Rollback to previous generation (interactive)
```

Flakes only see files tracked by git: `git add` new files before building.

### SSH Key Management

```bash
nix run .#create-keys    # Generate SSH keys (id_ed25519, id_ed25519_agenix)
nix run .#copy-keys      # Copy keys from USB drive to ~/.ssh/
nix run .#check-keys     # Verify all required keys are present
```

### Initial Setup

```bash
nix run .#apply          # Interactive first-time setup
                         # Collects user info, GitHub credentials
                         # Performs token replacement throughout config
```

### Standard Flake Commands

```bash
nix flake check          # Validate flake configuration
nix flake update         # Update flake.lock dependencies
nix flake show           # Show available outputs
```

### Manual Rebuild (if needed)

```bash
sudo darwin-rebuild switch --flake .#aarch64-darwin
```

## Architecture and Structure

### Module Layout

The repository splits configuration across two module directories:

#### 1. `modules/shared/` - Base Configuration

The foundation that the darwin module builds on. Contains:
- **`home-manager.nix`**: Most shared configuration lives here (zsh, vim, git, tmux, ssh, starship, helix)
- **`packages.nix`**: Base packages (dev tools, fonts, nix utilities, Rust, Python)
- **`default.nix`**: Nixpkgs configuration and overlay loading
- **`files.nix`**: Public keys and immutable static configuration files

**Custom packages**: Includes `mcp-language-server` built from source.

#### 2. `modules/darwin/` - macOS-Specific Configuration

- **`home-manager.nix`**: User setup, homebrew integration, dock configuration
- **`casks.nix`**: Homebrew casks (Ghostty, VSCode, Discord, etc.)
- **`packages.nix`**: Darwin-specific packages
- **`secrets.nix`**: Age-encrypted secrets (GitHub signing key)
- **`dock/`**: Declarative dock management using dockutil
- **`files.nix`**: macOS-specific files

### Configuration Flow

`flake.nix` builds `darwinConfigurations.aarch64-darwin` from:
1. The shared module (nixpkgs config, overlays)
2. Determinate, home-manager and nix-homebrew modules
3. `hosts/darwin`, which imports `modules/darwin/secrets.nix`, `modules/darwin/home-manager.nix`, `modules/shared`, and agenix

### Key Architectural Patterns

**Overlays Auto-Load**: Any `.nix` file in `overlays/` runs automatically during each build. Common uses include applying patches, version pinning, and temporary workarounds.

**Immutable Static Files**: Files managed through `files.nix` are immutable. To update them, modify `files.nix` and rebuild.

**Secrets Management**: Uses agenix with age encryption. Keys stored at:
- Identity: `~/.ssh/id_ed25519`
- GitHub signing key at `~/.ssh/pgp_github.key`
- Public keys in `shared/files.nix`
- Private secrets repo: `git+ssh://git@github.com/dedeswim/nix-secrets.git`

**Token Replacement System**: The `apply` script uses tokens (`%USER%`, `%EMAIL%`, etc.) for initial setup configuration.

**Package Lists**: Each module has its own `packages.nix`:
- Shared: Base tools and utilities
- Darwin: macOS-specific packages

### Integration Points

- **home-manager**: User-level configuration management
- **agenix**: Age-encrypted secrets
- **nix-darwin**: macOS system configuration
- **nix-homebrew**: Declarative homebrew management for macOS (casks and Mac App Store apps)
- **rust-overlay**: Rust toolchain management

## Important Conventions

### Working with Modules

- Most shared user configuration is in `modules/shared/home-manager.nix`
- macOS user/homebrew/dock configuration is in `modules/darwin/home-manager.nix`
- System-level and host-specific settings go in `hosts/darwin/default.nix`

### Adding Packages

Add packages to the appropriate `packages.nix` file:
- Base packages: `modules/shared/packages.nix`
- macOS packages: `modules/darwin/packages.nix`
- Homebrew casks: `modules/darwin/casks.nix`

### Adding Overlays

Create a new `.nix` file in `overlays/` - it will automatically load on the next build. No need to explicitly import it.

### Modifying Configuration Files

Static configuration files (dotfiles, configs) should be added to the appropriate `files.nix`:
- `modules/shared/files.nix` for base files
- `modules/darwin/files.nix` for macOS-only files

These files become immutable after deployment.

### Secrets Management

Secrets are managed with agenix:
1. Ensure SSH keys exist (`nix run .#check-keys`)
2. Add encrypted secrets to the private secrets repository
3. Reference them in `secrets.nix` files
4. They're decrypted at activation time

## Module Organization Reference

For detailed module structure, see the README files:
- `modules/shared/README.md` - Shared module structure
- `modules/darwin/README.md` - Darwin module structure
- `overlays/README.md` - Overlay documentation

## Configuration Details

**Primary User**: edoardo
- Shell: zsh with starship prompt, atuin, zoxide
- Editors: vim (extensive config), helix
- Version Control: Git with GPG signing, difftastic for diffs
- Terminal Multiplexer: tmux with custom configuration

**System Support**: aarch64-darwin (Apple Silicon) only

**Nixpkgs Configuration**:
- Channel: nixos-unstable
- Unfree packages: Allowed
- Broken packages: Allowed
- Insecure packages: Not allowed
