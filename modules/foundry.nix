{
  nixpkgs,
  foundry,
}: {
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.tooling.foundry;

  # Build a pkgs that includes the foundry overlay (like shazow's example)
  pkgsWithFoundry = import nixpkgs {
    inherit (pkgs) system;
    overlays = [foundry.overlay];
  };
in {
  options.tooling.foundry = {
    enable = lib.mkEnableOption "Foundry (forge/cast/anvil) from shazow/foundry.nix overlay";

    withSolc = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Also include solc.";
    };
  };

  config = lib.mkIf cfg.enable {
    packages =
      [pkgsWithFoundry.foundry-bin]
      ++ lib.optionals cfg.withSolc [pkgsWithFoundry.solc];
  };
}
