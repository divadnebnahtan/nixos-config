{ ... }:

{
  networking.networkmanager.enable = true;
  
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 2283 ];
    allowedUDPPorts = [ ];
  };
}
