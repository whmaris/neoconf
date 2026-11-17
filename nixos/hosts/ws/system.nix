{ lib, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/system-settings.nix
    ../../modules/system-apps.nix
    ../../modules/system-desktop.nix
  ];

  networking.hostName = "ws";

  # Add compress and noatime for hardware-configuration
  fileSystems = lib.genAttrs [ "/" "/home" "/nix" "/var/lib/libvirt/images" "/swap" ] (_: {
    options = [
      "compress=zstd"
      "noatime"
    ];
  });

  swapDevices = [
    {
      device = "/swap/swapfile";
      size = 8 * 1024;
    }
  ];

  # Set C flag for VM images
  systemd.tmpfiles.rules = [ "h /var/lib/libvirt/images - - - - =C" ];

  # Enable Redistributable Firmware
  hardware.enableRedistributableFirmware = true;
}
