{ pkgs, lib, ... }:

{
  # Boot
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [
    "ntfs"
    "exfat"
  ];

  # Network and firewall policy.
  networking = {
    networkmanager.enable = true;
    firewall = {
      enable = true;
      allowedTCPPorts = [
        3000
      ];
    };
  };

  # Device services
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
  hardware.enableRedistributableFirmware = true;

  # Locale and Vietnamese input method
  time.timeZone = "Asia/Ho_Chi_Minh";
  i18n = {
    defaultLocale = "en_US.UTF-8";

    inputMethod = {
      enable = true;
      type = "fcitx5";

      fcitx5 = {
        waylandFrontend = true;

        addons = with pkgs; [
          fcitx5-bamboo
        ];
      };
    };
  };

  # Services
  services = {
    flatpak.enable = true;
    printing.enable = true;
    udisks2.enable = true;
    # Audio
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
    # recommred services for noctalia
    upower.enable = true;
    power-profiles-daemon.enable = true;
  };
  security.rtkit.enable = true;
  # Enable flakes
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  # Enable un-free apps
  nixpkgs.config.allowUnfree = true;

  # Allow insecure pkgs
  nixpkgs.config.permittedInsecurePackages = [
    "ventoy-1.1.18"
  ];

  # Local login account and privileges
  users.users.neo = {
    isNormalUser = true;
    description = "Neo";
    extraGroups = [
      "networkmanager"
      "wheel"
      "libvirtd"
      "wireshark"
      "dialout"
    ];
    shell = pkgs.fish;
  };
  programs.fish.enable = true;

  #Enable Appimage
  programs.appimage = {
    enable = true;
    binfmt = true;
  };

  # hardware for AI
  hardware.graphics = {
    enable = true;
  };

  # Cấp phép bộ đệm GTT để iGPU mượn linh hoạt dung lượng RAM hệ thống
  boot.kernelParams = [
    "amdgpu.gttsize=24576"
  ];

  # dconf
  programs.dconf.enable = true;

  # Zram
  zramSwap = {
    enable = lib.mkDefault true;
    algorithm = lib.mkDefault "zstd";
    memoryPercent = lib.mkDefault 50;
    priority = lib.mkDefault 100;
  };

  boot.kernel.sysctl = {
    "vm.swappiness" = lib.mkDefault 180;
    "vm.page-cluster" = lib.mkDefault 0;
    "vm.watermark_boost_factor" = lib.mkDefault 0;
    "vm.watermark_scale_factor" = lib.mkDefault 125;
  };
  # Compatibility baseline: change only after reviewing NixOS migration notes.
  system.stateVersion = "26.05";
}
