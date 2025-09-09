;;; init-basic.el --- load the full configuration -*- lexical-binding: t -*-
;;; Commentary:

;;; Code:
;; Coding system
(set-language-environment "utf-8")
(set-default-coding-systems 'utf-8)
(set-buffer-file-coding-system 'utf-8-unix)
(set-clipboard-coding-system 'utf-8-unix)
(set-file-name-coding-system 'utf-8-unix)
(set-keyboard-coding-system 'utf-8-unix)
(set-next-selection-coding-system 'utf-8-unix)
(set-selection-coding-system 'utf-8-unix)
(set-terminal-coding-system 'utf-8-unix)
(setq locale-coding-system 'utf-8)
(prefer-coding-system 'utf-8)

;; Others
(setq confirm-kill-emacs #'yes-or-no-p
      inhibit-startup-message t
      make-backup-files nil
      display-line-numbers-type 'relative
      find-file-visit-truename t
      display-line-numbers-width 4
      )
(add-hook 'prog-mode-hook #'electric-pair-mode)
(add-hook 'prog-mode-hook #'show-paren-mode)
(add-hook 'prog-mode-hook #'hs-minor-mode)
(column-number-mode t)
(global-auto-revert-mode t)
(delete-selection-mode t)
(global-display-line-numbers-mode 1)

(savehist-mode 1)

;; (setq scroll-margin 4
;;       scroll-step 1
;;       scroll-conservatively 10000
;;       scroll-preserve-screen-position 0)

(provide 'init-basic)
;;; init-basic.el ends here
