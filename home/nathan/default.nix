{ ... }:

{
  home.username = "nathan";
  home.homeDirectory = "/home/nathan";

  programs.git = {
    enable = true;

    settings = {
      user = {
        name = "Nathan";
        email = "your-email@example.com";
      };

      init.defaultBranch = "main";
    };
  };

  home.stateVersion = "26.05";
}
