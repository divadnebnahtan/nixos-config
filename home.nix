{ ... }:

{
  imports = [
    ./services/git.nix
  ];

  home.username = "nathan";
  home.homeDirectory = "/home/nathan";

  home.stateVersion = "26.05";
}
