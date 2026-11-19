{ config, lib, pkgs, ... }:

{

  systemd.tmpfiles.rules = [
    "d /srv/media/music 2770 root media - -"
  ];

  services.navidrome = {
    enable = true;
    user = "navidrome";
    group = "media";

    environmentFile = "/var/lib/secrets/navidrome.env";

    settings = {
      Address = "0.0.0.0";

      MusicFolder = "/srv/media/music";
      DataFolder = "/var/lib/navidrome";
      CacheFolder = "/var/cache/navidrome";

      EnableInsightsCollector = false;
      EnableWebPEncoding = true;

      LastFM.Enabled = true;

      ListenBrainz = {
        Enabled = true;
        BaseURL = "https://api.listenbrainz.org/1/";
      };
    };
  };
}
