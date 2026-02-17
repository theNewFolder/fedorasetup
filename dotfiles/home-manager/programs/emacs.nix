# Emacs configuration
# Informed by System Crafters (daviwil) and Distrotube (dwt1)
# Adapted for suckless philosophy: minimal, practical, efficient

{ config, pkgs, ... }:

{
  programs.emacs = {
    enable = true;
    package = pkgs.emacs30-pgtk;

    extraPackages = epkgs: with epkgs; [
      # Evil (Vim emulation)
      evil
      evil-collection
      evil-surround
      evil-commentary

      # Org-mode
      org
      org-roam
      org-roam-ui
      org-bullets

      # Completion (Vertico stack - modern, lightweight)
      vertico
      consult
      marginalia
      orderless
      corfu
      cape

      # Git
      magit
      git-timemachine

      # UI
      gruvbox-theme
      doom-modeline
      all-the-icons
      rainbow-delimiters
      which-key
      diminish
      hl-todo

      # Languages
      nix-mode
      markdown-mode
      yaml-mode
      json-mode

      # AI tools
      gptel

      # Utilities
      helpful
      sudo-edit
    ];
  };

  # Emacs daemon service
  services.emacs = {
    enable = true;
    client.enable = true;
    defaultEditor = true;
    socketActivation.enable = true;
  };

  home.file.".emacs.d/init.el".text = ''
    ;;; init.el --- Emacs configuration -*- lexical-binding: t -*-

    ;; ===== Performance (System Crafters pattern) =====
    (setq gc-cons-threshold (* 50 1000 1000))
    (setq read-process-output-max (* 1024 1024))

    (defun my/display-startup-time ()
      (message "Emacs loaded in %s with %d garbage collections."
               (format "%.2f seconds"
                       (float-time (time-subtract after-init-time before-init-time)))
               gcs-done))
    (add-hook 'emacs-startup-hook #'my/display-startup-time)

    ;; Package setup (packages come from Nix, not ELPA)
    (require 'package)
    (setq package-enable-at-startup nil)

    ;; ===== Evil Mode =====
    (setq evil-want-keybinding nil)  ; MUST be set before loading evil
    (setq evil-undo-system 'undo-redo)
    (setq evil-vsplit-window-right t)
    (setq evil-split-window-below t)
    (require 'evil)
    (evil-mode 1)

    (require 'evil-collection)
    (evil-collection-init)
    (require 'evil-surround)
    (global-evil-surround-mode 1)
    (require 'evil-commentary)
    (evil-commentary-mode)

    ;; Free SPC/RET/TAB from evil-motion for leader key
    (define-key evil-motion-state-map (kbd "SPC") nil)
    (define-key evil-motion-state-map (kbd "RET") nil)
    (define-key evil-motion-state-map (kbd "TAB") nil)

    ;; ===== UI =====
    (load-theme 'gruvbox-dark-hard t)
    (require 'doom-modeline)
    (doom-modeline-mode 1)
    (setq doom-modeline-height 30)
    (setq doom-modeline-bar-width 4)

    ;; Clean UI
    (menu-bar-mode -1)
    (tool-bar-mode -1)
    (scroll-bar-mode -1)
    (setq inhibit-startup-screen t)
    (setq initial-scratch-message "")

    ;; Line numbers (disable in certain modes - DT/SC pattern)
    (global-display-line-numbers-mode 1)
    (setq display-line-numbers-type 'relative)
    (dolist (mode '(org-mode-hook
                    term-mode-hook
                    eshell-mode-hook
                    vterm-mode-hook))
      (add-hook mode (lambda () (display-line-numbers-mode 0))))

    ;; Font (DT pattern - italic comments)
    (set-face-attribute 'default nil :font "JetBrainsMono Nerd Font" :height 120)
    (set-face-attribute 'variable-pitch nil :font "Noto Sans" :height 130 :weight 'regular)
    (set-face-attribute 'fixed-pitch nil :font "JetBrainsMono Nerd Font" :height 120)
    (set-face-attribute 'font-lock-comment-face nil :slant 'italic)
    (set-face-attribute 'font-lock-keyword-face nil :slant 'italic)
    (setq-default line-spacing 0.12)

    ;; Zoom keybindings (DT)
    (global-set-key (kbd "C-=") 'text-scale-increase)
    (global-set-key (kbd "C--") 'text-scale-decrease)
    (global-set-key (kbd "<C-wheel-up>") 'text-scale-increase)
    (global-set-key (kbd "<C-wheel-down>") 'text-scale-decrease)

    ;; Transparency
    (add-to-list 'default-frame-alist '(alpha-background . 95))

    ;; Rainbow delimiters
    (require 'rainbow-delimiters)
    (add-hook 'prog-mode-hook 'rainbow-delimiters-mode)

    ;; Highlight TODO/FIXME/HACK (DT)
    (require 'hl-todo)
    (add-hook 'prog-mode-hook 'hl-todo-mode)
    (add-hook 'org-mode-hook 'hl-todo-mode)
    (setq hl-todo-keyword-faces
          '(("TODO"       warning bold)
            ("FIXME"      error bold)
            ("HACK"       font-lock-constant-face bold)
            ("NOTE"       success bold)
            ("DEPRECATED" font-lock-doc-face bold)))

    ;; Which-key
    (require 'which-key)
    (which-key-mode)
    (setq which-key-idle-delay 0.5)
    (setq which-key-separator " -> ")
    (require 'diminish)

    ;; ===== Sane Defaults (DT) =====
    (delete-selection-mode 1)
    (electric-pair-mode 1)
    (global-auto-revert-mode t)
    (global-visual-line-mode t)
    (global-set-key [escape] 'keyboard-escape-quit)

    ;; ===== Completion (Vertico stack - SC recommended) =====
    (require 'vertico)
    (vertico-mode)
    (setq vertico-cycle t)
    (define-key vertico-map (kbd "C-j") 'vertico-next)
    (define-key vertico-map (kbd "C-k") 'vertico-previous)

    (savehist-mode)

    (require 'marginalia)
    (marginalia-mode)

    (require 'orderless)
    (setq completion-styles '(orderless basic))
    (setq completion-category-overrides
          '((file (styles basic partial-completion))))

    (require 'consult)
    (global-set-key (kbd "C-s") 'consult-line)
    (global-set-key (kbd "C-x b") 'consult-buffer)

    (require 'corfu)
    (global-corfu-mode)
    (setq corfu-auto t)
    (setq corfu-auto-delay 0.1)
    (setq corfu-auto-prefix 2)

    ;; ===== Org Mode =====
    (require 'org)
    (setq org-directory "~/org/")
    (setq org-default-notes-file (concat org-directory "notes.org"))
    (setq org-agenda-files '("~/org/"))
    (setq org-ellipsis " ▾")
    (setq org-agenda-start-with-log-mode t)

    ;; Pretty headings (DT)
    (require 'org-bullets)
    (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))
    (add-hook 'org-mode-hook 'org-indent-mode)
    (add-hook 'org-mode-hook 'variable-pitch-mode)
    (add-hook 'org-mode-hook 'visual-line-mode)

    ;; Org heading sizes (DT pattern)
    (custom-set-faces
     '(org-level-1 ((t (:inherit outline-1 :height 1.5))))
     '(org-level-2 ((t (:inherit outline-2 :height 1.3))))
     '(org-level-3 ((t (:inherit outline-3 :height 1.2))))
     '(org-level-4 ((t (:inherit outline-4 :height 1.1)))))

    ;; Source block templates (SC - org-tempo)
    (require 'org-tempo)
    (add-to-list 'org-structure-template-alist '("sh" . "src shell"))
    (add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp"))
    (add-to-list 'org-structure-template-alist '("py" . "src python"))
    (add-to-list 'org-structure-template-alist '("nx" . "src nix"))

    ;; Fix electric-pair in org-tempo (DT fix)
    (add-hook 'org-mode-hook (lambda ()
      (setq-local electric-pair-inhibit-predicate
        (lambda (c) (if (char-equal c ?<) t
          (funcall (default-value 'electric-pair-inhibit-predicate) c))))))

    ;; TODO states (SC two-sequence pattern)
    (setq org-todo-keywords
          '((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d!)")
            (sequence "WAITING(w@)" "HOLD(h)" "|" "CANCELLED(c@)")))
    (setq org-todo-keyword-faces
          '(("TODO"      . (:foreground "#fb4934" :weight bold))
            ("NEXT"      . (:foreground "#fabd2f" :weight bold))
            ("WAITING"   . (:foreground "#83a598" :weight bold))
            ("HOLD"      . (:foreground "#d3869b" :weight bold))
            ("DONE"      . (:foreground "#b8bb26" :weight bold))
            ("CANCELLED" . (:foreground "#928374" :weight bold))))

    ;; Tags (SC pattern)
    (setq org-tag-alist
          '((:startgroup) (:endgroup)
            ("@work" . ?w) ("@home" . ?h) ("@errand" . ?e)
            ("note" . ?n) ("idea" . ?i) ("project" . ?p)))

    ;; Log into drawer
    (setq org-log-done 'time)
    (setq org-log-into-drawer t)

    ;; Refile (SC - auto-save after refile)
    (setq org-refile-targets '((org-agenda-files :maxlevel . 2)))
    (setq org-refile-use-outline-path 'file)
    (setq org-outline-path-complete-in-steps nil)
    (advice-add 'org-refile :after 'org-save-all-org-buffers)

    ;; Capture templates
    (setq org-capture-templates
          '(("t" "Task" entry (file+headline "~/org/tasks.org" "Active")
             "* TODO %?\n:PROPERTIES:\n:CREATED: %U\n:END:\n" :empty-lines 1)
            ("n" "Note" entry (file+headline "~/org/notes.org" "Fleeting Notes")
             "* %?\n:PROPERTIES:\n:CREATED: %U\n:END:\n" :empty-lines 1)
            ("i" "Inbox" entry (file+headline "~/org/inbox.org" "Inbox")
             "* %?\n%U\n" :empty-lines 1)
            ("j" "Journal" entry (file+olp+datetree "~/org/journal.org")
             "* %<%H:%M> %?\n" :empty-lines 1)
            ("p" "Project" entry (file+headline "~/org/projects.org" "Active Projects")
             "* %? [/]\n:PROPERTIES:\n:CREATED: %U\n:END:\n** TODO " :empty-lines 1)
            ("l" "Link" entry (file+headline "~/org/notes.org" "Reference")
             "* %? :link:\n:PROPERTIES:\n:CREATED: %U\n:URL: %^{URL}\n:END:\n" :empty-lines 1)))

    ;; Custom agenda views (SC Dashboard pattern)
    (setq org-agenda-custom-commands
          '(("d" "Dashboard"
             ((agenda "" ((org-deadline-warning-days 7)
                          (org-agenda-span 'day)))
              (todo "NEXT" ((org-agenda-overriding-header "Next Actions")))
              (todo "WAITING" ((org-agenda-overriding-header "Waiting")))
              (tags-todo "inbox" ((org-agenda-overriding-header "Inbox - Process")))))
            ("w" "Weekly Review"
             ((agenda "" ((org-agenda-span 'week)))
              (todo "DONE" ((org-agenda-overriding-header "Completed")))
              (todo "TODO" ((org-agenda-overriding-header "All Open Tasks")))))
            ("n" "Next Actions" todo "NEXT")))

    ;; Habits
    (require 'org-habit)
    (add-to-list 'org-modules 'org-habit)
    (setq org-habit-graph-column 60)

    ;; Org-roam
    (require 'org-roam)
    (setq org-roam-directory "~/org/roam/")
    (setq org-roam-database-connector 'sqlite-builtin)
    (setq org-roam-dailies-directory "daily/")
    (setq org-roam-dailies-capture-templates
          '(("d" "default" entry "* %?\n%U\n"
             :target (file+head "%<%Y-%m-%d>.org" "#+title: %<%Y-%m-%d %A>\n\n"))))
    (org-roam-db-autosync-mode)

    ;; Org keybindings
    (global-set-key (kbd "C-c a") 'org-agenda)
    (global-set-key (kbd "C-c c") 'org-capture)
    (global-set-key (kbd "C-c l") 'org-store-link)
    (global-set-key (kbd "C-c n f") 'org-roam-node-find)
    (global-set-key (kbd "C-c n i") 'org-roam-node-insert)
    (global-set-key (kbd "C-c n c") 'org-roam-capture)
    (global-set-key (kbd "C-c n b") 'org-roam-buffer-toggle)
    (global-set-key (kbd "C-c n d") 'org-roam-dailies-goto-today)

    ;; ===== Magit =====
    (require 'magit)
    (global-set-key (kbd "C-x g") 'magit-status)

    ;; Git time machine (DT)
    (require 'git-timemachine)

    ;; ===== Helpful (better help buffers) =====
    (require 'helpful)
    (global-set-key (kbd "C-h f") 'helpful-callable)
    (global-set-key (kbd "C-h v") 'helpful-variable)
    (global-set-key (kbd "C-h k") 'helpful-key)

    ;; ===== Which-key leader hints =====
    (which-key-add-key-based-replacements
      "C-c a" "agenda"
      "C-c c" "capture"
      "C-c n" "org-roam"
      "C-c g" "ai-send"
      "C-x g" "magit")

    ;; ===== AI (gptel) =====
    (require 'gptel)

    (defun load-api-key (filename)
      "Load API key from ~/.secrets/FILENAME."
      (let ((file-path (expand-file-name (concat "~/.secrets/" filename))))
        (when (file-exists-p file-path)
          (with-temp-buffer
            (insert-file-contents file-path)
            (string-trim (buffer-string))))))

    (when-let ((claude-key (load-api-key "claude-api-key.txt")))
      (setq-default gptel-backend
        (gptel-make-anthropic "Claude"
          :stream t
          :key claude-key))
      (setq-default gptel-model "claude-sonnet-4-5"))

    (when-let ((gemini-key (load-api-key "gemini-api-key.txt")))
      (gptel-make-gemini "Gemini"
        :key gemini-key
        :stream t
        :models '(gemini-2.0-flash-exp gemini-1.5-pro)))

    (global-set-key (kbd "C-c g") 'gptel-send)
    (global-set-key (kbd "C-c G") 'gptel-menu)

    ;; ===== Evil Leader Keybindings =====
    (evil-set-leader 'normal (kbd "SPC"))

    ;; Files
    (evil-define-key 'normal 'global (kbd "<leader>ff") 'find-file)
    (evil-define-key 'normal 'global (kbd "<leader>fr") 'consult-recent-file)
    (evil-define-key 'normal 'global (kbd "<leader>fs") 'save-buffer)
    (evil-define-key 'normal 'global (kbd "<leader>fg") 'consult-ripgrep)

    ;; Buffers
    (evil-define-key 'normal 'global (kbd "<leader>bb") 'consult-buffer)
    (evil-define-key 'normal 'global (kbd "<leader>bd") 'kill-current-buffer)
    (evil-define-key 'normal 'global (kbd "<leader>bn") 'next-buffer)
    (evil-define-key 'normal 'global (kbd "<leader>bp") 'previous-buffer)

    ;; Org
    (evil-define-key 'normal 'global (kbd "<leader>oa") 'org-agenda)
    (evil-define-key 'normal 'global (kbd "<leader>oc") 'org-capture)
    (evil-define-key 'normal 'global (kbd "<leader>od") (lambda () (interactive) (org-agenda nil "d")))
    (evil-define-key 'normal 'global (kbd "<leader>or") 'org-roam-node-find)
    (evil-define-key 'normal 'global (kbd "<leader>on") 'org-roam-dailies-goto-today)

    ;; Git
    (evil-define-key 'normal 'global (kbd "<leader>gg") 'magit-status)
    (evil-define-key 'normal 'global (kbd "<leader>gt") 'git-timemachine)

    ;; Evaluate (DT pattern)
    (evil-define-key 'normal 'global (kbd "<leader>eb") 'eval-buffer)
    (evil-define-key 'normal 'global (kbd "<leader>ee") 'eval-expression)
    (evil-define-key 'normal 'global (kbd "<leader>el") 'eval-last-sexp)
    (evil-define-key 'visual 'global (kbd "<leader>er") 'eval-region)

    ;; AI
    (evil-define-key 'normal 'global (kbd "<leader>ai") 'gptel)
    (evil-define-key 'normal 'global (kbd "<leader>as") 'gptel-send)
    (evil-define-key 'visual 'global (kbd "<leader>as") 'gptel-send)
    (evil-define-key 'normal 'global (kbd "<leader>am") 'gptel-menu)

    ;; Toggle (DT pattern)
    (evil-define-key 'normal 'global (kbd "<leader>tl") 'display-line-numbers-mode)
    (evil-define-key 'normal 'global (kbd "<leader>tt") 'visual-line-mode)
    (evil-define-key 'normal 'global (kbd "<leader>tw") 'whitespace-mode)

    ;; Windows
    (evil-define-key 'normal 'global (kbd "<leader>wv") 'evil-window-vsplit)
    (evil-define-key 'normal 'global (kbd "<leader>ws") 'evil-window-split)
    (evil-define-key 'normal 'global (kbd "<leader>wc") 'evil-window-delete)
    (evil-define-key 'normal 'global (kbd "<leader>wh") 'evil-window-left)
    (evil-define-key 'normal 'global (kbd "<leader>wj") 'evil-window-down)
    (evil-define-key 'normal 'global (kbd "<leader>wk") 'evil-window-up)
    (evil-define-key 'normal 'global (kbd "<leader>wl") 'evil-window-right)

    ;; Quick actions
    (evil-define-key 'normal 'global (kbd "<leader>SPC") 'execute-extended-command)
    (evil-define-key 'normal 'global (kbd "<leader>.") 'find-file)
    (evil-define-key 'normal 'global (kbd "<leader>/") 'consult-ripgrep)

    ;; ===== Misc =====
    (setq make-backup-files nil)
    (setq auto-save-default nil)
    (setq create-lockfiles nil)
    (setq custom-file (concat user-emacs-directory "custom.el"))
    (when (file-exists-p custom-file)
      (load custom-file t))

    ;; Reset GC after init (SC pattern)
    (setq gc-cons-threshold (* 2 1000 1000))

    ;;; init.el ends here
  '';

  # Org directories
  home.file."org/.keep".text = "";
  home.file."org/roam/.keep".text = "";
}
