{ lib, ... }:

let
  devices = import ../data/syncthing/devices.nix;
  folders = import ../data/syncthing/folders.nix;

  folderPaths = 
    lib.mapAttrsToList
      (_name: folder: folder.path)
      folders;

  folderTmpfiles =
    map
      (path: "d ${path} 0750 nathan users - -")
      folderPaths;
in
{
  services.syncthing = {
    enable = true;

    user = "nathan";
    group = "users";

    dataDir = "/srv/syncthing";
    configDir = "/home/nathan/.config/syncthing";

    openDefaultPorts = true;

    overrideDevices = true;
    overrideFolders = true;

    settings = {
      gui = {
        address = "127.0.0.1:8384";
      };

      devices = devices;

      folders = folders;
    };
  };

  systemd.tmpfiles.rules = [
    "d /srv/syncthing 0750 nathan users - -"
  ]
  ++ folderTmpfiles;
}
