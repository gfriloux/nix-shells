{
  description = "nix-shells";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs2505.url = "github:NixOS/nixpkgs/nixos-25.05";
    ansible-recap = {
      url = "github:gfriloux/ansible-recap";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    snowfall-lib = {
      url = "github:snowfallorg/lib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    pre-commit-hooks.url = "github:cachix/pre-commit-hooks.nix";
  };

  outputs = inputs:
    inputs.snowfall-lib.mkFlake {
      inherit inputs;
      src = ./.;

      snowfall = {
        namespace = "nix-shells";

        meta = {
          name = "nix-shells";
          title = "nix-shells";
        };
      };
      templates = {
        ansible.description = "Basic tooling to work with ansible the way i want.";
        terraform.description = "Basic tooling to work with terraform the way i want.";
      };
    };
}
