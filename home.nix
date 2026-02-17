{ config, pkgs, ... }:

{
  home.username = "dev";
  home.homeDirectory = "/home/dev";
  home.stateVersion = "24.11";

  programs.home-manager.enable = true;

  # ===== Packages =====
  home.packages = with pkgs; [
    # Modern CLI
    ripgrep fd bat eza fzf zoxide delta
    btop bottom htop procs dust bandwhich
    tealdeer jq yq sd hexyl tokei hyperfine

    # File managers
    yazi nnn lf

    # Media
    mpv imv ffmpeg yt-dlp

    # Dev tools
    lazygit gh neovim helix
    gnumake cmake

    # Productivity
    zathura

    # Wayland tools
    grim slurp swappy wl-clipboard wf-recorder
    wlsunset libnotify

    # Fun
    fastfetch cmatrix cowsay fortune

    # Fonts (SystemCrafters recommended)
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    nerd-fonts.iosevka
    noto-fonts
    noto-fonts-color-emoji
  ];

  # ===== Git =====
  programs.git = {
    enable = true;
    userName = "dev";
    userEmail = "dev@tuxnix.local";
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
      core.editor = "emacsclient -t";
      color.ui = "auto";
    };
    ignores = [ "*~" "*.swp" ".DS_Store" ".env" "result" ];
  };

  # ===== Zsh =====
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    history = {
      size = 100000;
      save = 100000;
      ignoreDups = true;
      ignoreSpace = true;
      share = true;
    };

    shellAliases = {
      ls = "eza --icons --group-directories-first";
      ll = "eza -la --icons --group-directories-first";
      lt = "eza --tree --icons -L 2";
      cat = "bat --style=plain";
      top = "btop";
      ".." = "cd ..";
      "..." = "cd ../..";
      g = "git";
      gs = "git status";
      gc = "git commit";
      gp = "git push";
      gd = "git diff";
      glog = "git log --oneline --graph --decorate -10";
      e = "emacsclient -c -a emacs";
      et = "emacsclient -t -a emacs";
      rebuild-home = "home-manager switch --flake ~/fedorasetup#dev";
    };

    initContent = ''
      # Load secrets
      [[ -f ~/.secrets/gemini_api_key ]] && export GEMINI_API_KEY=$(cat ~/.secrets/gemini_api_key)
      [[ -f ~/.secrets/anthropic_api_key ]] && export ANTHROPIC_API_KEY=$(cat ~/.secrets/anthropic_api_key)

      # FZF
      export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
      export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'

      # Helpers
      mkcd() { mkdir -p "$1" && cd "$1"; }

      # History search
      bindkey '^[[A' history-search-backward
      bindkey '^[[B' history-search-forward
    '';
  };

  # ===== Starship Prompt =====
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      add_newline = true;
      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[➜](bold red)";
      };
      directory = {
        truncation_length = 3;
        truncate_to_repo = true;
      };
      git_branch.symbol = " ";
      nodejs.symbol = " ";
      python.symbol = " ";
      rust.symbol = " ";
      nix_shell.symbol = " ";
      cmd_duration.min_time = 500;
      battery.display = [{ threshold = 30; style = "bold red"; }];
    };
  };

  # ===== FZF =====
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  # ===== Zoxide =====
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  # ===== Direnv =====
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  # ===== GTK Theme =====
  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    gtk3.extraConfig.gtk-application-prefer-dark-theme = true;
    gtk4.extraConfig.gtk-application-prefer-dark-theme = true;
  };

  # ===== Wayland Environment =====
  home.sessionVariables = {
    EDITOR = "emacsclient -t";
    VISUAL = "emacsclient -c";
    PAGER = "bat --style=plain";
    MOZ_ENABLE_WAYLAND = "1";
    QT_QPA_PLATFORM = "wayland";
    LIBVA_DRIVER_NAME = "iHD";
    PATH = "$HOME/.local/bin:$HOME/bin:$PATH";
  };

  # ===== XDG =====
  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      createDirectories = true;
    };
  };

  # ===== Font Config =====
  fonts.fontconfig.enable = true;
}
