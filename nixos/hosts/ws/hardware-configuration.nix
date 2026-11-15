
{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = [
    "ahci"
    "xhci_pci"
    "usbhid"
    "uas"
    "sd_mod"
  ];

  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/081fd8d6-cc6f-46ac-9960-b7fa4e7f4748";
    fsType = "btrfs";
    options = [ "noatime" "compress=zstd:3" "subvol=@root" ];
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/081fd8d6-cc6f-46ac-9960-b7fa4e7f4748";
    fsType = "btrfs";
    options = [ "noatime" "compress=zstd:3" "subvol=@home" ];
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/081fd8d6-cc6f-46ac-9960-b7fa4e7f4748";
    fsType = "btrfs";
    options = [ "noatime" "compress=zstd:3" "subvol=@nix" ];
  };

  fileSystems."/var/lib/libvirt/images" = {
    device = "/dev/disk/by-uuid/081fd8d6-cc6f-46ac-9960-b7fa4e7f4748";
    fsType = "btrfs";
    options = [ "noatime" "subvol=@vms" ];
  };

  fileSystems."/swap" = {
    device = "/dev/disk/by-uuid/081fd8d6-cc6f-46ac-9960-b7fa4e7f4748";
    fsType = "btrfs";
    options = [ "noatime" "subvol=@swap" ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/1A1A-A508";
    fsType = "vfat";
    options = [ "fmask=0022" "dmask=0022" ];
  };

  swapDevices = [
    {
      device = "/swap/swapfile";
    }
  ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  hardware.cpu.amd.updateMicrocode =
    lib.mkDefault config.hardware.enableRedistributableFirmware;
}
