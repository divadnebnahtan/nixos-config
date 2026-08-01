{ ... }:

let
  keyDir = ../data/ssh;

  keyFiles =
    builtins.map
      (name: keyDir + "/${name}")
      (builtins.filter
        (name:
          builtins.match ".*\\.pub" name != null
        )
        (builtins.attrNames (builtins.readDir keyDir)));
in
{
  users.users.nathan = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
    ];

    openssh.authorizedKeys.keyFiles = keyFiles;
  };

  security.sudo.wheelNeedsPassword = true;
}
