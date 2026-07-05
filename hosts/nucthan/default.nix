{ ... }:

{
  imports = [
    ./hardware-configuration.nix

    ../../modules/common/base.nix
    ../../modules/common/users.nix
    ../../modules/common/networking.nix
    ../../modules/common/ssh.nix
    ../../modules/common/firewall.nix
  ];

  networking.hostName = "nucthan";

  system.stateVersion = "26.05";
}
