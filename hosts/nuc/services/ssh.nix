{ ... }:

let
  keyDir = ../data/ssh;

  keyFiles =
    builtins.map
      (name: keyDir + "/${name}")
      (builtins.filter
        (name:
          builtins.match ".*\\.pub" name != null
        )
        (builtins.attrNames (builtins.readDir keyDir)));
in
{
  services.openssh = {
    enable = true;
    openFirewall = false;

    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      X11Forwarding = false;
      AllowAgentForwarding = false;
      AllowTcpForwarding = "local";
      PermitTunnel = false;
    };
  };
  
  users.users.nathan.openssh.authorizedKeys.keyFiles = keyFiles;

}
