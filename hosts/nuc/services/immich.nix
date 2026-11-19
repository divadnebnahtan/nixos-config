{ lib, inputs, unstable, ... }:

{
  disabledModules = [
    "services/web-apps/immich.nix"
  ];

  imports = [
    "${inputs.nixpkgs-unstable}/nixos/modules/services/web-apps/immich.nix"
  ];

  services.immich = {
    enable = true;
    package = unstable.immich;

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
