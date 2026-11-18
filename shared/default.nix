{ lib, pkgs, ... }:
{
  imports = [
    ./packages.nix
  ];

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true;
  };

  nixpkgs.config.allowUnfree = true;

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  boot.loader.systemd-boot = {
    enable = true;
    configurationLimit = 3;
  };
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  hardware.enableAllFirmware = true;

  networking.networkmanager.enable = true;
  networking.firewall.enable = true;

  time.timeZone = "Australia/Melbourne";
  i18n.defaultLocale = "en_AU.UTF-8";
  console.keyMap = "us";

  users.users.nathan = {
    isNormalUser = true;
    description = "Nathan";
    extraGroups = [ "wheel" "networkmanager" ];
    shell = pkgs.fish;
  };

  security.sudo.extraConfig = ''
    Defaults rootpw
  '';

  documentation.man.cache.enable = false;

  programs.git = {
    enable = true;
    config = {
      user.name = "Nathan Ben-David";
      user.email = "davidbennathan@gmail.com";
      init.defaultBranch = "main";
      pull.rebase = true;
    };
  };
}
