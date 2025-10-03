{
  description = "Sonr NUR repository - Nix packages for Sonr blockchain daemon and network components";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  outputs = { self, nixpkgs }:
    let
      forAllSystems = nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed;
    in
    {
      packages = forAllSystems (system:
        let
          pkgs = import nixpkgs { inherit system; };
          allPackages = import ./default.nix { inherit pkgs; };
        in
        nixpkgs.lib.filterAttrs (_: v: nixpkgs.lib.isDerivation v) allPackages
      );
    };
}
