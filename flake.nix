{
  description = "Advent of Code solutions 2023";

  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/release-23.11";
    };
  };

  outputs = { self, nixpkgs }:
    let
      supportedSystems = [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      nixpkgsFor = forAllSystems (system: import nixpkgs { inherit system; });
    in {
      packages = forAllSystems (system:
        let
          pkgs = nixpkgsFor.${system};
        in {
          day1 = import ./day1.nix { inherit pkgs; };
        });
    };
}
