{ ... }:

{
  imports = [
    ./hardware-configuration.nix

    ../../modules/common/base.nix
    ../../modules/common/users.nix
    ../../modules/common/networking.nix
    ../../modules/common/firewall.nix

    ../../modules/services/ssh.nix
    ../../modules/services/tailscale.nix
    ../../modules/services/syncthing.nix
    ../../modules/services/immich.nix
    ../../modules/services/traccar.nix
    ../../modules/services/nginx.nix
  ];

  networking.hostName = "nucthan";

  system.stateVersion = "26.05";
}
