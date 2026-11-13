{ pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./packages.nix
    ./graphics.nix
    # ./services
  ];

  networking.hostName = "NathanLaptop";

  # PC: cpu.amd.updateMicrocode = true;

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Experimental = true;
        FastConnectable = true;
      };
      Policy.AutoEnable = true;
    };
  };

  services.printing.enable = true;

  services.pulseaudio.enable = false;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  zramSwap = {
    enable = true;
    memoryPercent = 100;
  };

  system.stateVersion = "26.05";
}
