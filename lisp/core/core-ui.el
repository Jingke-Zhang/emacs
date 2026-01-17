;;; core-ui.el --- configure ui -*- lexical-binding: t -*-
;;; Commentary:

;;; Code:
;; Font
(set-face-attribute 'default nil
                    :font "CodeNewRoman Nerd Font Mono"
                    :height 150)

;; Provide icons
(use-package nerd-icons
  :ensure t)

;; Use nerd-icons for dired
(use-package nerd-icons-dired
  :ensure t
  :hook
  (dired-mode . nerd-icons-dired-mode))

;; Some display settings
(unless (equal "Battery status not available"
               (battery))
  (display-battery-mode 1))
(tool-bar-mode -1)
(when (display-graphic-p) (toggle-scroll-bar -1))
(setq inhibit-startup-screen t)
(global-hl-line-mode 1)

;; Themes
(use-package catppuccin-theme
  :ensure t
  :config
  (setq catppuccin-flavor 'frappe)
  (load-theme 'catppuccin t)

  (defun my/transparent-emacs ()
    (unless (display-graphic-p)
      (set-face-background 'default "unspecified-bg")
      (set-face-background 'line-number "unspecified-bg")
      (set-face-background 'fringe "unspecified-bg")))

  (add-hook 'window-setup-hook #'my/transparent-emacs)
  (add-hook 'after-make-frame-functions
            (lambda (frame)
              (with-selected-frame frame
                (my/transparent-emacs)))))


;; Modeline
(use-package doom-modeline
  :ensure t
  :init
  (setq doom-modeline-support-imenu t
	    doom-modeline-height 25
	    doom-modeline-hud nil
        doom-modeline-project-detection 'project
	    doom-modeline-total-line-number t)
  (doom-modeline-mode 1))

;; Rainbow delimiters
(use-package rainbow-delimiters
  :ensure t
  :defer t
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package paren
  :ensure nil
  :config
  (setq show-paren-delay 0
        show-paren-style 'parenthesis))

;; Dashboard 
(use-package dashboard
  :ensure t
  :demand t
  :init
  (setq dashboard-startup-banner (expand-file-name "attachment/emacs-e-logo.png" user-emacs-directory)
        dashboard-items '((recents   . 5)
                          (bookmarks . 5)
                          (projects  . 5))
        dashboard-item-shortcuts '((recents   . "r")
                                   (bookmarks . "m")
                                   (projects  . "p")))
  :config
  (dashboard-setup-startup-hook)
  (setq dashboard-navigation-cycle t
        dashboard-display-icons-p t
        dashboard-icon-type 'nerd-icons
        dashboard-set-heading-icons t
        dashboard-set-file-icons t)
  :general
  (:keymaps 'dashboard-mode-map
            "n" 'next-line
            "p" 'previous-line
            "f" 'forward-char
            "b" 'backward-char
            "<return>" 'dashboard-return
            "g"        'dashboard-refresh-buffer
            "q"        'quit-window))

(use-package tab-bar
  :ensure nil
  :init
  (setq tab-bar-show 1)
  :config
  (setq tab-bar-close-button-show nil
        tab-bar-new-button-show nil
        tab-bar-separator "  ")
  
  (set-face-attribute 'tab-bar nil :background (face-background 'default) :box nil)
  (set-face-attribute 'tab-bar-tab nil :background (face-foreground 'font-lock-function-name-face) :foreground (face-background 'default) :box nil)
  (set-face-attribute 'tab-bar-tab-inactive nil :background (face-background 'mode-line-inactive) :foreground (face-foreground 'default) :box nil)
  (tab-bar-mode 1))


(provide 'core-ui)
;;; core-ui.el ends here
