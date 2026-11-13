{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    htop speedtest-cli tree gdu bluez ffmpeg python3 vim
  ];
}
