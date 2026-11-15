{
  imports = [
    ../../modules/system-settings.nix
    ../../modules/desktop-system.nix
    ../../modules/programs-system.nix
  ];
  networking.hostName = "ws";
}
