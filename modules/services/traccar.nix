{ ... }:

{
  services.traccar = {
    enable = true;

    settings = {
      # Main web UI
      "web.address" = "127.0.0.1";
      "web.port" = "8082";

      # Traccar Client protocol.
      # The mobile Traccar Client app uses port 5055.
      "osmand.port" = "5055";
    };
  };

  # Do not open Traccar directly to LAN/public.
  # Funnel will expose only the needed endpoint.
}
