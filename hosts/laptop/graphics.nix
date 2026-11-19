
{ pkgs, ... }:
{
  # ─────────────────────────────────────
  # Shared: Input and display manager
  # ─────────────────────────────────────

  services.xserver.enable = true;
  services.xserver.libinput.enable = true;

  services.xserver.xkb = {
    layout = "us,il";
    options = "grp:win_space_toggle";
  };

  services.libinput.enable = true;

  services.displayManager.sddm = {
    enable = false;
#     wayland.enable = true;
  };
  services.displayManager.plasma-login-manager.enable = true;

  # ─────────────────────────────────────
  # KDE Plasma 6
  # ─────────────────────────────────────

  services.desktopManager.plasma6.enable = true;

  # ─────────────────────────────────────
  # Shared: Wayland portals
  # ─────────────────────────────────────

  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
    ];
  };

  # ─────────────────────────────────────
  # Shared: Laptop services
  # ─────────────────────────────────────

  services.packagekit.enable = false;
  security.rtkit.enable = true;
  services.power-profiles-daemon.enable = true;
  services.upower.enable = true;

  # ─────────────────────────────────────
  # Shared: Fonts
  # ─────────────────────────────────────

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
