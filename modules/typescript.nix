{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.tooling.typescript;
in {
  options.tooling.typescript = {
    enable = lib.mkEnableOption "TypeScript tooling via devenv languages.typescript + pnpm";

    packageManager = lib.mkOption {
      type = lib.types.enum ["pnpm" "npm" "yarn" "none"];
      default = "pnpm";
      description = "Which package manager to include.";
    };

    withESLint = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Include eslint.";
    };

    withPrettier = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Include prettier.";
    };

    nodePackage = lib.mkOption {
      type = lib.types.package;
      default = pkgs.nodejs_20;
      description = "Node.js package (default nodejs_20).";
    };
  };

  config = lib.mkIf cfg.enable {
    languages.typescript.enable = true;

    # Ensure you have a node + package manager available
    packages =
      [cfg.nodePackage]
      ++ (lib.optionals (cfg.packageManager == "pnpm") [pkgs.nodePackages.pnpm])
      ++ (lib.optionals (cfg.packageManager == "yarn") [pkgs.yarn])
      ++ (lib.optionals cfg.withESLint [pkgs.nodePackages.eslint])
      ++ (lib.optionals cfg.withPrettier [pkgs.nodePackages.prettier]);
  };
}
