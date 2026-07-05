{ ... }:

{
  users.users.nathan = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
    ];

    openssh.authorizedKeys.keyFiles = [
      ../../ssh/laptop.pub
    ];
  };

  security.sudo.wheelNeedsPassword = true;
}
