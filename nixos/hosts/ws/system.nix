{ lib, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/system-settings.nix
    ../../modules/system-apps.nix
    ../../modules/system-desktop.nix
  ];

  networking.hostName = "ws";
  fileSystems = lib.genAttrs [ "/" "/home" "/nix" "/var/lib/libvirt/images" "/swap" ] (_: {
    options = [
      "compress=zstd"
      "noatime"
    ];
  });

  swapDevices = [ { device = "/swap/swapfile"; } ];

  hardware.enableRedistributableFirmware = true;

  #latest kenrnel
  boot.kernelPackages = pkgs.linuxPackages_latest;
}
