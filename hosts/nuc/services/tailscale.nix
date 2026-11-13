{ ... }:

{
  services.tailscale = {
    enable = true;
    openFirewall = true;
    useRoutingFeatures = "server";
    extraUpFlags = [
      "--advertise-routes=192.168.0.0/24"
      "--advertise-exit-node"
    ];
  };

  networking.firewall.trustedInterfaces = [ "tailscale0" ];
}
