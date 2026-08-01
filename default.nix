{ ... }:

{
  imports = [
    ./hardware-configuration.nix

    ./common/base.nix
    ./common/users.nix
    ./common/networking.nix

    ./services/ssh.nix
    ./services/tailscale.nix
    ./services/syncthing.nix
    ./services/immich.nix
  ];

  networking.hostName = "nucthan";

  system.stateVersion = "26.05";
}
