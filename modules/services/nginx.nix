{ ... }:

{
  services.nginx = {
    enable = true;

    recommendedProxySettings = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;

    virtualHosts."nucthan.local" = {
      listen = [
        {
          addr = "127.0.0.1";
          port = 8080;
        }
      ];

      locations."/" = {
        return = "200 'nucthan private nginx is running\n'";
        extraConfig = ''
          add_header Content-Type text/plain;
        '';
      };
    };
  };
}
