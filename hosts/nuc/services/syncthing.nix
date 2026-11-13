{ lib, ... }:

let
  devices = import ../data/syncthing/devices.nix;
  folders = import ../data/syncthing/folders.nix;

  folderPaths = 
    lib.mapAttrsToList
      (_name: folder: folder.path)
      folders;

  syncthingPaths =
    builtins.filter
      (path: lib.hasPrefix "/srv/syncthing/" path)
      folderPaths;

  folderTmpfiles =
    map
      (path: "d ${path} 2770 syncthing syncthing - -")
      syncthingPaths;

  # Repair existing access and inherit shared access on new files/directories.
  # X grants traversal for directories without making ordinary files executable.
  folderACLs = map
    (path: "A+ ${path} - - - - u::rwX,u:syncthing:rwX,g:syncthing:rwX,m::rwX,d:u::rwx,d:u:syncthing:rwx,d:g::rwx,d:g:syncthing:rwx,d:m::rwx,d:o::---")
    syncthingPaths;
in
{

  services.syncthing = {
    enable = true;

    user = "syncthing";
    group = "syncthing";

    dataDir = "/srv/syncthing";
    configDir = "/var/lib/syncthing/.config";

    openDefaultPorts = true;

    overrideDevices = true;
    overrideFolders = true;

    guiAddress = "0.0.0.0:8384";

    settings = {
      devices = devices;
      folders = folders;
    };
  };

  # dataDir is also this account's home. Its default 0700 homeMode would
  # otherwise undo group access during NixOS user activation.
  users.users.syncthing.homeMode = "2770";

  systemd.tmpfiles.rules = [
    "d /srv/syncthing 2770 syncthing syncthing - -"
        
    "a+ /srv/media/music - - - - u:syncthing:rwx"
    "A+ /srv/media/music - - - - u:syncthing:rwx"
  ]
  ++ folderTmpfiles
  ++ folderACLs;
  
  systemd.services.syncthing.serviceConfig.UMask = "0007";
}
