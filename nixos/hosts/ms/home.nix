{ ... }:
{
  imports = [
    ../../modules/home-desktop.nix
    ../../modules/home-apps.nix
    ../../modules/home-settings.nix

  ];

  home.stateVersion = "26.05";
}
