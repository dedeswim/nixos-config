# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a modern, flake-based NixOS configuration that supports both:
- **NixOS** (Linux systems)
- **nix-darwin** (macOS systems)

The configuration uses a three-tier module hierarchy to maximize code reuse while allowing platform-specific customization. Key features include agenix for secrets management, home-manager for user-level configuration, nix-homebrew for macOS packages, and disko for disk partitioning on NixOS.

## Common Development Commands

### Building and Switching

**macOS (Darwin):**
```bash
nix run .#build          # Build without switching (test changes)
nix run .#build-switch   # Build and activate new configuration
nix run .#rollback       # Rollback to previous generation (interactive)
```

**NixOS (Linux):**
```bash
nix run .#build-switch   # Build and switch to new configuration
```

### SSH Key Management

```bash
nix run .#create-keys    # Generate SSH keys (id_ed25519, id_ed25519_agenix)
nix run .#copy-keys      # Copy keys from USB drive to ~/.ssh/
nix run .#check-keys     # Verify all required keys are present
```

### Initial Setup

```bash
nix run .#apply          # Interactive first-time setup
                         # Collects user info, GitHub credentials, host details
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
# macOS
darwin-rebuild switch --flake .#aarch64-darwin

# NixOS
sudo nixos-rebuild switch --flake .#x86_64-linux
```

## Architecture and Structure

### Three-Tier Module Hierarchy

The repository follows a clear separation of concerns across three module directories:

#### 1. `modules/shared/` - Cross-Platform Configuration

The foundation shared by both platforms. Contains:
- **`home-manager.nix`**: Most shared configuration lives here (zsh, vim, git, tmux, ssh, starship, helix)
- **`packages.nix`**: Common packages (70+ tools including dev tools, fonts, nix utilities, Rust, Python)
- **`default.nix`**: Nixpkgs configuration and overlay loading
- **`files.nix`**: Public keys and immutable static configuration files
- **`config/`**: Non-Nix configuration files

**Custom packages**: Includes `mcp-language-server` built from source.

#### 2. `modules/darwin/` - macOS-Specific Configuration

- **`home-manager.nix`**: User setup, homebrew integration, dock configuration
- **`casks.nix`**: Homebrew casks (Ghostty, VSCode, Discord, etc.)
- **`packages.nix`**: Darwin-specific packages
- **`secrets.nix`**: Age-encrypted secrets (GitHub signing key)
- **`dock/`**: Declarative dock management using dockutil
- **`files.nix`**: macOS-specific files

#### 3. `modules/nixos/` - Linux-Specific Configuration

- **`home-manager.nix`**: Desktop environment setup (polybar, dunst, screen-locker, GTK theme)
- **`packages.nix`**: Linux-specific packages
- **`secrets.nix`**: Age-encrypted secrets for Linux
- **`disk-config.nix`**: Disko disk partitioning (EFI + ext4 root)
- **`files.nix`**: Linux-specific configuration files
- **`config/`**: Desktop configuration (polybar, rofi, window manager)

**Desktop Environment**: BSPWM window manager + Polybar status bar + Picom compositor + LightDM display manager.

### Configuration Flow

Both Darwin and NixOS hosts follow this pattern:
1. Import platform-specific secrets module
2. Import shared module (which loads overlays and base config)
3. Import platform-specific modules
4. Import agenix module for secrets management

The shared configuration is the foundation, extended by platform-specific customization.

### Key Architectural Patterns

**Overlays Auto-Load**: Any `.nix` file in `overlays/` runs automatically during each build. Common uses include applying patches, version pinning, and temporary workarounds.

**Immutable Static Files**: Files managed through `files.nix` are immutable. To update them, modify `files.nix` and rebuild.

**Secrets Management**: Uses agenix with age encryption. Keys stored at:
- Identity: `~/.ssh/id_ed25519`
- Darwin: GitHub signing key at `~/.ssh/pgp_github.key`
- Public keys in `shared/files.nix`
- Private secrets repo: `git+ssh://git@github.com/dedeswim/nix-secrets.git`

**Token Replacement System**: The `apply` script uses tokens (`%USER%`, `%EMAIL%`, `%DISK%`, `%INTERFACE%`, etc.) for initial setup configuration.

**Platform-Specific Package Lists**: Each tier has its own `packages.nix`:
- Shared: Cross-platform tools and utilities
- Darwin: macOS-specific apps
- NixOS: Linux-specific tools and desktop apps

### Integration Points

- **home-manager**: User-level configuration management
- **agenix**: Age-encrypted secrets
- **nix-darwin**: macOS system configuration
- **nix-homebrew**: Declarative homebrew management for macOS (casks and Mac App Store apps)
- **disko**: Disk partitioning for NixOS installations
- **rust-overlay**: Rust toolchain management

## Important Conventions

### Working with Modules

- Most shared user configuration is in `modules/shared/home-manager.nix`
- System-level configuration is in `modules/{darwin,nixos}/default.nix`
- Host-specific settings go in `hosts/{darwin,nixos}/default.nix`

### Adding Packages

Add packages to the appropriate `packages.nix` file:
- Cross-platform packages: `modules/shared/packages.nix`
- macOS packages: `modules/darwin/packages.nix`
- Linux packages: `modules/nixos/packages.nix`
- Homebrew casks (macOS only): `modules/darwin/casks.nix`

### Adding Overlays

Create a new `.nix` file in `overlays/` - it will automatically load on the next build. No need to explicitly import it.

### Modifying Configuration Files

Static configuration files (dotfiles, configs) should be added to the appropriate `files.nix`:
- `modules/shared/files.nix` for cross-platform files
- `modules/darwin/files.nix` for macOS-only files
- `modules/nixos/files.nix` for Linux-only files

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
- `modules/nixos/README.md` - NixOS module structure
- `overlays/README.md` - Overlay documentation

## Configuration Details

**Primary User**: edoardo
- Shell: zsh with starship prompt, atuin, zoxide
- Editors: vim (extensive config), helix
- Version Control: Git with GPG signing, difftastic for diffs
- Terminal Multiplexer: tmux with custom configuration

**System Support**:
- Linux: x86_64-linux, aarch64-linux
- macOS: aarch64-darwin (Apple Silicon), x86_64-darwin (Intel)

**Nixpkgs Configuration**:
- Channel: nixos-unstable
- Unfree packages: Allowed
- Broken packages: Allowed
- Insecure packages: Not allowed
