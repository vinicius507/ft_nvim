{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = {
    self,
    nixpkgs,
  }: let
    allSystems = ["x86_64-linux" "aarch64-linux"];
    forEachSystem = f:
      nixpkgs.lib.genAttrs allSystems (system:
        f {
          pkgs = import nixpkgs {
            inherit system;
            overlays = builtins.attrValues self.overlays;
          };
        });
  in {
    packages = forEachSystem ({pkgs}: {
      ft_nvim = pkgs.callPackage ./nix/pkgs/ft_nvim.nix {inherit self;};
    });
    overlays = {
      default = final: _: {
        inherit (self.packages.${final.stdenv.hostPlatform.system}) ft_nvim;
      };
    };
    devShells = forEachSystem ({pkgs}: {
      default = pkgs.mkShell {
        packages = with pkgs; [
          norminette
        ];
      };
    });
  };
}
