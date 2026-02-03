{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.tooling.foundry;
in {
  options.tooling.foundry.enable =
    lib.mkEnableOption "Foundry tooling (forge/cast/anvil)";

  config = lib.mkIf cfg.enable {
    packages = [pkgs.foundry-bin];

    # optional niceties
    env.FOUNDRY_PROFILE = lib.mkDefault "default";

    # scripts are nice in devenv
    scripts.forge.exec = "forge --version";
    scripts.anvil.exec = "anvil --version";
    scripts.cast.exec = "cast --version";
  };
}
