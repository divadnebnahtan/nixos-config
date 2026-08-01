{ ... }:

{
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
}
