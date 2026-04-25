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
    lib = forEachSystem ({pkgs}: {
      inherit forEachSystem;
      mkShell = pkgs.mkShell.override {
        inherit (pkgs.llvmPackages_12) stdenv;
      };
    });
    packages = forEachSystem ({pkgs}: {
      ft_nvim = pkgs.callPackage ./nix/pkgs/ft_nvim.nix {inherit self;};
    });
    overlays = {
      default = final: _: {
        ft_nvim = self.packages.${final.system}.ft_nvim;
      };
    };
    devShells = forEachSystem ({pkgs}: {
      default = self.lib.${pkgs.system}.mkShell {
        packages = with pkgs; [
          norminette
        ];
      };
    });
  };
}
