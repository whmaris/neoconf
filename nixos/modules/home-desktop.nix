{ ... }:
{
  # umbriel settings
  programs.umbriel = {
    enable = true;
    #settings = builtins.fromTOML (builtins.readFile ./.config/umbriel/config.toml);
  };
  # noctalia settings
  programs.noctalia = {
    enable = true;
    #settings = builtins.fromTOML (builtins.readFile ./.config/noctalia/config.toml);
  };
}
