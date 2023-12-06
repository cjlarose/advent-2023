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
          days = [ 1 6 ];
          solutionForDay = dayNumber:
            let dayString = builtins.toString dayNumber;
            in {
              name = "day${dayString}";
              value = import ./day${dayString}.nix { inherit pkgs; };
            };
        in builtins.listToAttrs (map solutionForDay days)
      );
    };
}
