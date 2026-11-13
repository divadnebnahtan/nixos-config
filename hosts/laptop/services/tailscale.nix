{ ... }:
{
  services.tailscale.enable = true;

  services.resolved.enable = true;
  networking.networkmanager.dns = "systemd-resolved";

  # Authenticate once with `sudo tailscale up`; let Tailscale manage its DNS.
}
