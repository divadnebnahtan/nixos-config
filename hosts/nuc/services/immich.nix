{ lib, ... }:

{
  services.immich = {
    enable = true;
    user = "immich";
    group = "media";

    host = "0.0.0.0";
    port = 2283;

    mediaLocation = "/srv/immich";

    machine-learning = {
      enable = true;
    };
  };

  systemd.tmpfiles.rules = [
    "d /srv/immich 2770 immich media - -"
  ];

  networking.firewall.allowedTCPPorts = [ 2283 ];
  
  systemd.services.immich-server.serviceConfig.UMask = lib.mkForce "0007";
  systemd.services.immich-machine-learning.serviceConfig.UMask = lib.mkForce "0007";
}
