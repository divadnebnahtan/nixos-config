{ ... }:
{
  imports = [
    ./ssh.nix
    ./tailscale.nix
    ./syncthing.nix
    ./immich.nix
    ./flix.nix
    ./tify.nix
    ./traccar.nix
  ];
}
