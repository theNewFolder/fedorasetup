{ config, pkgs, ... }:

{
  # Firefox - Gruvbox minimal, keyboard-driven, Emacs-integrated

  home.packages = with pkgs; [
    tridactyl-native  # Native messenger for Tridactyl extension
  ];

  # Tridactyl config
  xdg.configFile."tridactyl/tridactylrc".text = ''
    " Tridactyl config - Gruvbox + Vim workflow

    " Reset
    sanitise tridactyllocal tridactylsync

    " Theme
    colorscheme dark

    " General
    set smoothscroll true
    set newtab about:blank
    set editorcmd foot -a floating emacsclient -t %f

    " Hints
    set hintchars hjklasdfgyuiopqwertnmzxcvb
    set hintfiltermode vimperator-reflow
    set hintdelay 100

    " Search engines
    set searchurls.g https://www.google.com/search?q=%s
    set searchurls.gh https://github.com/search?q=%s
    set searchurls.w https://en.wikipedia.org/wiki/Special:Search/%s
    set searchurls.yt https://www.youtube.com/results?search_query=%s
    set searchurls.nix https://search.nixos.org/packages?query=%s
    set searchurls.r https://www.reddit.com/search/?q=%s

    " Navigation
    bind j scrollline 5
    bind k scrollline -5
    bind J tabnext
    bind K tabprev
    bind d tabclose
    bind u undo
    bind gi focusinput -l
    bind gd tabdetach
    bind gD composite tabduplicate; tabdetach

    " Open/follow
    bind O fillcmdline open
    bind t fillcmdline tabopen
    bind T current_url tabopen
    bind yy clipboard yank
    bind p clipboard open
    bind P clipboard tabopen

    " Bookmarks
    bind B fillcmdline bmarks -t

    " Org-protocol capture from Firefox to Emacs
    command org-capture composite get_current_url | js -p tri.excmds.open("org-protocol:///capture?template=w&url=" + encodeURIComponent(document.location.href) + "&title=" + encodeURIComponent(document.title))
    bind ,c org-capture

    " Disable on sites that need keyboard
    autocmd DocStart mail.google.com mode ignore
    autocmd DocStart calendar.google.com mode ignore
    autocmd DocStart docs.google.com mode ignore
    autocmd DocStart meet.google.com mode ignore
    autocmd DocStart discord.com mode ignore
    autocmd DocStart monkeytype.com mode ignore

    " vim: set filetype=tridactyl
  '';

  # Firefox user.js - performance + privacy + Wayland/Intel UHD 620
  # Applied via home.file to the active profile
  home.file.".mozilla/firefox/k5lnwcbg.default-release/user.js".text = ''
    // Firefox Performance + Privacy tweaks for Wayland/Intel UHD 620
    // Does NOT clear data/logins

    // ===== Enable userChrome.css =====
    user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);

    // ===== Wayland + Hardware Acceleration =====
    user_pref("gfx.webrender.all", true);
    user_pref("media.ffmpeg.vaapi.enabled", true);
    user_pref("media.hardware-video-decoding.enabled", true);
    user_pref("widget.dmabuf.force-enabled", true);
    user_pref("media.av1.enabled", false); // Intel UHD 620 has no AV1 decode

    // ===== Performance =====
    user_pref("browser.cache.disk.enable", true);
    user_pref("browser.cache.memory.capacity", 524288); // 512MB
    user_pref("network.http.max-persistent-connections-per-server", 10);
    user_pref("network.http.pipelining", true);
    user_pref("network.dns.disablePrefetch", false);
    user_pref("network.prefetch-next", true);
    user_pref("content.notify.interval", 100000);
    user_pref("browser.sessionstore.interval", 60000); // Save session every 60s

    // ===== Privacy (moderate - don't break sites) =====
    user_pref("privacy.trackingprotection.enabled", true);
    user_pref("privacy.trackingprotection.socialtracking.enabled", true);
    user_pref("dom.security.https_only_mode", true);
    user_pref("network.cookie.cookieBehavior", 5); // Total cookie protection
    user_pref("privacy.resistFingerprinting", false); // Would break some sites

    // ===== UI Minimal =====
    user_pref("browser.tabs.inTitlebar", 0);
    user_pref("browser.compactmode.show", true);
    user_pref("browser.uidensity", 1); // Compact
    user_pref("browser.theme.content-theme", 0); // Dark
    user_pref("browser.theme.toolbar-theme", 0); // Dark
    user_pref("extensions.pocket.enabled", false);
    user_pref("browser.newtabpage.activity-stream.feeds.section.topstories", false);
    user_pref("browser.newtabpage.activity-stream.showSponsoredTopSites", false);

    // ===== Keyboard/Tridactyl friendly =====
    user_pref("browser.ctrlTab.recentlyUsedOrder", false);
    user_pref("accessibility.typeaheadfind.flashBar", 0);
  '';

  # userChrome.css - Gruvbox dark minimal
  home.file.".mozilla/firefox/k5lnwcbg.default-release/chrome/userChrome.css".text = ''
    /* Gruvbox Dark Minimal Firefox - Hide tabs, minimal UI */

    /* ===== Hide tab bar (use Tridactyl for tab switching) ===== */
    #TabsToolbar { visibility: collapse !important; }

    /* ===== Minimal nav bar ===== */
    #nav-bar {
      background: #1d2021 !important;
      border: none !important;
      padding: 2px 8px !important;
    }

    /* Auto-hide nav bar (show on hover) */
    #nav-bar {
      --uc-navbar-transform: -40px;
      transform: rotateX(90deg);
      transform-origin: top;
      transition: transform 0.15s ease-in-out, opacity 0.15s ease-in-out !important;
      opacity: 0;
      z-index: 2;
    }

    #navigator-toolbox:hover > #nav-bar,
    #nav-bar:focus-within {
      transform: rotateX(0);
      opacity: 1;
    }

    /* ===== URL bar ===== */
    #urlbar-background {
      background: #282828 !important;
      border: 1px solid #504945 !important;
      border-radius: 8px !important;
    }

    #urlbar:not([focused]) #urlbar-background {
      background: #1d2021 !important;
      border-color: #3c3836 !important;
    }

    #urlbar[focused] #urlbar-background {
      border-color: #e8a50e !important;
      box-shadow: 0 0 6px rgba(232, 165, 14, 0.2) !important;
    }

    #urlbar-input {
      color: #fbf1c7 !important;
      font-family: "JetBrainsMono Nerd Font", monospace !important;
      font-size: 13px !important;
    }

    /* ===== Sidebar ===== */
    #sidebar-header {
      background: #1d2021 !important;
      border-bottom: 1px solid #3c3836 !important;
    }

    /* ===== Context menus ===== */
    menupopup {
      --panel-background: #282828 !important;
      --panel-color: #fbf1c7 !important;
      --panel-border-color: #504945 !important;
    }

    /* ===== Findbar ===== */
    .findbar-container {
      background: #282828 !important;
      color: #fbf1c7 !important;
    }

    /* ===== Scrollbars ===== */
    :root {
      scrollbar-color: #504945 #1d2021 !important;
      scrollbar-width: thin !important;
    }
  '';
}
