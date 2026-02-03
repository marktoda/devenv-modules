{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.tooling.rust;
in {
  options.tooling.rust = {
    enable = lib.mkEnableOption "Rust toolchain via devenv languages.rust + common extras";

    withAnalyzer = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Include rust-analyzer (recommended).";
    };

    withCommonNativeDeps = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Add pkg-config + openssl for crates that need native deps.";
    };
  };

  config = lib.mkIf cfg.enable {
    # devenv's rust integration (keeps things consistent)
    languages.rust.enable = true;

    # rust-analyzer is often useful even if languages.rust is enabled
    packages =
      (lib.optionals cfg.withAnalyzer [pkgs.rust-analyzer])
      ++ (lib.optionals cfg.withCommonNativeDeps [pkgs.pkg-config pkgs.openssl]);
  };
}
