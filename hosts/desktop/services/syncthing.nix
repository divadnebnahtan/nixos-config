{ ... }:
{
  services.syncthing = {
    enable = true;
    user = "nathan";
    dataDir = "/home/nathan";
    configDir = "/home/nathan/.local/state/syncthing";
    overrideDevices = false;
    overrideFolders = false;
  };
}
