{ pkgs, username, ... }:

{
  # ============================================================
  # Steam
  # ============================================================
  programs.steam = {
    enable = true;

    # Remote Play and local network game transfers
    remotePlay.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;

    # GE-Proton
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];

    # Proton tools
    protontricks.enable = true;

    # Optional: Steam Input on Wayland
    # extest.enable = true;
  };

  # ============================================================
  # Performance
  # ============================================================
  programs.gamemode = {
    enable = true;
    settings.general.renice = 10;
  };

  users.users.${username}.extraGroups = [ "gamemode" ];

  # Gamescope for resolution scaling and FSR
  programs.gamescope = {
    enable = true;
    capSysNice = true;
  };

  # ============================================================
  # Gaming tools
  # ============================================================
  environment.systemPackages = with pkgs; [
    mangohud # FPS and hardware monitoring
    heroic # Epic, GOG and Amazon games
  ];
}
