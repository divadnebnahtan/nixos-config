{ pkgs, inputs, unstable, ... }:

{
  # todo: qbittorrent, flameshot, localsend, cava, paprefs,
  #
  # pc: steamtinkerlaunch, bottles, mangohud, gamemode, protonup-qt, protonup-ng (proton-ge), winetricks, gamescope, amdgpu_top
  environment.systemPackages = with pkgs; [
    # inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
    # feishin
    # vlc
    # obsidian
    # anki
    zed-editor
    ghostty
    # nicotine-plus

    # unstable.signal-desktop
    # unstable.t3code

    # syncthingtray
    # tail-tray
  ];

  programs.nix-ld.enable = true;
  # programs.steam.enable = true;
  # programs.obs-studio.enable = true;
  # programs.zoom-us.enable = true;
}
