{
  pkgs,
  at,
  lib,
  ...
}:

{
  home.packages =
    (with pkgs; [
      onlyoffice-desktopeditors
      dropbox
      rustdesk-flutter
      inkscape
      gimp
      unar
      filen-desktop
      fastfetch
      btop
    ])
    ++ lib.optionals (at [ "ws" ]) (
      with pkgs;
      [
        nodejs
        pnpm
      ]
    );

  programs = {
    helium.enable = true;
    zen-browser.enable = true;
    bash = {
      enable = true;
      shellAliases = {
        nrs = "sudo nixos-rebuild switch --flake ~/neoconf/nixos#ws";
        ndg = "sudo nix-env --profile /nix/var/nix/profiles/system --delete-generations";
        ngc = "sudo nix-collect-garbage";
      };
    };
    fish = {
      enable = true;
      shellAliases = {
        nrs = "sudo nixos-rebuild switch --flake ~/neoconf/nixos#ws";
        ndg = "sudo nix-env --profile /nix/var/nix/profiles/system --delete-generations";
        ngc = "sudo nix-collect-garbage";
      };
      interactiveShellInit = ''
        set fish_greeting
      '';
    };
    ghostty = {
      enable = true;
      enableFishIntegration = true;
    };
    git = {
      enable = true;
      settings.user = {
        name = "Neo";
        email = "wheelhousemaris@gmail.com";
      };
    };
    yazi.enable = true;
    zed-editor = {
      enable = true;
      #userSettings = builtins.fromJSON (builtins.readFile ./.config/zed/settings.json);
    };
    neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      extraPackages = with pkgs; [
        nil # Nix LSP
        nixfmt
        lua-language-server
        typescript-language-server
        vscode-langservers-extracted # html, css, json
        tailwindcss-language-server
        ripgrep # telescope live_grep
        fd
      ];
      plugins = with pkgs.vimPlugins; [
        catppuccin-nvim
        nvim-web-devicons
        lualine-nvim
        telescope-nvim
        plenary-nvim
        nvim-treesitter.withAllGrammars
        nvim-lspconfig
        blink-cmp
        conform-nvim
        gitsigns-nvim
        oil-nvim
        which-key-nvim
        nvim-autopairs
      ];
      initLua = builtins.readFile ./../.config/nvim/init.lua;
    };
  };

  services.flatpak = {
    enable = true;
    remotes = [
      {
        name = "flathub";
        location = "https://dl.flathub.org/repo/flathub.flatpakrepo";
      }
    ];

    packages = [
      "eu.betterbird.Betterbird"
      "com.tencent.WeChat"
      "com.rtosta.zapzap"
    ];

    update.auto = {
      enable = true;
      onCalendar = "weekly";
    };
  };
}
