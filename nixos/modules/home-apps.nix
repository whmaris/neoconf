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
      fastfetch
      btop
      zathura
      imv
    ])
    ++ lib.optionals (at [ "ws" ]) (
      with pkgs;
      [
        nodejs
        pnpm
      ]
    );

  programs = {
    luciole.enable = true;
    helium.enable = true;
    zen-browser.enable = true;

    fish = {
      enable = true;
      shellAliases = {
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
    eza = {
      enable = true;
      enableFishIntegration = true;
      icons = "auto";
      git = true;
      extraOptions = [
        "--group-directories-first"
        "--header"
      ];
    };
    bat = {
      enable = true;
      config = {
        theme = "base16-256";
        pager = "less -FR";
      };
    };
    fzf = {
      enable = true;
      enableFishIntegration = true;
    };
    zoxide = {
      enable = true;
      enableFishIntegration = true;
    };
    starship = {
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
      settings = {
        add_newline = true;
        format = "[](fg:#678FE4)[   ](fg:#080B16 bg:#678FE4)[](fg:#678FE4 bg:#1B2437)$directory$git_branch$git_status$nix_shell$cmd_duration$line_break[╰─](fg:#678FE4) $character";
        character = {
          success_symbol = "[❯](bold #678FE4)[❯](bold #AB66CC)";
          error_symbol = "[❯](bold #FD4663)[❯](bold #FD4663)";
        };
        directory = {
          truncation_length = 3;
          truncation_symbol = "…/";
          truncate_to_repo = false;
          style = "fg:#E8EDFF bg:#1B2437 bold";
          format = "[ $path ]($style)[](fg:#1B2437) ";
        };
        git_branch = {
          style = "fg:#EEF4FF bg:#715CD6 bold";
          format = "[](fg:#715CD6)[ 󰘬 $branch ]($style)";
        };
        git_status = {
          style = "fg:#EEF4FF bg:#715CD6";
          format = "[$all_status$ahead_behind ]($style)[](fg:#715CD6) ";
        };
        nix_shell = {
          style = "fg:#181B24 bg:#AB66CC bold";
          format = "[](fg:#AB66CC)[ 󱄅 nix ]($style)[](fg:#AB66CC) ";
        };
        cmd_duration = {
          min_time = 2000;
          style = "fg:#AFB1B6 bg:#141B29";
          format = "[](fg:#141B29)[ 󱫐 $duration ]($style)[](fg:#141B29) ";
        };
      };
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
