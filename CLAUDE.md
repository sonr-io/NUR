# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is the Sonr NUR (Nix User Repository) package repository for publishing releases from the [sonr-io/sonr](https://github.com/sonr-io/sonr) repository. It provides Nix packages for:

- **snrd**: Sonr blockchain daemon - decentralized identity network
- **hway**: Highway network component
- **motr**: Motor service component

NUR allows users to share custom Nix packages that aren't in the official nixpkgs repository.

## Architecture

The repository follows the standard NUR structure:

- **Entry Points**:
  - `default.nix`: Main entry point that exports all packages, lib functions, modules, and overlays
  - `flake.nix`: Flakes-based entry point for modern Nix workflows
  - `overlay.nix`: Allows using this repository as a nixpkgs overlay
  - `ci.nix`: Defines what gets built and cached by CI

- **Package Organization**:
  - `pkgs/`: Package definitions (each package in its own subdirectory with `default.nix`)
  - `lib/`: Custom library functions (exported as `lib` attribute)
  - `modules/`: NixOS modules (exported as `modules` attribute)
  - `overlays/`: Nixpkgs overlays (exported as `overlays` attribute)

- **Reserved Names**: `lib`, `modules`, and `overlays` are special attribute names and should not be used for packages

## Common Commands

### Building Packages

```bash
# Build a specific package
nix-build -A example-package

# Build using flakes
nix build .#example-package

# Build all cacheable packages (what CI builds)
nix-build ci.nix -A cacheOutputs
```

### Testing and Evaluation

```bash
# Check that all packages evaluate correctly
nix-env -f . -qa \* --meta --xml \
  --allowed-uris https://static.rust-lang.org \
  --option restrict-eval true \
  --option allow-import-from-derivation true \
  --drv-path --show-trace \
  -I nixpkgs=$(nix-instantiate --find-file nixpkgs) \
  -I $PWD

# List all available packages
nix-env -f . -qaP
```

### Using Flakes

```bash
# Show flake outputs
nix flake show

# Build with flakes
nix build .#<package-name>
```

## Adding New Packages

1. Create a new directory under `pkgs/` with the package name
2. Add a `default.nix` in that directory with the package definition
3. Add the package to `default.nix` in the root:
   ```nix
   my-package = pkgs.callPackage ./pkgs/my-package { };
   ```
4. Mark broken packages with `meta.broken = true;` to prevent CI failures

## CI/CD

- GitHub Actions builds packages on push, PR, and daily at 4:23 UTC
- Tests against multiple nixpkgs channels: nixpkgs-unstable, nixos-unstable, and nixos-25.05
- Only builds packages that are:
  - Not marked as `broken`
  - Have free licenses
  - Not marked with `preferLocalBuild`
- Configured with `nurRepo: sonr-io` and optional Cachix caching
- Optional: Cachix integration for binary caching (requires `CACHIX_AUTH_TOKEN` secret)

## GoReleaser Integration

This repository is designed to work with GoReleaser in the main sonr-io/sonr repository. GoReleaser can automatically:
- Generate Nix derivations for releases
- Create pull requests to update package versions
- Update the `pkgs/snrd/default.nix` file with new release information

The main repository should configure GoReleaser with Nix output targeting this repository.
