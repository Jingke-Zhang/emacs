;;; framework-appearance.el --- configure appreance -*- lexical-binding: t -*-
;;; Commentary:

;;; Code:
;; Font
(set-frame-font "CodeNewRoman Nerd Font Mono-15" nil t)

;; Provide icons
(use-package nerd-icons
  :ensure t)

;; Some display settings
(unless (equal "Battery status not available"
               (battery))
  (display-battery-mode 1))
(tool-bar-mode -1)
(when (display-graphic-p) (toggle-scroll-bar -1))

;; Themes
(use-package doom-themes
  :ensure t
  :custom
  ;; Global settings (defaults)
  (doom-themes-enable-bold t)   ; if nil, bold is universally disabled
  (doom-themes-enable-italic t) ; if nil, italics is universally disabled
  ;; for treemacs users
  (doom-themes-treemacs-theme "doom-atom") ; use "doom-colors" for less minimal icon theme
  
  :config
  (load-theme 'doom-tomorrow-day t)

  ;; Enable flashing mode-line on errors
  (doom-themes-visual-bell-config)
  ;; Enable custom neotree theme (nerd-icons must be installed!)
  (doom-themes-neotree-config)
  ;; or for treemacs users
  (doom-themes-treemacs-config)
  ;; Corrects (and improves) org-mode's native fontification.
  (doom-themes-org-config))

;; Modeline
(use-package doom-modeline
  :ensure t
  :init
  (setq doom-modeline-support-imenu t
	doom-modeline-height 25
	doom-modeline-hud nil
	doom-modeline-total-line-number t
	doom-modeline-github t)
  (doom-modeline-mode 1))

;; Rainbow delimiters
(use-package rainbow-delimiters
 :ensure t
 :hook (prog-mode . rainbow-delimiters-mode))

;; Dashboard
(use-package dashboard
  :ensure t
  :init
  (setq dashboard-startup-banner (expand-file-name "attachment/emacs-e-logo.png" user-emacs-directory)
	dashboard-items '((recents   . 5)
                          (bookmarks . 5)
                          (projects  . 5))
	dashboard-item-shortcuts '((recents   . "r")
                                   (bookmarks . "m")
                                   (projects  . "p")))
  :config
  (add-hook 'elpaca-after-init-hook #'dashboard-insert-startupify-lists)
  (add-hook 'elpaca-after-init-hook #'dashboard-initialize)
  (dashboard-setup-startup-hook)
  (setq dashboard-navigation-cycle t
	dashboard-display-icons-p t
	dashboard-icon-type 'nerd-icons
	dashboard-set-heading-icons t
	dashboard-set-file-icons t)
  )

(provide 'framework-appearance)
;;; framework-appearance.el ends here
