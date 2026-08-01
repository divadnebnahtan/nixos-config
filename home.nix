{ ... }:

{
  home.username = "nathan";
  home.homeDirectory = "/home/nathan";

  programs.git = {
    enable = true;

    settings = {
      user = {
        name = "divadnebnahtan";
        email = "davidbennathan@gmail.com";
      };

      init.defaultBranch = "main";
    };
  };

  home.stateVersion = "26.05";
}
