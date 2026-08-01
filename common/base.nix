{ pkgs, ... }:

{
  time.timeZone = "Australia/Melbourne";

  i18n.defaultLocale = "en_AU.UTF-8";

  console.keyMap = "us";

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];

    auto-optimise-store = true;

    trusted-users = [
      "root"
      "@wheel"
    ];
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  environment.systemPackages = with pkgs; [
    git
    curl
    wget
    vim
    nano
    htop
    pciutils
    openssl
    nginx
  ];
  
  environment.shellAliases = {
    scripts-rebuild = "~/nixos-config/scripts/scripts-rebuild.sh";
    scripts-test = "~/nixos-config/scripts/scripts-test.sh";
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;
}
