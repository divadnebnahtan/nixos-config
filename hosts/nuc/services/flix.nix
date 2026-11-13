{ config, lib, pkgs, ... }:

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
  
  # Keep the password hash out of Git and the world-readable Nix store.
  # The credential file contains the existing @ByteArray(...) value, one line.
  systemd.services.qbittorrent.serviceConfig = {
    UMask = lib.mkForce "0002";
    LoadCredential = [ "webui-password:/var/lib/secrets/qbittorrent-password" ];
    ExecStartPre = lib.mkAfter [ (pkgs.writeShellScript "qbittorrent-password" ''
      set -euo pipefail
      password=$(${pkgs.coreutils}/bin/cat "$CREDENTIALS_DIRECTORY/webui-password")
      test -n "$password"
      ${pkgs.crudini}/bin/crudini --set \
        ${lib.escapeShellArg "${config.services.qbittorrent.profileDir}/qBittorrent/config/qBittorrent.conf"} \
        Preferences 'WebUI\Password_PBKDF2' \
        "$password"
    '') ];
  };
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

  
  services.recyclarr = {
    enable = true;
    user = "recyclarr";
    group = "media";
    
    schedule = "daily";
    command = "sync";

    configuration = {
      radarr.movies = {
        base_url = "http://127.0.0.1:7878";

        api_key = {
          _secret = "/var/lib/secrets/radarr-api-key";
        };

        delete_old_custom_formats = true;

        # Import TRaSH's movie size definitions, but put the preferred
        # point nearer the smaller end of the accepted range.
        quality_definition = {
          type = "movie";
          preferred_ratio = 0.25;
        };

        quality_profiles = [
          {
            # TRaSH: HD Bluray + WEB
            trash_id = "d1d67249d3890e49bc12e275d989a7e9";

            # Your name for the profile in Radarr.
            name = "Manual 1080p Preferred";

            # Recyclarr owns the CF scores in this profile.
            reset_unmatched_scores.enabled = true;

            # You manually choose releases, so don't perform upgrades.
            upgrade.allowed = false;

            # Don't reject releases just because their CF score is low.
            # Interactive Search can therefore show questionable results
            # with rejection explanations, and you make the final choice.
            min_format_score = 0;

            # Ordered from most preferred to least preferred.
            #
            # Items inside one group are equal as Radarr qualities.
            # Custom Format score then distinguishes source/group/codec.
            qualities = [
              {
                name = "1080p";
                qualities = [
                  "Bluray-1080p"
                  "WEBDL-1080p"
                  "WEBRip-1080p"
                  "HDTV-1080p"
                ];
              }

              {
                name = "2160p";
                qualities = [
                  "Bluray-2160p"
                  "WEBDL-2160p"
                  "WEBRip-2160p"
                  "HDTV-2160p"
                ];
              }

              {
                name = "720p";
                qualities = [
                  "Bluray-720p"
                  "WEBDL-720p"
                  "WEBRip-720p"
                  "HDTV-720p"
                ];
              }
            ];
          }
        ];

        custom_formats = [
          {
            trash_ids = [
              # Radarr: x265 (HD)
              "dc98083864ea246d05a42df0d05f81cc"
            ];

            assign_scores_to = [
              {
                name = "Manual 1080p Preferred";

                # A modest preference, not an overwhelming one.
                # Release-group quality can still outweigh the codec.
                score = 100;
              }
            ];
          }
        ];
      };

      sonarr.tv = {
        base_url = "http://127.0.0.1:8989";

        api_key = {
          _secret = "/var/lib/secrets/sonarr-api-key";
        };

        delete_old_custom_formats = true;

        quality_definition = {
          type = "series";
          preferred_ratio = 0.25;
        };
        
        quality_profiles = [
          {
            # TRaSH: WEB-1080p
            trash_id = "72dae194fc92bf828f32cde7744e51a1";

            name = "Manual 1080p Preferred";

            reset_unmatched_scores.enabled = true;
            upgrade.allowed = false;
            min_format_score = 0;

            qualities = [
              {
                name = "1080p";
                qualities = [
                  "Bluray-1080p"
                  "WEBDL-1080p"
                  "WEBRip-1080p"
                  "HDTV-1080p"
                ];
              }

              {
                name = "2160p";
                qualities = [
                  "Bluray-2160p"
                  "WEBDL-2160p"
                  "WEBRip-2160p"
                  "HDTV-2160p"
                ];
              }

              {
                name = "720p";
                qualities = [
                  "Bluray-720p"
                  "WEBDL-720p"
                  "WEBRip-720p"
                  "HDTV-720p"
                ];
              }
            ];
          }
        ];
        
        custom_formats = [
          {
            trash_ids = [
              # Sonarr: x265 (HD)
              "47435ece6b99a0b477caf360e79ba0bb"
            ];

            assign_scores_to = [
              {
                name = "Manual 1080p Preferred";
                score = 100;
              }
            ];
          }
        ];
      };
    };
  };
  
  systemd.services.recyclarr = {
    after = [
      "radarr.service"
      "sonarr.service"
      "network-online.target"
    ];

    wants = [
      "network-online.target"
    ];
  };
}
