{ pkgs, ... }:
{
  services.tailscale = {
    enable = true;
    openFirewall = true;
  };

  services.resolved.enable = true;
  networking.networkmanager.dns = "systemd-resolved";

  networking.nftables.enable = true;

#   networking.firewall = {
#     trustedInterfaces = [ config.services.tailscale.interfaceName ];
#     allowedUDPPorts = [ config.services.tailscale.port ];
#   };

#   systemd.services.tailscaled.serviceConfig.Environment = [
#     "TS_DEBUG_FIREWALL_MODE=nftables"
#   ];

  systemd.services.NetworkManager-wait-online.enable = false;
#   systemd.network.wait-online.enable = false;
#   boot.initrd.systemd.network.wait-online.enable = false;

#   environment.systemPackages = [ pkgs.ethtool ];

#   services.networkd-dispatcher = {
#     enable = true;
#     rules."50-tailscale-optimizations" = {
#     onState = [ "routable" ];
#     script = ''
#       ${pkgs.ethtool}/bin/ethtool -K wlp0s20f3 rx-udp-gro-forwarding on rx-gro-list off
#     '';
#   };

  environment.systemPackages = [ pkgs.tail-tray ]
}
