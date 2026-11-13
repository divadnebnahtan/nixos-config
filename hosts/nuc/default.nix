{ pkgs, ... }:
{
  imports = [ ./hardware-configuration.nix ./packages.nix ./services ];
  networking.hostName = "NathanNuc";
  system.stateVersion = "26.05";
  boot.kernelPackages = pkgs.linuxPackages_latest;
  networking.nameservers = [ "1.1.1.1" ];
  hardware.bluetooth = { enable = true; powerOnBoot = false; };
  users.groups.media = {};
  users.users.nathan.extraGroups = [ "media" "syncthing" ];
  security.sudo.wheelNeedsPassword = true;
}
