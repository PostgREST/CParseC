{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/e6f23dc08d3624daab7094b701aa3954923c6bbb";
    filnix.url = "github:mbrock/filnix";
  };

  nixConfig = {
    extra-substituters = [ "https://filc.cachix.org" ];
    extra-trusted-public-keys = [ "filc.cachix.org-1:8rA7kXyu1HaJuMTsAKfA9fU/+r8YtLv5KiZ5hfDNZMk=" ];
  };

  outputs = { self, nixpkgs, filnix }:
    let
      systems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in {
      devShells = forAllSystems (system: {
        default = import ./shell.nix {
          pkgs = nixpkgs.legacyPackages.${system};
          filcc = if system == "x86_64-linux" then filnix.packages.${system}.filcc else null;
        };
      });
    };
}
