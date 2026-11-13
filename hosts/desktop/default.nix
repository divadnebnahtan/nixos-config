{ ... }:
{
  imports = [ ./hardware-configuration.nix ];
  networking.hostName = "NathanDesktop";
  system.stateVersion = "26.05";
  # Add configuration once the desktop hardware and installation are planned.
}
