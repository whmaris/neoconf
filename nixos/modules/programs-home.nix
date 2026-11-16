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
    yazi = {
      enable = true;
      plugins = {
        mount = pkgs.yaziPlugins.mount;
      };
      keymap.mgr.prepend_keymap = [
        {
          on = [
            "M"
            "M"
          ];
          run = "plugin mount";
          desc = "Disk list (plugin)";
        }
        {
          on = [
            "M"
            "m"
          ];
          run = "shell --block -- udiskie-mount -a";
          desc = "Mount all";
        }
        {
          on = [
            "M"
            "u"
          ];
          run = [
            ''shell --block -- dir=$(findmnt -no TARGET -T .); case "$dir" in /run/media/*) dev=$(findmnt -no SOURCE "$dir"); cd / && udisksctl unmount -b "$dev" || { echo "Unmount lỗi"; read -r _; } ;; *) echo "Không ở trong ổ ngoài"; read -r _ ;; esac''
            "cd ~"
          ];
          desc = "Unmount this disk";
        }
        {
          on = [
            "M"
            "e"
          ];
          run = [
            ''shell --block -- dir=$(findmnt -no TARGET -T .); case "$dir" in /run/media/*) dev=$(findmnt -no SOURCE "$dir"); disk=$(lsblk -no PKNAME "$dev" | head -n1); cd / && udisksctl unmount -b "$dev" && udisksctl power-off -b "/dev/''${disk:-$dev}" || { echo "Eject lỗi"; read -r _; } ;; *) echo "Không ở trong ổ ngoài"; read -r _ ;; esac''
            "cd ~"
          ];
          desc = "Eject this disk";
        }
      ];

    };
    zed-editor = {
      enable = true;
      #userSettings = builtins.fromJSON (builtins.readFile ./.config/zed/settings.json);
    };
    neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      sideloadInitLua = true;
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
  services.udiskie = {
    enable = true;
    automount = true;
    notify = true;
    tray = "auto";
  };

}
