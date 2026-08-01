{ ... }:

{
  services.immich = {
    enable = true;

    host = "0.0.0.0";
    port = 2283;

    mediaLocation = "/srv/immich";

    machine-learning = {
      enable = true;
    };
  };

  systemd.tmpfiles.rules = [
    "d /srv/immich 0750 immich immich - -"
  ];
}
