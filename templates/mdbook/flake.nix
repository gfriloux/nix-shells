{
  description = "terraform module";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nix-checks = {
      url = "github:gfriloux/nix-checks";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-shells = {
      url = "github:gfriloux/nix-shells";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    utils = {
      url = "github:numtide/flake-utils";
    };
  };

  outputs = {
    utils,
    nix-checks,
    nix-shells,
    ...
  }:
    utils.lib.eachDefaultSystem (
      system: let
        inherit (nix-checks.lib.${system}) checks;
      in {
        checks = {
          nix = checks.nix ./.;
          markdown = checks.markdown {
            path = ./.;
            args = "-d MD013,MD057,MD025";
          };
          gitleaks = checks.gitleaks ./.;
        };
        devShells.default = nix-shells.devShells.${system}.mdbook;
      }
    );
}
