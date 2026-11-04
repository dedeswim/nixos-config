# nix-darwin Configuration

A modern, flake-based [nix-darwin](https://github.com/nix-darwin/nix-darwin) configuration for Apple Silicon Macs.

## Features

- Shared + macOS module split
- Secrets management with agenix
- Declarative package management (including Homebrew on macOS)
- Reproducible builds via flakes

## Quick Start

### 1. Install Nix using Determinate Installer

```bash
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

Restart your terminal after installation.

### 2. Clone this repository

```bash
git clone https://github.com/dedeswim/nixos-config.git
cd nixos-config
```

### 3. Generate SSH keys (if needed)

```bash
nix run .#create-keys
```

Add the generated `~/.ssh/id_ed25519.pub` to your GitHub account.

### 4. Run initial setup

```bash
nix run .#apply
```

This will prompt for:
- Username
- Email and name (for git)
- GitHub username and secrets repository name

### 5. Build and switch

```bash
nix run .#build-switch
```

## Available Commands

| Command | Description |
|---------|-------------|
| `nix run .#apply` | Initial setup - configure user details |
| `nix run .#build` | Build without switching (test changes) |
| `nix run .#build-switch` | Build and activate configuration |
| `nix run .#rollback` | Rollback to a previous generation |
| `nix run .#create-keys` | Generate SSH keys |
| `nix run .#check-keys` | Verify SSH keys exist |
| `nix run .#copy-keys` | Copy keys from USB drive |

## Customization

### Adding Packages

Edit the appropriate `packages.nix`:

- **Shared**: `modules/shared/packages.nix`
- **macOS only**: `modules/darwin/packages.nix`
- **Homebrew casks**: `modules/darwin/casks.nix`

### Adding Programs/Dotfiles

Edit the appropriate `home-manager.nix`:

- **Shared**: `modules/shared/home-manager.nix`
- **macOS only**: `modules/darwin/home-manager.nix`

### Adding Overlays

Create a `.nix` file in `overlays/` - it will auto-load on the next build.

### Managing Secrets

Secrets are managed with [agenix](https://github.com/ryantm/agenix):

1. Ensure SSH keys exist: `nix run .#check-keys`
2. Add encrypted secrets to your private secrets repository
3. Reference them in the appropriate `secrets.nix`

## Repository Structure

```
.
├── flake.nix              # Flake definition and system configurations
├── apps/                  # CLI helper scripts
│   └── aarch64-darwin/
├── hosts/                 # Host-specific system configuration
│   └── darwin/
├── modules/
│   ├── shared/            # Base configuration (zsh, git, vim, tmux, …)
│   └── darwin/            # macOS-specific configuration
└── overlays/              # Custom package overlays (auto-loaded)
```

## Updating

```bash
# Update flake inputs
nix flake update

# Rebuild
nix run .#build-switch
```

## Troubleshooting

### "darwin-rebuild not found"

After the first `build-switch`, restart your terminal or run:
```bash
exec $SHELL
```

### Build fails with secrets error

Ensure your agenix identity key exists at `~/.ssh/id_ed25519` and has access to your secrets repository.

### Check system generations

```bash
darwin-rebuild --list-generations
```

## Credits

Based on [dustinlyons/nixos-config](https://github.com/dustinlyons/nixos-config).
