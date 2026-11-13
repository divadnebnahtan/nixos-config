{ config, lib, pkgs, ... }:

let
  pythonEnv = pkgs.python3.withPackages (ps: with ps; [
    flask
    requests
  ]);
  
  nowPlaying = pkgs.writeText "now-playing.py" ''
    from flask import Flask, jsonify
    import requests
    import hashlib
    import secrets
    import os

    app = Flask(__name__)

    NAVIDROME = "http://127.0.0.1:4533"
    USERNAME = os.environ["NAVIDROME_USER"]
    PASSWORD = os.environ["NAVIDROME_PASSWORD"]

    def auth():
        salt = secrets.token_hex(6)
        token = hashlib.md5(
            (PASSWORD + salt).encode()
        ).hexdigest()

        return {
            "u": USERNAME,
            "t": token,
            "s": salt,
            "v": "1.16.1",
            "c": "public-now-playing",
            "f": "json",
        }

    @app.get("/api/now-playing")
    def now_playing():
        r = requests.get(
            f"{NAVIDROME}/rest/getNowPlaying",
            params=auth(),
            timeout=5,
        )
        r.raise_for_status()

        entries = (
            r.json()["subsonic-response"]
            .get("nowPlaying", {})
            .get("entry", [])
        )

        if not entries:
            return jsonify({"playing": False})

        song = entries[0]

        return jsonify({
            "playing": True,
            "title": song.get("title"),
            "artist": song.get("artist"),
            "album": song.get("album"),
            "coverArt": song.get("coverArt"),
            "duration": song.get("duration"),
        })

    app.run(host="127.0.0.1", port=8081)
  '';
in
{
  # 4533 = Navidrome
  
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
  
  systemd.services.now-playing = {
    description = "Navidrome Now Playing API";
    wantedBy = [ "multi-user.target" ];
    after = [ "navidrome.service" ];

    environment.NAVIDROME_USER = "nathan";

    serviceConfig = {
      EnvironmentFile = "/var/lib/secrets/now-playing.env";
      ExecStart = "${pythonEnv}/bin/python ${nowPlaying}";

      Restart = "on-failure";
      RestartSec = 5;

      DynamicUser = true;
      NoNewPrivileges = true;
      PrivateTmp = true;
      ProtectSystem = "strict";
      ProtectHome = true;
    };
  };
}
