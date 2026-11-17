{ pkgs, at, ... }:

{
  environment.systemPackages = with pkgs; [
    ventoy
    usbutils
    tio
    nmap
    zenmap
  ];

  # Wireshark
  programs.wireshark = {
    enable = true;
  };

  # Winbox.
  programs.winbox = {
    enable = true;
    openFirewall = true;
  };

  #VM applications.
  programs.virt-manager.enable = true;
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
      swtpm.enable = true;
      vhostUserPackages = with pkgs; [
        virtiofsd
      ];
    };
  };

  # USB passthrough via SPICE
  virtualisation.spiceUSBRedirection.enable = true;

  # Font
  fonts = {
    fontconfig.enable = true;
    packages = with pkgs; [
      cascadia-code
      jetbrains-mono
      fira-code
      hack-font
      nerd-fonts.jetbrains-mono
      inter
      roboto
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
      font-awesome
    ];
  };

  # OLLAMA
  services.ollama = {
    enable = at [ "ws" ];
    package = pkgs.ollama-vulkan;
    environmentVariables = {
      HIP_VISIBLE_DEVICES = "-1"; # tắt ROCm
      GGML_VK_VISIBLE_DEVICES = "0"; # dùng GPU Vulkan đầu tiên
      OLLAMA_IGPU_ENABLE = "1"; # cho phép dùng GPU tích hợp
      OLLAMA_CONTEXT_LENGTH = "16384";
    };
  };

  #Nix-ld
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      stdenv.cc.cc
      zlib
      openssl
      curl
    ];
  };
}
