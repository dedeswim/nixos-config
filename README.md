# NixOS & nix-darwin Configuration

A modern, flake-based Nix configuration supporting both **NixOS** (Linux) and **nix-darwin** (macOS).

## Features

- Three-tier module hierarchy for maximum code reuse
- Secrets management with agenix
- Declarative package management (including Homebrew on macOS)
- Reproducible builds via flakes

## Quick Start

### macOS (Apple Silicon or Intel)

#### 1. Install Nix using Determinate Installer

```bash
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

Restart your terminal after installation.

#### 2. Clone this repository

```bash
git clone https://github.com/dedeswim/nixos-config.git
cd nixos-config
```

#### 3. Generate SSH keys (if needed)

```bash
nix run .#create-keys
```

Add the generated `~/.ssh/id_ed25519.pub` to your GitHub account.

#### 4. Run initial setup

```bash
nix run .#apply
```

This will prompt for:
- Username
- Email and name (for git)
- GitHub username and secrets repository name

#### 5. Build and switch

```bash
nix run .#build-switch
```

### NixOS (Fresh Install)

Boot from the NixOS installer ISO, then:

#### Option A: Automated installation

```bash
# Download and run the installer
curl -LJ0 https://github.com/dedeswim/nixos-config/archive/main.zip -o nixos-config.zip
unzip nixos-config.zip
cd nixos-config-main

# Generate SSH keys first
nix run --extra-experimental-features "nix-command flakes" .#create-keys

# Add the key to GitHub, then run install
nix run --extra-experimental-features "nix-command flakes" .#install
```

#### Option B: Automated installation with secrets

If you have existing agenix keys on a USB drive:

```bash
# Copy keys from USB
nix run --extra-experimental-features "nix-command flakes" .#copy-keys

# Run install with secrets support
nix run --extra-experimental-features "nix-command flakes" .#install-with-secrets
```

#### Option C: Manual installation

```bash
# Clone and configure
git clone https://github.com/dedeswim/nixos-config.git
cd nixos-config
nix run .#apply

# Partition disk with disko
sudo nix run github:nix-community/disko -- --mode zap_create_mount ./modules/nixos/disk-config.nix

# Copy config to target
sudo mkdir -p /mnt/etc/nixos
sudo cp -r * /mnt/etc/nixos
cd /mnt/etc/nixos

# Install
sudo nixos-install --flake .#x86_64-linux  # or .#aarch64-linux
```

### NixOS (Existing Install)

```bash
git clone https://github.com/dedeswim/nixos-config.git
cd nixos-config
nix run .#apply
nix run .#build-switch
```

## Available Commands

### macOS

| Command | Description |
|---------|-------------|
| `nix run .#apply` | Initial setup - configure user details |
| `nix run .#build` | Build without switching (test changes) |
| `nix run .#build-switch` | Build and activate configuration |
| `nix run .#rollback` | Rollback to a previous generation |
| `nix run .#create-keys` | Generate SSH keys |
| `nix run .#check-keys` | Verify SSH keys exist |
| `nix run .#copy-keys` | Copy keys from USB drive |

### NixOS

| Command | Description |
|---------|-------------|
| `nix run .#apply` | Initial setup - configure user details |
| `nix run .#build-switch` | Build and switch to new configuration |
| `nix run .#create-keys` | Generate SSH keys |
| `nix run .#check-keys` | Verify SSH keys exist |
| `nix run .#copy-keys` | Copy keys from USB drive |
| `nix run .#install` | Automated NixOS installation |
| `nix run .#install-with-secrets` | Installation with agenix secrets |

## Customization

### Adding Packages

Edit the appropriate `packages.nix`:

- **Cross-platform**: `modules/shared/packages.nix`
- **macOS only**: `modules/darwin/packages.nix`
- **Linux only**: `modules/nixos/packages.nix`
- **Homebrew casks**: `modules/darwin/casks.nix`

### Adding Programs/Dotfiles

Edit the appropriate `home-manager.nix`:

- **Cross-platform**: `modules/shared/home-manager.nix`
- **macOS only**: `modules/darwin/home-manager.nix`
- **Linux only**: `modules/nixos/home-manager.nix`

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
│   ├── aarch64-darwin/
│   ├── x86_64-darwin/
│   ├── aarch64-linux/
│   └── x86_64-linux/
├── hosts/                 # Host-specific system configuration
│   ├── darwin/
│   └── nixos/
├── modules/
│   ├── shared/            # Cross-platform configuration
│   ├── darwin/            # macOS-specific configuration
│   └── nixos/             # Linux-specific configuration
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

### macOS: "darwin-rebuild not found"

After the first `build-switch`, restart your terminal or run:
```bash
exec $SHELL
```

### NixOS: Build fails with secrets error

Ensure your agenix identity key exists at `~/.ssh/id_ed25519` and has access to your secrets repository.

### Check system generations

**macOS:**
```bash
darwin-rebuild --list-generations
```

**NixOS:**
```bash
nixos-rebuild --list-generations
```

## Credits

Based on [dustinlyons/nixos-config](https://github.com/dustinlyons/nixos-config).
