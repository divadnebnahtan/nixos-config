{ lib, ... }:

{
  # 6767 = Bazarr
  # 7878 = Radarr
  # 8096 = Jellyfin
  # 8191 = Flaresolverr
  # 8282 = qBittorrent
  # 8989 = Sonarr
  # 9696 = Prowlarr

  systemd.tmpfiles.rules = [
    "d /srv/media/movies 2770 radarr media - -"
    "d /srv/media/tv 2770 sonarr media - -"

    "d /srv/.torrents/movies 2770 qbittorrent media - -"
    "d /srv/.torrents/tv 2770 qbittorrent media - -"

    "d /var/lib/jellyfin 0750 jellyfin media - -"
    "d /var/cache/jellyfin 0750 jellyfin media - -"
  ];

  systemd.services.qbittorrent.serviceConfig.UMask = lib.mkForce "0002";
  systemd.services.radarr.serviceConfig.UMask = lib.mkForce "0002";
  systemd.services.sonarr.serviceConfig.UMask = lib.mkForce "0002";
  systemd.services.bazarr.serviceConfig.UMask = lib.mkForce "0002";

  services.jellyfin = {
    enable = true;
    user = "jellyfin";
    group = "media";
  };

  services.radarr = {
    enable = true;
    user = "radarr";
    group = "media";
  };

  services.sonarr = {
    enable = true;
    user = "sonarr";
    group = "media";
  };

  services.prowlarr = {
    enable = true;
  };

  services.flaresolverr = {
    enable = true;
  };

  services.qbittorrent = {
    enable = true;
    user = "qbittorrent";
    group = "media";
    webuiPort = 8282;
    serverConfig = {
      LegalNotice.Accepted = true;
      BitTorrent = {
        Session.BTProtocol = "TCP";

        Session.Preallocation = true;

        Session.DisableAutoTMMByDefault = false;
        Session.DisableAutoTMMTriggers.TorrentCategoryChanged = false;
        Session.DisableAutoTMMTriggers.DefaultSavePathChanged = false;
        Session.DisableAutoTMMTriggers.CategorySavePathChanged = false;

        Session.AddTrackersEnabled = false;
        Session.AnonymousModeEnabled = false;
        Session.Encryption = 0;

        Session.GlobalMaxInactiveSeedingMinutes = -1;
        Session.GlobalMaxRatio = -1;
        Session.GlobalMaxSeedingMinutes = -1;

        Session.IgnoreLimitsOnLAN = false;
        Session.IncludeOverheadInLimits = false;
        Session.uTPRateLimited = true;

        ExcludedFileNamesEnabled = true;
        Session.ExcludedFileNames = "*.rar\n*.r[0-9]*";

        Session.QueueingSystemEnabled = false;
      };

      Core.AutoDeleteAddedTorrentFile = "Always";

      Preferences = {
        General.Locale = "en";

        Downloads = {
          SavePath = "/srv/.torrents";
          TempPathEnabled = false;
          ContentLayout = "Original";
        };
        Connection = {
          RandomPort = false;
          UPnP = false;
        };
        WebUI = {
          Username = "nathan";
          Password_PBKDF2 = "@ByteArray(SBkFs9vLR2Tr288QQCd2jA==:tvFr2RgkQl+KVLudSEWdqAU44UtELlNDjh2AslE9TBiNkhv/ong3nsxcuQ1CR4PV7zWGvaU28+sv60LmGwec9w==)";
          ClickjackingProtection = false;

          LocalHostAuth = false;
          AuthSubnetWhitelistEnabled = true;
          AuthSubnetWhitelist = "192.168.1.0/24,100.64.0.0/24";
        };
      };

    };
  };

  services.bazarr = {
    enable = true;
    user = "bazarr";
    group = "media";
  };
}
