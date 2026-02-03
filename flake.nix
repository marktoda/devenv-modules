{
  description = "Reusable devenv modules";

  inputs = {
    # devenv's recommended nixpkgs pin (fast + consistent)
    nixpkgs.url = "github:cachix/devenv-nixpkgs";

    # Pin foundry here once.
    foundry = {
      url = "github:shazow/foundry.nix/stable";
      # If foundry.nix expects nixpkgs, you can optionally align it:
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    foundry,
    ...
  }: {
    # These are devenv modules you can import in any devenv shell.
    devenvModules = {
      foundry = import ./modules/foundry.nix {inherit nixpkgs foundry;};
      rust = import ./modules/rust.nix;
      typescript = import ./modules/typescript.nix;

      # convenience module: all of the above
      full = {...}: {
        imports = [
          self.devenvModules.foundry
          self.devenvModules.rust
          self.devenvModules.typescript
        ];
      };
    };
  };
}
