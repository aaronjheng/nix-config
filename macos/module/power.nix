{ config, lib, ... }:

let
  cfg = config.power;
in
{
  options.power = {
    preventAutomaticSleepingOnPowerAdapter = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        System Settings → Battery → Options: "Prevent automatic sleeping on power
        adapter when the display is off".

        Applied on every activation, so leaving it unset turns the toggle off again.
      '';
    };

    wakeForNetworkAccess = lib.mkOption {
      type = lib.types.enum [
        "never"
        "always"
        "onPowerAdapter"
      ];
      default = "never";
      description = ''
        System Settings → Battery → Options: "Wake for network access"
        ("Never", "Always" or "Only on Power Adapter").

        Applied on every activation, so leaving it unset sets it back to "Never".
      '';
    };
  };

  # The sleep toggle maps to the AC power `sleep` value: 0 when on, 1 when off.
  # Wake for network access maps to `womp` (AC / battery): Never 0 / 0,
  # Always 1 / 1, Only on Power Adapter 1 / 0.
  config.system.activationScripts.postActivation.text = ''
    pmset -c sleep ${if cfg.preventAutomaticSleepingOnPowerAdapter then "0" else "1"}
    pmset -c womp ${if cfg.wakeForNetworkAccess == "never" then "0" else "1"}
    pmset -b womp ${if cfg.wakeForNetworkAccess == "always" then "1" else "0"}
  '';
}
