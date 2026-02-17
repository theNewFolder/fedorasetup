# Foot terminal configuration - Vibrant Gruvbox with eye candy

{ config, pkgs, colorScheme, lib, ... }:

let
  # Foot requires colors without '#' prefix
  c = builtins.replaceStrings ["#"] [""] ;
in
{
  programs.foot = {
    enable = true;

    settings = {
      main = {
        term = "xterm-256color";
        font = "JetBrainsMono Nerd Font:size=12";
        dpi-aware = "yes";
        pad = "12x12";
      };

      cursor = {
        style = "beam";
        beam-thickness = 2;
        blink = "yes";
      };

      mouse = {
        hide-when-typing = "yes";
      };

      colors = {
        alpha = 0.95;
        background = c colorScheme.bg;
        foreground = c colorScheme.fg;

        ## Normal colors
        regular0 = c colorScheme.bg0;
        regular1 = c colorScheme.red;
        regular2 = c colorScheme.green;
        regular3 = c colorScheme.yellow;
        regular4 = c colorScheme.blue;
        regular5 = c colorScheme.purple;
        regular6 = c colorScheme.aqua;
        regular7 = c colorScheme.fg4;

        ## Bright colors
        bright0 = c colorScheme.gray;
        bright1 = c colorScheme.bright_red;
        bright2 = c colorScheme.bright_green;
        bright3 = c colorScheme.bright_yellow;
        bright4 = c colorScheme.bright_blue;
        bright5 = c colorScheme.bright_purple;
        bright6 = c colorScheme.bright_aqua;
        bright7 = c colorScheme.fg0;

        ## Selection colors
        selection-foreground = c colorScheme.bg;
        selection-background = c colorScheme.bright_yellow;

        ## URL colors
        urls = c colorScheme.bright_blue;
      };

      bell = {
        urgent = "yes";
        notify = "yes";
        visual = "yes";
      };

      scrollback = {
        lines = 10000;
        multiplier = 3.0;
      };
    };
  };
}
