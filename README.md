# Sonr NUR Packages

**[NUR](https://github.com/nix-community/NUR) repository for Sonr releases**

![Build and populate cache](https://github.com/sonr-io/nur/workflows/Build%20and%20populate%20cache/badge.svg)
[![Cachix Cache](https://img.shields.io/badge/cachix-sonr-blue.svg)](https://sonr.cachix.org)

This repository provides Nix packages for [Sonr](https://sonr.io) - a decentralized identity network.

## Quickstart with Devbox

The easiest way to get started is using [Devbox](https://www.jetify.com/devbox). Add packages to your project by referencing this repository as a Nix Flake:

```bash
# Add snrd (Sonr blockchain daemon)
devbox add github:sonr-io/nur#snrd

# Add hway (Highway network component)
devbox add github:sonr-io/nur#hway
```

Or add them directly to your `devbox.json`:

```json
{
  "packages": [
    "github:sonr-io/nur#snrd",
    "github:sonr-io/nur#hway"
  ]
}
```

Then start your Devbox shell:

```bash
devbox shell
```

## Packages

- **snrd**: Sonr blockchain daemon - decentralized identity network
- **hway**: Highway network component

## Installation

### Using with Nix Flakes

Add this to your `flake.nix`:

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nur.url = "github:nix-community/NUR";
  };

  outputs = { self, nixpkgs, nur }: {
    nixosConfigurations.yourhostname = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        {
          nixpkgs.overlays = [ nur.overlay ];
        }
        # Then use: environment.systemPackages = [ pkgs.nur.repos.sonr-io.snrd ];
      ];
    };
  };
}
```

### Using with Legacy Nix

Add the NUR to your `~/.config/nixpkgs/config.nix`:

```nix
{
  packageOverrides = pkgs: {
    nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
      inherit pkgs;
    };
  };
}
```

Then install packages:

```bash
nix-env -iA nur.repos.sonr-io.snrd
nix-env -iA nur.repos.sonr-io.hway
```

## Development

### Building packages locally

```bash
# Build a specific package
nix-build -A snrd

# Build with flakes
nix build .#snrd
```

### Testing

```bash
# Test evaluation
nix-env -f . -qa \* --meta --xml \
  --allowed-uris https://static.rust-lang.org \
  --option restrict-eval true \
  --option allow-import-from-derivation true \
  --drv-path --show-trace \
  -I nixpkgs=$(nix-instantiate --find-file nixpkgs) \
  -I $PWD
```

## License

Apache License 2.0

