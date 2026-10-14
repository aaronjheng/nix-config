{ ... }:

{
  networking.computerName = "Aarons Work";
  networking.hostName = "aarons-work";
  networking.localHostName = "aarons-work";

  power.preventAutomaticSleepingOnPowerAdapter = true;
  power.wakeForNetworkAccess = "onPowerAdapter";
}
