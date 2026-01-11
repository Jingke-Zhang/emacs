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

;; ;; Better display in terminal mode
;; (defun my/apply-transparent-background ()
;;   (unless (display-graphic-p)
;;     (set-face-background 'default "unspecified-bg" (selected-frame))))

;; (add-hook 'window-setup-hook 'my/apply-transparent-background)
;; (add-hook 'after-make-frame-functions
;;           (lambda (frame)
;;             (with-selected-frame frame
;;               (my/apply-transparent-background))))

(provide 'framework-appearance)
;;; framework-appearance.el ends here
