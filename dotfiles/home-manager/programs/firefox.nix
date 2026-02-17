# Firefox browser configuration
# Keyboard-driven, minimal Gruvbox UI with Tridactyl
# Hardware-accelerated for Wayland (Intel UHD 620 / VA-API)
# Privacy-tuned (Arkenfox-inspired) without breaking sites

{ config, pkgs, colorScheme, ... }:

{
  programs.firefox = {
    enable = true;

    profiles.dev = {
      id = 0;
      isDefault = true;

      settings = {
        # ========================================================
        # PERFORMANCE & HARDWARE ACCELERATION
        # ========================================================

        # --- WebRender (GPU-composited rendering) ---
        # gfx.webrender.all implies layers.acceleration.force-enabled
        "gfx.webrender.all" = true;
        "gfx.webrender.compositor.force-enabled" = true;
        "gfx.canvas.accelerated" = true;
        "gfx.canvas.accelerated.cache-items" = 4096;
        "gfx.canvas.accelerated.cache-size" = 512;
        "gfx.content.skia-font-cache-size" = 20;
        "layers.acceleration.force-enabled" = true;

        # --- VA-API hardware video decoding (Intel UHD 620) ---
        # Enabled by default since firefox-101+ on Fedora for Intel/AMD
        "media.ffmpeg.vaapi.enabled" = true;
        "media.hardware-video-decoding.force-enabled" = true;
        "media.av1.enabled" = true;
        # Use EGL backend for VA-API on Wayland
        "widget.dmabuf.force-enabled" = true;
        # gfx.x11-egl.force-enabled not needed on pure Wayland

        # --- Memory & caching ---
        "browser.cache.disk.enable" = false;       # RAM-only cache (SSD friendly)
        "browser.cache.memory.enable" = true;
        "browser.cache.memory.capacity" = 524288;   # 512 MB
        "browser.sessionstore.interval" = 30000;     # Save session every 30s (not 15M)
        "browser.sessionhistory.max_total_viewers" = 4;  # Limit bfcache entries
        "image.mem.surfacecache.max_size_kb" = 2097152;  # 2 GB image surface cache
        "image.mem.min_discard_timeout_ms" = 2100000000;  # Keep decoded images in RAM

        # --- Network ---
        "network.http.max-connections" = 1800;
        "network.http.max-persistent-connections-per-server" = 10;
        "network.dns.disablePrefetch" = false;
        "network.prefetch-next" = true;
        "network.predictor.enabled" = true;
        "network.http.speculative-parallel-limit" = 6;
        # NOTE: network.http.pipelining removed - deprecated in modern Firefox

        # --- Process model ---
        "dom.ipc.processCount" = 8;
        "dom.ipc.processCount.webIsolated" = 4;

        # --- Wayland-specific smoothness ---
        "widget.wayland.vsync.enabled" = true;
        "apz.gtk.kinetic_scroll.enabled" = false;   # Tighter scroll on Wayland

        # ========================================================
        # PRIVACY & SECURITY (Arkenfox-inspired, site-safe)
        # ========================================================

        # --- Enhanced Tracking Protection ---
        "privacy.trackingprotection.enabled" = true;
        "privacy.trackingprotection.socialtracking.enabled" = true;
        "privacy.trackingprotection.fingerprinting.enabled" = true;
        "privacy.trackingprotection.cryptomining.enabled" = true;
        "privacy.annotate_channels.strict_list.enabled" = true;

        # --- Telemetry (kill it all) ---
        "datareporting.healthreport.uploadEnabled" = false;
        "datareporting.policy.dataSubmissionEnabled" = false;
        "toolkit.telemetry.enabled" = false;
        "toolkit.telemetry.unified" = false;
        "toolkit.telemetry.archive.enabled" = false;
        "toolkit.telemetry.newProfilePing.enabled" = false;
        "toolkit.telemetry.updatePing.enabled" = false;
        "toolkit.telemetry.bhrPing.enabled" = false;
        "toolkit.telemetry.firstShutdownPing.enabled" = false;
        "toolkit.telemetry.coverage.opt-out" = true;
        "toolkit.coverage.opt-out" = true;
        "toolkit.coverage.endpoint.base" = "";
        "browser.ping-centre.telemetry" = false;
        "browser.newtabpage.activity-stream.feeds.telemetry" = false;
        "browser.newtabpage.activity-stream.telemetry" = false;

        # --- Studies & experiments ---
        "app.shield.optoutstudies.enabled" = false;
        "app.normandy.enabled" = false;
        "app.normandy.api_url" = "";

        # --- Beacons & pings ---
        "browser.send_pings" = false;
        "beacon.enabled" = false;

        # --- Fingerprinting (OFF to avoid site breakage) ---
        "privacy.resistFingerprinting" = false;
        "privacy.firstparty.isolate" = false;
        "webgl.disabled" = false;

        # --- HTTPS-only ---
        "dom.security.https_only_mode" = true;
        "dom.security.https_only_mode_ever_enabled" = true;

        # --- DNS over HTTPS ---
        "network.trr.mode" = 2;                            # Prefer DoH, fallback to system
        "network.trr.uri" = "https://dns.quad9.net/dns-query";

        # --- Cookies ---
        "network.cookie.cookieBehavior" = 5;               # dFPI (Total Cookie Protection)
        "privacy.purge_trackers.enabled" = true;

        # --- Autofill (disable for privacy) ---
        "browser.formfill.enable" = false;
        "extensions.formautofill.addresses.enabled" = false;
        "extensions.formautofill.creditCards.enabled" = false;

        # --- Misc privacy ---
        "extensions.pocket.enabled" = false;
        "privacy.donottrackheader.enabled" = true;
        "geo.enabled" = false;
        "browser.safebrowsing.downloads.remote.enabled" = false;
        "network.IDN_show_punycode" = true;                # Anti-phishing

        # ========================================================
        # UI & UX - MINIMAL KEYBOARD-DRIVEN
        # ========================================================

        # Enable userChrome.css customization
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;

        # Compact UI
        "browser.compactmode.show" = true;
        "browser.uidensity" = 1;                           # 1 = compact
        "browser.tabs.inTitlebar" = 1;
        "browser.tabs.tabMinWidth" = 50;
        "browser.toolbars.bookmarks.visibility" = "never";

        # Tridactyl-friendly: let Ctrl+L work for URL bar focus
        "browser.urlbar.clickSelectsAll" = true;
        "browser.urlbar.trimURLs" = false;                 # Show full URLs
        "browser.urlbar.suggest.searches" = true;
        "browser.search.suggest.enabled" = true;
        "browser.urlbar.suggest.quicksuggest.sponsored" = false;
        "browser.urlbar.suggest.quicksuggest.nonsponsored" = false;

        # Session & startup
        "browser.startup.page" = 3;                        # Restore previous session
        "browser.newtabpage.enabled" = false;
        "browser.newtabpage.activity-stream.showSponsored" = false;
        "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
        "browser.aboutConfig.showWarning" = false;         # No about:config nag

        # Smooth scrolling (tuned for Wayland)
        "general.smoothScroll" = true;
        "general.smoothScroll.msdPhysics.enabled" = true;
        "general.smoothScroll.msdPhysics.motionBeginSpringConstant" = 600;
        "general.smoothScroll.msdPhysics.slowdownMinDeltaRatio" = "1.3";
        "general.smoothScroll.msdPhysics.slowdownSpringConstant" = 250;
        "general.smoothScroll.currentVelocityWeighting" = "0.12";
        "general.smoothScroll.stopDecelerationWeighting" = "0.82";
        "mousewheel.default.delta_multiplier_y" = 80;

        # Animations (minimal)
        "browser.tabs.animate" = false;
        "browser.fullscreen.animate" = false;
        "ui.prefersReducedMotion" = 1;                     # Reduce motion system-wide

        # Font rendering (Linux/FreeType)
        "gfx.text.subpixel-position.force-enabled" = true;
        "font.name.serif.x-western" = "Noto Serif";
        "font.name.sans-serif.x-western" = "Noto Sans";
        "font.name.monospace.x-western" = "JetBrainsMono Nerd Font";

        # ===== Experimental =====
        "layout.css.backdrop-filter.enabled" = true;
        "svg.context-properties.content.enabled" = true;

        # ========================================================
        # ACCESSIBILITY (disable to free resources if not needed)
        # ========================================================
        "accessibility.force_disabled" = 1;
      };

      # ============================================================
      # userChrome.css - Minimal Gruvbox Dark with auto-hide
      # ============================================================
      # Hides tab bar entirely (use Tridactyl for tab switching).
      # Nav bar auto-hides until hover or Ctrl+L focus.
      # All chrome painted in Gruvbox palette.
      # ============================================================

      userChrome = ''
        /* ===== MINIMAL GRUVBOX FIREFOX =====
         * Designed for keyboard-driven workflow with Tridactyl.
         * Tab bar: hidden (use Tridactyl b/B/gt/gT).
         * Nav bar: auto-hides, revealed on hover or Ctrl+L.
         * All UI: Gruvbox Dark palette.
         * ===================================== */

        /* --- CSS Variables for Gruvbox --- */
        :root {
          --gruvbox-bg0:     ${colorScheme.bg};
          --gruvbox-bg1:     ${colorScheme.bg1};
          --gruvbox-bg2:     ${colorScheme.bg2};
          --gruvbox-bg3:     ${colorScheme.bg3};
          --gruvbox-fg:      ${colorScheme.fg};
          --gruvbox-fg2:     ${colorScheme.fg2};
          --gruvbox-fg4:     ${colorScheme.fg4};
          --gruvbox-red:     ${colorScheme.red};
          --gruvbox-green:   ${colorScheme.green};
          --gruvbox-yellow:  ${colorScheme.yellow};
          --gruvbox-blue:    ${colorScheme.blue};
          --gruvbox-purple:  ${colorScheme.purple};
          --gruvbox-aqua:    ${colorScheme.aqua};
          --gruvbox-orange:  ${colorScheme.orange};
          --gruvbox-bright-yellow: ${colorScheme.bright_yellow};
          --gruvbox-bright-blue:   ${colorScheme.bright_blue};
          --gruvbox-bright-aqua:   ${colorScheme.bright_aqua};
        }

        /* ===== HIDE TAB BAR COMPLETELY =====
         * With Tridactyl: b (buffer list), B (pick tab),
         * gt/gT (next/prev tab), d (close tab), u (undo close)
         */
        #TabsToolbar {
          visibility: collapse !important;
        }

        /* ===== AUTO-HIDE NAVIGATION BAR =====
         * Slides up when not focused. Ctrl+L or mouse hover reveals it.
         * Transition: fast reveal, slow hide (so it stays visible while typing).
         */
        #navigator-toolbox {
          --navbar-height: 40px;
          background-color: var(--gruvbox-bg0) !important;
        }

        #nav-bar {
          background-color: var(--gruvbox-bg0) !important;
          border-bottom: 2px solid var(--gruvbox-bg2) !important;
          margin-top: calc(-1 * var(--navbar-height)) !important;
          opacity: 0;
          transition: margin-top 0.15s ease-in 0.8s,
                      opacity 0.15s ease-in 0.8s !important;
          z-index: 1;
        }

        /* Reveal on hover over the toolbar area */
        #navigator-toolbox:hover > #nav-bar,
        /* Reveal when URL bar is focused (Ctrl+L, Tridactyl :open) */
        #navigator-toolbox:focus-within > #nav-bar,
        /* Reveal when customizing */
        #nav-bar[customizing="true"] {
          margin-top: 0 !important;
          opacity: 1;
          transition: margin-top 0.1s ease-out,
                      opacity 0.1s ease-out !important;
        }

        /* ===== URL BAR (Gruvbox styled) ===== */
        #urlbar {
          background-color: var(--gruvbox-bg1) !important;
          color: var(--gruvbox-fg) !important;
          border: 1px solid var(--gruvbox-bg3) !important;
          border-radius: 8px !important;
          font-family: "JetBrainsMono Nerd Font", monospace !important;
          font-size: 13px !important;
        }

        #urlbar:focus-within {
          border-color: var(--gruvbox-yellow) !important;
          box-shadow: 0 0 4px rgba(232, 165, 14, 0.3) !important;
        }

        #urlbar-input {
          color: var(--gruvbox-fg) !important;
        }

        /* URL bar results dropdown */
        .urlbarView {
          background-color: var(--gruvbox-bg0) !important;
          color: var(--gruvbox-fg) !important;
        }

        .urlbarView-row:hover,
        .urlbarView-row[selected] {
          background-color: var(--gruvbox-bg2) !important;
        }

        /* ===== SEARCH BAR ===== */
        #searchbar {
          background-color: var(--gruvbox-bg1) !important;
          color: var(--gruvbox-fg) !important;
          border-radius: 8px !important;
        }

        /* ===== NAVIGATOR TOOLBOX ===== */
        #navigator-toolbox {
          border-bottom: none !important;
        }

        /* ===== SIDEBAR ===== */
        #sidebar-header {
          display: none !important;
        }

        #sidebar-box {
          background-color: var(--gruvbox-bg0) !important;
        }

        /* ===== CONTEXT MENUS & PANELS ===== */
        menupopup,
        panel {
          --panel-background: var(--gruvbox-bg0) !important;
          --panel-color: var(--gruvbox-fg) !important;
        }

        /* ===== FINDBAR (Ctrl+F) ===== */
        .findbar-container {
          background-color: var(--gruvbox-bg1) !important;
          color: var(--gruvbox-fg) !important;
        }

        .findbar-textbox {
          background-color: var(--gruvbox-bg0) !important;
          color: var(--gruvbox-fg) !important;
          border: 1px solid var(--gruvbox-bg3) !important;
        }

        .findbar-textbox:focus {
          border-color: var(--gruvbox-yellow) !important;
        }

        /* ===== TOOLBAR BUTTONS ===== */
        toolbarbutton {
          color: var(--gruvbox-fg4) !important;
        }

        toolbarbutton:hover {
          background-color: var(--gruvbox-bg2) !important;
          color: var(--gruvbox-fg) !important;
        }

        /* ===== PRIVATE BROWSING INDICATOR ===== */
        #private-browsing-indicator-with-label {
          display: none !important;
        }

        /* ===== REMOVE UNNECESSARY CHROME ===== */
        #alltabs-button,
        #tracking-protection-icon-container,
        #page-action-buttons > :not(#star-button-box),
        #reader-mode-button,
        .titlebar-spacer,
        #firefox-view-button {
          display: none !important;
        }
      '';

      # ============================================================
      # userContent.css - Dark about: pages, new tab, error pages
      # ============================================================

      userContent = ''
        /* ===== Gruvbox dark for internal pages ===== */
        @-moz-document url-prefix(about:) {
          :root {
            --in-content-page-background: ${colorScheme.bg} !important;
            --in-content-page-color: ${colorScheme.fg} !important;
            --in-content-box-background: ${colorScheme.bg1} !important;
            --in-content-button-background: ${colorScheme.bg2} !important;
            --in-content-primary-button-background: ${colorScheme.yellow} !important;
            --in-content-primary-button-text-color: ${colorScheme.bg} !important;
            --in-content-focus-outline-color: ${colorScheme.yellow} !important;
          }
          body, #newtab-customize-overlay {
            background-color: ${colorScheme.bg} !important;
            color: ${colorScheme.fg} !important;
          }
        }

        /* Dark new-tab / blank page */
        @-moz-document url-prefix(about:blank),
        @-moz-document url-prefix(about:newtab),
        @-moz-document url-prefix(about:home),
        @-moz-document url-prefix(about:privatebrowsing) {
          body {
            background-color: ${colorScheme.bg} !important;
          }
        }

        /* Gruvbox for Tridactyl new tab page */
        @-moz-document url("moz-extension://tridactyl/static/newtab.html") {
          body {
            background-color: ${colorScheme.bg} !important;
            color: ${colorScheme.fg} !important;
          }
        }
      '';
    };
  };

  # ================================================================
  # Tridactyl configuration
  # ================================================================
  # Place at $XDG_CONFIG_HOME/tridactyl/tridactylrc
  # Loaded automatically by Tridactyl native messenger on startup.
  # After changes: :source in Firefox or restart.
  # ================================================================

  xdg.configFile."tridactyl/tridactylrc".text = ''
    " ===== Tridactyl Configuration =====
    " Keyboard-driven Firefox, Gruvbox themed
    " Vim-style navigation, org-protocol integration
    " =====================================

    " Reset to defaults first
    sanitise tridactyllocal tridactylsync

    " ===== APPEARANCE =====

    " Use Gruvbox dark colors for Tridactyl command line & hints
    " (loads base16 gruvbox from bezmi/base16-tridactyl)
    colourscheme --url https://raw.githubusercontent.com/bezmi/base16-tridactyl/master/base16-gruvbox-dark-hard.css

    " Tridactyl replaces newtab with its own (dark background via userContent.css)
    set newtab about:blank

    " ===== GENERAL SETTINGS =====

    " Smooth scrolling
    set smoothscroll true
    set scrollduration 100

    " Show tab numbers in hints
    set hintfiltermode vimperator-reflow
    set hintnames numeric
    set hintchars 1234567890

    " Follow links with characters (alternative: set hintchars asdfghjkl)
    " set hintchars asdfghjkl

    " Editor for Ctrl-I in textboxes (opens Emacs via emacsclient)
    set editorcmd emacsclient -c -a emacs +%l:%c %f

    " ===== SEARCH ENGINES =====

    set searchengine duckduckgo
    set searchurls.google    https://www.google.com/search?q=%s
    set searchurls.ddg       https://duckduckgo.com/?q=%s
    set searchurls.github    https://github.com/search?q=%s
    set searchurls.nixpkgs   https://search.nixos.org/packages?query=%s
    set searchurls.nixopts   https://search.nixos.org/options?query=%s
    set searchurls.wiki      https://en.wikipedia.org/wiki/Special:Search/%s
    set searchurls.arch      https://wiki.archlinux.org/index.php?search=%s
    set searchurls.yt        https://www.youtube.com/results?search_query=%s
    set searchurls.mdn       https://developer.mozilla.org/en-US/search?q=%s
    set searchurls.crates    https://crates.io/search?q=%s
    set searchurls.pypi      https://pypi.org/search/?q=%s
    set searchurls.npm       https://www.npmjs.com/search?q=%s
    set searchurls.man       https://man.archlinux.org/search?q=%s

    " ===== QUICKMARKS =====
    " Usage: go<key> (current tab), gn<key> (new tab), gw<key> (new window)

    quickmark g https://github.com
    quickmark m https://mail.google.com
    quickmark y https://youtube.com
    quickmark r https://reddit.com
    quickmark n https://search.nixos.org
    quickmark h https://news.ycombinator.com
    quickmark w https://en.wikipedia.org

    " ===== KEY BINDINGS =====

    " --- Navigation ---
    bind j scrollline 5
    bind k scrollline -5
    bind J scrollpage 0.5
    bind K scrollpage -0.5
    bind gg scrollto 0
    bind G  scrollto 100

    " --- Tab management ---
    bind d composite tabprev; tabclose #
    bind D tabclose
    bind u undo
    bind U undo window

    " Tab movement
    bind >> tabmove +1
    bind << tabmove -1

    " --- Hint mode ---
    " f = follow link, F = follow in background tab
    " ;i = view image, ;I = save image
    " ;y = yank link URL, ;Y = yank link text
    bind ;o hint -W tabopen
    bind ;p hint -W open
    bind ;y hint -y
    bind ;Y hint -cF elem => navigator.clipboard.writeText(elem.textContent)

    " --- Buffer (tab) switching ---
    " b opens buffer list (fuzzy search by title/URL)
    bind b fillcmdline buffer
    bind B fillcmdline tabopen

    " --- Clipboard ---
    bind yy clipboard yank
    bind yt clipboard yankshort
    bind yT clipboard yanktitle
    bind p clipboard open
    bind P clipboard tabopen

    " --- History ---
    bind H back
    bind L forward

    " --- Emacs org-protocol integration ---
    " ,c  = capture current page to org-mode inbox
    " ,l  = store org link for current page
    " ,s  = capture selected text to org-mode
    bind ,c composite get_current_url | js -p tri.excmds.open("org-protocol:///capture?template=w&url=" + encodeURIComponent(document.location.href) + "&title=" + encodeURIComponent(document.title) + "&body=" + encodeURIComponent(window.getSelection().toString()))
    bind ,l composite get_current_url | js -p tri.excmds.open("org-protocol:///store-link?url=" + encodeURIComponent(document.location.href) + "&title=" + encodeURIComponent(document.title))

    " --- Open in Emacs (edit text areas with emacsclient) ---
    " Ctrl-i in insert mode opens editor (set above with editorcmd)

    " --- Misc bindings ---
    bind <C-l> focusinput -l           " Focus URL bar like normal Ctrl-L
    bind gs viewsource
    bind gS composite get_current_url | tabopen view-source:
    bind ;t composite hint -pipe a href | tabopen
    bind gc tabduplicate

    " ===== COMMAND ALIASES =====

    command org-capture composite get_current_url | js -p tri.excmds.open("org-protocol:///capture?template=w&url=" + encodeURIComponent(document.location.href) + "&title=" + encodeURIComponent(document.title))

    " ===== SITE-SPECIFIC OVERRIDES =====

    " Disable Tridactyl on sites that need full keyboard
    autocmd DocStart mail.google.com mode ignore
    autocmd DocStart calendar.google.com mode ignore
    autocmd DocStart docs.google.com mode ignore
    autocmd DocStart sheets.google.com mode ignore
    autocmd DocStart slides.google.com mode ignore
    autocmd DocStart drive.google.com mode ignore
    autocmd DocStart meet.google.com mode ignore
    autocmd DocStart discord.com mode ignore
    autocmd DocStart monkeytype.com mode ignore
    autocmd DocStart excalidraw.com mode ignore

    " ===== THEME GUARD =====
    " Re-apply colorscheme on new pages
    autocmd DocStart .* source_quiet

    " vim: set filetype=tridactyl
  '';

  # ================================================================
  # Tridactyl Gruvbox theme CSS (fallback if URL loading fails)
  # ================================================================

  xdg.configFile."tridactyl/themes/gruvbox-dark.css".text = ''
    /* Gruvbox Dark Hard theme for Tridactyl */
    :root {
      --tridactyl-bg:        ${colorScheme.bg};
      --tridactyl-fg:        ${colorScheme.fg};
      --tridactyl-cmdl-bg:   ${colorScheme.bg1};
      --tridactyl-cmdl-fg:   ${colorScheme.fg};
      --tridactyl-url-bg:    ${colorScheme.bg};
      --tridactyl-url-fg:    ${colorScheme.bright_blue};
      --tridactyl-highlight-bg: ${colorScheme.bg2};
      --tridactyl-highlight-fg: ${colorScheme.bright_yellow};
    }

    /* Tridactyl hint styling */
    span.TridactylHint {
      font-family: "JetBrainsMono Nerd Font", monospace !important;
      font-size: 11px !important;
      font-weight: bold !important;
      color: ${colorScheme.bg} !important;
      background: ${colorScheme.bright_yellow} !important;
      border: 1px solid ${colorScheme.yellow} !important;
      border-radius: 4px !important;
      padding: 1px 4px !important;
      text-shadow: none !important;
      box-shadow: 0 2px 6px rgba(0,0,0,0.4) !important;
    }

    /* Command line */
    #command-line-holder {
      background: ${colorScheme.bg} !important;
      border-top: 2px solid ${colorScheme.bg2} !important;
    }

    #tridactyl-input {
      background: ${colorScheme.bg1} !important;
      color: ${colorScheme.fg} !important;
      font-family: "JetBrainsMono Nerd Font", monospace !important;
      caret-color: ${colorScheme.bright_yellow} !important;
      padding: 6px 12px !important;
    }

    /* Completions */
    #completions {
      background: ${colorScheme.bg} !important;
      color: ${colorScheme.fg} !important;
      border-top: 1px solid ${colorScheme.bg2} !important;
      font-family: "JetBrainsMono Nerd Font", monospace !important;
    }

    #completions .focused {
      background: ${colorScheme.bg2} !important;
      color: ${colorScheme.bright_yellow} !important;
    }

    #completions .url {
      color: ${colorScheme.bright_blue} !important;
    }

    #completions .title {
      color: ${colorScheme.bright_aqua} !important;
    }

    /* Status bar */
    :root .TridactylStatusIndicator {
      font-family: "JetBrainsMono Nerd Font", monospace !important;
      font-size: 11px !important;
      font-weight: bold !important;
      padding: 2px 8px !important;
      border-radius: 0 4px 0 0 !important;
    }

    :root .TridactylStatusIndicator[display-host-style="normal"] {
      background: ${colorScheme.blue} !important;
      color: ${colorScheme.bg} !important;
    }

    :root .TridactylStatusIndicator[display-host-style="insert"] {
      background: ${colorScheme.green} !important;
      color: ${colorScheme.bg} !important;
    }

    :root .TridactylStatusIndicator[display-host-style="ignore"] {
      background: ${colorScheme.red} !important;
      color: ${colorScheme.bg} !important;
    }

    :root .TridactylStatusIndicator[display-host-style="visual"] {
      background: ${colorScheme.purple} !important;
      color: ${colorScheme.bg} !important;
    }
  '';

  # ================================================================
  # org-protocol handler for Emacs integration
  # ================================================================
  # Firefox -> org-protocol:// URL -> emacsclient -> org-capture
  # Emacs 29.2+ ships emacsclient.desktop with org-protocol support.
  # This desktop file ensures it works even if the built-in is missing.
  # ================================================================

  xdg.desktopEntries.org-protocol = {
    name = "Org Protocol";
    comment = "Handle org-protocol:// URLs for Emacs org-mode capture";
    exec = "emacsclient %u";
    type = "Application";
    terminal = false;
    categories = [ "System" ];
    mimeType = [ "x-scheme-handler/org-protocol" ];
    noDisplay = true;
  };

  # Register org-protocol handler
  xdg.mimeApps.defaultApplications = {
    "text/html" = "firefox.desktop";
    "x-scheme-handler/http" = "firefox.desktop";
    "x-scheme-handler/https" = "firefox.desktop";
    "x-scheme-handler/about" = "firefox.desktop";
    "x-scheme-handler/unknown" = "firefox.desktop";
    "x-scheme-handler/org-protocol" = "org-protocol.desktop";
  };
}
