{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    curl
    wget
    btop
    pciutils
    openssl
    p7zip

    eza # ls alternative
    fd # find alternative
    file # identify a file's actual type
    bat # cat alternative
    ranger # terminal file manager

    ripgrep # rg; grep alternative
    sd #  sed alternative

    jq # json tools
    glow # terminal marldown render
    tealdeer # tldr; practical command examples
    youplot # terminal graphs and charts

    gh # github
    deadnix # find unused nix code

    nix-tree # nix store dependencies and disk usage
    nix-output-monitor # nom; improved nix build output

    psmisc # killall; fuser; pstree

    cowsay
    fortune
    nyancat
    asciiquarium
    tty-clock

    (writeShellApplication {
      name = "nix-config";
      runtimeInputs = [ bash coreutils inetutils git nix nixos-rebuild ];
      text = builtins.readFile ./scripts/nix-config.sh;
    })
  ];

  programs.fish.enable = true; # shell; alternative to Bash
  programs.starship.enable = true; # shell prompt
  programs.zoxide.enable = true; # smarter directory jumping; complements cd
  programs.atuin.enable = true; # searchable shell command history
}
