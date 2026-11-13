{
  suncthan = {
    id = "suncthan";
    label = "Sync";
    path = "/srv/syncthing/Sync";
    devices = [ "pc" "laptop" "iphone" "pixel" ];
    ignorePerms = true;
  };

  obssync = {
    id = "obssync";
    label = "Obsidian";
    path = "/srv/syncthing/Obsidian";
    devices = [ "pc" "laptop" "iphone" "pixel" ];
    ignorePerms = true;
  };
  
  musicsync = {
    id = "musicsync";
    label = "Music";
    path = "/srv/media/music";
    devices = [ "pc" "laptop" "iphone" "pixel" ];
    ignorePerms = true;
  };
}
