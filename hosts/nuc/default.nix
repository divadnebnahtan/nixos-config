{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./services
  ];

  networking = {
    hostName = "NathanNUC";
    nameservers = [ "1.1.1.1" ];
  };

  users.groups.media = {};
  users.users.nathan.extraGroups = [ "media" "syncthing" ];

  # environment.systemPackages = with pkgs; [
    # git
    # speedtest-cli
    # tree
    # gdu
    # bluez
    # ffmpeg
  # ];

  security.sudo.wheelNeedsPassword = true;

  environment.shellAliases.scripts-rebuild = "/home/nathan/nixos-config/scripts/scripts-rebuild.sh";
}
