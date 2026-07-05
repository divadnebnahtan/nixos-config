{ ... }:

{
  imports = [
    ./hardware-configuration.nix

    ../../modules/common/base.nix
    ../../modules/common/users.nix
    ../../modules/common/networking.nix
    ../../modules/common/firewall.nix

    ../../modules/services/ssh.nix
  ];

  networking.hostName = "nucthan";

  system.stateVersion = "26.05";
}
