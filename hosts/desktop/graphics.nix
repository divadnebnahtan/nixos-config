{ pkgs, ... }:
{
  services.xserver.enable = true;
  services.xserver.libinput.enable = true;
  services.xserver.xkb = {
    layout = "us,il";
    options = "grp:win_space_toggle";
  };

  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;

  services.desktopManager.plasma6.enable = true;

  services.packagekit.enable = false;

  services.libinput.enable = true;

  security.rtkit.enable = true;

  services.power-profiles-daemon.enable = true;



  # environment.plasma6.excludePackages = with pkgs.kdePackages; [
  #   discover
  # ];

  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
      liberation_ttf
      fira-code
      fira-code-symbols
      jetbrains-mono
    ];
  };
}
