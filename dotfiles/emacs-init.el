;; -*- lexical-binding: t; -*-
;; Emacs Configuration - SystemCrafters + DistroTube inspired
;; Gruvbox Dark | Org-mode focused | Daemon-optimized

;; ===== Package Management (use-package + straight.el) =====
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 6))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(straight-use-package 'use-package)
(setq straight-use-package-by-default t)
(setq use-package-always-ensure t)

;; ===== Sane Defaults =====
(setq inhibit-startup-message t
      visible-bell t
      ring-bell-function 'ignore
      use-dialog-box nil
      native-comp-async-report-warnings-errors nil
      create-lockfiles nil
      make-backup-files nil
      auto-save-default t
      tab-width 4
      indent-tabs-mode nil
      scroll-conservatively 101
      scroll-margin 5
      mouse-wheel-scroll-amount '(3 ((shift) . 1))
      mouse-wheel-progressive-speed nil)

(delete-selection-mode 1)
(electric-pair-mode 1)
(global-auto-revert-mode t)
(global-display-line-numbers-mode 1)
(global-visual-line-mode t)
(column-number-mode)
(recentf-mode 1)
(savehist-mode 1)
(save-place-mode 1)
(winner-mode 1)

;; Disable line numbers in certain modes
(dolist (mode '(org-mode-hook term-mode-hook eshell-mode-hook vterm-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

;; Escape quits everything
(global-set-key [escape] 'keyboard-escape-quit)

;; ===== Fonts (SystemCrafters + DistroTube) =====
(set-face-attribute 'default nil
  :font "DankMono Nerd Font"
  :height 120
  :weight 'medium)
(set-face-attribute 'variable-pitch nil
  :font "Iosevka Nerd Font"
  :height 130
  :weight 'medium)
(set-face-attribute 'fixed-pitch nil
  :font "DankMono Nerd Font"
  :height 120
  :weight 'medium)
(set-face-attribute 'font-lock-comment-face nil :slant 'italic)
(set-face-attribute 'font-lock-keyword-face nil :slant 'italic)

(add-to-list 'default-frame-alist '(font . "DankMono Nerd Font-14"))
(setq-default line-spacing 0.12)

;; Zoom
(global-set-key (kbd "C-=") 'text-scale-increase)
(global-set-key (kbd "C--") 'text-scale-decrease)
(global-set-key (kbd "<C-wheel-up>") 'text-scale-increase)
(global-set-key (kbd "<C-wheel-down>") 'text-scale-decrease)

;; ===== Theme - Gruvbox =====
(use-package doom-themes
  :config
  (setq doom-themes-enable-bold t
        doom-themes-enable-italic t)
  (load-theme 'doom-gruvbox t)
  (doom-themes-visual-bell-config)
  (doom-themes-org-config))

;; ===== Modeline =====
(use-package doom-modeline
  :init (doom-modeline-mode 1)
  :config
  (setq doom-modeline-height 35
        doom-modeline-bar-width 5
        doom-modeline-persp-name t
        doom-modeline-persp-icon t))

;; ===== Icons =====
(use-package nerd-icons)
(use-package nerd-icons-dired
  :hook (dired-mode . nerd-icons-dired-mode))

;; ===== Evil Mode (Vim keybindings) =====
(use-package evil
  :init
  (setq evil-want-integration t
        evil-want-keybinding nil
        evil-want-C-u-scroll t
        evil-want-C-i-jump nil
        evil-vsplit-window-right t
        evil-split-window-below t
        evil-undo-system 'undo-redo)
  :config
  (evil-mode 1))

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

;; ===== General (Keybinding framework - DistroTube style) =====
(use-package general
  :config
  (general-evil-setup)

  (general-create-definer leader-keys
    :states '(normal insert visual emacs)
    :keymaps 'override
    :prefix "SPC"
    :global-prefix "M-SPC")

  ;; Top-level
  (leader-keys
    "SPC" '(execute-extended-command :wk "M-x")
    "."   '(find-file :wk "Find file")
    "TAB TAB" '(comment-line :wk "Comment lines"))

  ;; Buffers
  (leader-keys
    "b"   '(:ignore t :wk "Buffers")
    "b b" '(switch-to-buffer :wk "Switch buffer")
    "b k" '(kill-current-buffer :wk "Kill buffer")
    "b n" '(next-buffer :wk "Next buffer")
    "b p" '(previous-buffer :wk "Prev buffer")
    "b i" '(ibuffer :wk "Ibuffer")
    "b r" '(revert-buffer :wk "Reload buffer")
    "b s" '(basic-save-buffer :wk "Save buffer"))

  ;; Files
  (leader-keys
    "f"   '(:ignore t :wk "Files")
    "f f" '(find-file :wk "Find file")
    "f r" '(recentf-open :wk "Recent files")
    "f c" '((lambda () (interactive) (find-file "~/.config/emacs/init.el")) :wk "Edit config")
    "f s" '(save-buffer :wk "Save file"))

  ;; Git
  (leader-keys
    "g"   '(:ignore t :wk "Git")
    "g g" '(magit-status :wk "Magit status")
    "g l" '(magit-log-buffer-file :wk "Buffer log")
    "g b" '(magit-branch-checkout :wk "Checkout branch")
    "g t" '(git-timemachine :wk "Time machine"))

  ;; Help
  (leader-keys
    "h"   '(:ignore t :wk "Help")
    "h f" '(describe-function :wk "Describe function")
    "h v" '(describe-variable :wk "Describe variable")
    "h k" '(describe-key :wk "Describe key")
    "h m" '(describe-mode :wk "Describe mode")
    "h t" '(load-theme :wk "Load theme"))

  ;; Org
  (leader-keys
    "m"   '(:ignore t :wk "Org")
    "m a" '(org-agenda :wk "Agenda")
    "m c" '(org-capture :wk "Capture")
    "m e" '(org-export-dispatch :wk "Export")
    "m t" '(org-todo :wk "Todo")
    "m T" '(org-todo-list :wk "Todo list")
    "m B" '(org-babel-tangle :wk "Babel tangle"))

  ;; Open
  (leader-keys
    "o"   '(:ignore t :wk "Open")
    "o t" '(vterm-toggle :wk "Terminal")
    "o e" '(eshell :wk "Eshell")
    "o d" '(dired-jump :wk "Dired"))

  ;; Projects
  (leader-keys
    "p"   '(projectile-command-map :wk "Projectile"))

  ;; Search
  (leader-keys
    "s"   '(:ignore t :wk "Search")
    "s s" '(consult-line :wk "Search in buffer")
    "s f" '(consult-find :wk "Search files")
    "s g" '(consult-ripgrep :wk "Ripgrep")
    "s r" '(consult-recent-file :wk "Recent files"))

  ;; Toggle
  (leader-keys
    "t"   '(:ignore t :wk "Toggle")
    "t l" '(display-line-numbers-mode :wk "Line numbers")
    "t t" '(visual-line-mode :wk "Truncated lines")
    "t v" '(vterm-toggle :wk "Vterm")
    "t n" '(neotree-toggle :wk "Neotree"))

  ;; Windows
  (leader-keys
    "w"   '(:ignore t :wk "Windows")
    "w c" '(evil-window-delete :wk "Close window")
    "w s" '(evil-window-split :wk "Split horizontal")
    "w v" '(evil-window-vsplit :wk "Split vertical")
    "w h" '(evil-window-left :wk "Window left")
    "w j" '(evil-window-down :wk "Window down")
    "w k" '(evil-window-up :wk "Window up")
    "w l" '(evil-window-right :wk "Window right")
    "w w" '(evil-window-next :wk "Next window")))

;; ===== Which Key =====
(use-package which-key
  :diminish
  :init (which-key-mode)
  :config
  (setq which-key-idle-delay 0.3
        which-key-prefix-prefix "+"
        which-key-sort-order 'which-key-key-order-alpha))

;; ===== Completion (Vertico + Orderless + Consult + Marginalia) =====
(use-package vertico
  :init (vertico-mode)
  :config
  (setq vertico-cycle t
        vertico-count 15))

(use-package orderless
  :config
  (setq completion-styles '(orderless basic)
        completion-category-overrides '((file (styles basic partial-completion)))))

(use-package marginalia
  :init (marginalia-mode))

(use-package consult
  :bind (("C-s" . consult-line)
         ("C-x b" . consult-buffer)))

(use-package corfu
  :init (global-corfu-mode)
  :config
  (setq corfu-auto t
        corfu-auto-delay 0.2
        corfu-auto-prefix 2
        corfu-cycle t
        corfu-preselect 'prompt))

;; ===== Org Mode =====
(use-package org
  :straight (:type built-in)
  :config
  (setq org-directory "~/org"
        org-agenda-files '("~/org/agenda.org" "~/org/todos.org" "~/org/habits.org")
        org-default-notes-file "~/org/inbox.org"
        org-ellipsis " ▾"
        org-log-done 'time
        org-log-into-drawer t
        org-return-follows-link t
        org-startup-indented t
        org-startup-with-inline-images t
        org-image-actual-width '(500)
        org-hide-emphasis-markers t
        org-src-fontify-natively t
        org-src-tab-acts-natively t
        org-edit-src-content-indentation 0
        org-confirm-babel-evaluate nil
        org-todo-keywords '((sequence "TODO(t)" "NEXT(n)" "IN-PROGRESS(i)" "|" "DONE(d)" "CANCELLED(c)"))
        org-todo-keyword-faces '(("TODO" . (:foreground "#ff5050" :weight bold))
                                  ("NEXT" . (:foreground "#ffd040" :weight bold))
                                  ("IN-PROGRESS" . (:foreground "#60c0ff" :weight bold))
                                  ("DONE" . (:foreground "#d0f020" :weight bold))
                                  ("CANCELLED" . (:foreground "#a09080" :weight bold)))))

;; Org capture templates
(setq org-capture-templates
      '(("t" "Todo" entry (file+headline "~/org/todos.org" "Inbox")
         "* TODO %?\n  %i\n  %a" :empty-lines 1)
        ("n" "Note" entry (file+headline "~/org/notes.org" "Notes")
         "* %?\n  %i\n  %a" :empty-lines 1)
        ("j" "Journal" entry (file+datetree "~/org/journal.org")
         "* %?\nEntered on %U\n  %i\n  %a" :empty-lines 1)
        ("i" "Idea" entry (file+headline "~/org/ideas.org" "Ideas")
         "* %?\n  %i" :empty-lines 1)))

;; Org directory structure
(dolist (file '("~/org" "~/org/roam"))
  (unless (file-exists-p file) (make-directory file t)))
(dolist (file '("~/org/todos.org" "~/org/notes.org" "~/org/journal.org"
                "~/org/ideas.org" "~/org/agenda.org" "~/org/inbox.org"
                "~/org/habits.org"))
  (unless (file-exists-p file) (write-region "" nil file)))

;; Org Bullets
(use-package org-bullets
  :hook (org-mode . org-bullets-mode))

;; Org headers scaling
(custom-set-faces
 '(org-level-1 ((t (:inherit outline-1 :height 1.7))))
 '(org-level-2 ((t (:inherit outline-2 :height 1.6))))
 '(org-level-3 ((t (:inherit outline-3 :height 1.5))))
 '(org-level-4 ((t (:inherit outline-4 :height 1.4))))
 '(org-level-5 ((t (:inherit outline-5 :height 1.3)))))

;; Table of contents
(use-package toc-org
  :commands toc-org-enable
  :hook (org-mode . toc-org-enable))

;; Org-tempo for quick blocks
(require 'org-tempo)

;; Org-roam (Zettelkasten)
(use-package org-roam
  :config
  (setq org-roam-directory "~/org/roam"
        org-roam-completion-everywhere t)
  (org-roam-db-autosync-mode))

;; ===== Git =====
(use-package magit)
(use-package git-timemachine
  :hook (evil-normalize-keymaps . git-timemachine-hook)
  :config
  (evil-define-key 'normal git-timemachine-mode-map (kbd "C-j") 'git-timemachine-show-previous-revision)
  (evil-define-key 'normal git-timemachine-mode-map (kbd "C-k") 'git-timemachine-show-next-revision))

;; ===== Project Management =====
(use-package projectile
  :diminish
  :config
  (projectile-mode 1)
  (setq projectile-project-search-path '("~/dev" "~/fedorasetup")))

;; ===== File Tree =====
(use-package neotree
  :config
  (setq neo-smart-open t
        neo-show-hidden-files t
        neo-window-width 40
        neo-window-fixed-size nil))

;; ===== Terminal =====
(use-package vterm
  :config
  (setq vterm-max-scrollback 10000))

(use-package vterm-toggle
  :after vterm
  :config
  (setq vterm-toggle-fullscreen-p nil)
  (add-to-list 'display-buffer-alist
               '((lambda (buffer-or-name _)
                   (let ((buffer (get-buffer buffer-or-name)))
                     (with-current-buffer buffer
                       (or (equal major-mode 'vterm-mode)
                           (string-prefix-p vterm-buffer-name (buffer-name buffer))))))
                 (display-buffer-reuse-window display-buffer-at-bottom)
                 (reusable-frames . visible)
                 (window-height . 0.3))))

;; ===== Programming =====
(use-package flycheck
  :diminish
  :init (global-flycheck-mode))

(use-package rainbow-delimiters
  :hook ((emacs-lisp-mode . rainbow-delimiters-mode)
         (prog-mode . rainbow-delimiters-mode)))

(use-package rainbow-mode
  :diminish
  :hook (org-mode prog-mode))

(use-package hl-todo
  :hook ((org-mode . hl-todo-mode)
         (prog-mode . hl-todo-mode))
  :config
  (setq hl-todo-highlight-punctuation ":"
        hl-todo-keyword-faces
        '(("TODO" warning bold)
          ("FIXME" error bold)
          ("HACK" font-lock-constant-face bold)
          ("NOTE" success bold)
          ("DEPRECATED" font-lock-doc-face bold))))

;; ===== Perspectives (Workspaces) =====
(use-package perspective
  :custom
  (persp-mode-prefix-key (kbd "C-c M-p"))
  :init (persp-mode)
  :config
  (setq persp-state-default-file "~/.config/emacs/sessions"))

(add-hook 'kill-emacs-hook #'persp-state-save)

;; ===== AI Integration (gptel) =====
(use-package gptel
  :config
  (setq gptel-model 'gemini-2.0-flash
        gptel-backend (gptel-make-gemini "Gemini"
                        :key (lambda () (getenv "GEMINI_API_KEY"))
                        :stream t))
  ;; Also configure Claude as an option
  (gptel-make-anthropic "Claude"
    :key (lambda () (getenv "ANTHROPIC_API_KEY"))
    :stream t
    :models '(claude-sonnet-4-5-20250929))
  :bind
  (("C-c g" . gptel)
   ("C-c G" . gptel-menu)
   ("C-c RET" . gptel-send)))

;; ===== Quality of Life =====
(use-package diminish)

(use-package eshell-toggle
  :custom
  (eshell-toggle-size-fraction 3)
  (eshell-toggle-use-projectile-root t)
  (eshell-toggle-run-command nil))

(use-package sudo-edit)

;; ===== Daemon frame optimization =====
(when (daemonp)
  (add-hook 'after-make-frame-functions
            (lambda (frame)
              (with-selected-frame frame
                (load-theme 'doom-gruvbox t)))))

(provide 'init)
