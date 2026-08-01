{ ... }:

let
  secretDir = "/var/lib/nixflix/secrets";
in
{
  systemd.tmpfiles.rules = [
    "d ${secretDir} 0700 root root -"

    "d /data/media 0775 root media -"
    "d /data/media/movies 0775 root media -"
    "d /data/media/tv 0775 root media -"
    "d /data/downloads/torrent 0775 root media -"
    "d /data/.state 0775 root media -"
  ];

  systemd.services.seerr-setup.environment = {
    JELLYFIN_URL = "http://127.0.0.1:8096";
  };

  nixflix = {
    enable = true;
    mediaDir = "/data/media";
    stateDir = "/data/.state";
    mediaUsers = [ "nathan" ];

    nginx.enable = false;
    caddy.enable = false;
    postgres.enable = true;

    sonarr = {
      enable = true;
      config = {
        apiKey._secret = "${secretDir}/sonarr-api-key";
        hostConfig = {
          username = "nathan";
          password._secret = "${secretDir}/password";
        };
      };
    };

    radarr = {
      enable = true;
      config = {
        apiKey._secret = "${secretDir}/radarr-api-key";
        hostConfig = {
          username = "nathan";
          password._secret = "${secretDir}/password";
        };
      };
    };

    prowlarr = {
      enable = true;
      config = {
        apiKey._secret = "${secretDir}/prowlarr-api-key";
        hostConfig = {
          username = "nathan";
          password._secret = "${secretDir}/password";
        };
        indexers = [];
      };
    };

    jellyfin = {
      enable = true;
      apiKey._secret = "${secretDir}/jellyfin-api-key";

      users.nathan = {
        mutable = false;
        policy.isAdministrator = true;
        password._secret = "${secretDir}/password";
      };
    };

    seerr = {
      enable = true;
      port = 6010;
      apiKey._secret = "${secretDir}/seerr-api-key";

      jellyfin = {
        adminUsername = "nathan";
        adminPassword._secret = "${secretDir}/password";
        hostname = "127.0.0.1";
        port = 8096;
        useSsl = false;
        urlBase = "";
        serverType = 2;
      };
    };

    torrentClients.qbittorrent = {
      enable = true;
      webuiPort = 8282;

      # Used by Sonarr/Radarr/Prowlarr to log into qBittorrent
      password._secret = "${secretDir}/password";

      serverConfig = {
        Preferences.WebUI = {
          Username = "nathan";

          # Replace this with the hash generated below
          Password_PBKDF2 = "@ByteArray(HGdnTl/BjLc3kp7TTfTu0g==:M0bIe8T/kMd3uN89R4gzmBtEJns8xQ/9BBvNx8Q3Wsjo/b8vVAEia7j3D9AC+qwlfJSFj48Fr0w1OjoH13Xzyw==)";
        };
      };
    };

    recyclarr = {
      enable = true;
      cleanupUnmanagedProfiles.enable = true;
    };

    flaresolverr.enable = true;
  };

  networking.firewall.allowedTCPPorts = [
    6010 # Seerr
    7878 # Radarr
    8096 # Jellyfin
    8282 # qBittorrent
    8989 # Sonarr
    9696 # Prowlarr
  ];
}
