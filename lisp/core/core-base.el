;;; core-base.el --- load the full configuration -*- lexical-binding: t -*-
;;; Commentary:

;;; Code:
;; Coding system
(set-language-environment "UTF-8")
(prefer-coding-system 'utf-8)
(when (eq system-type 'darwin)
  (set-clipboard-coding-system 'utf-8))

(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)

(when (and (eq system-type 'darwin) (display-graphic-p))
  (setq mac-option-modifier 'hyper
        mac-command-modifier 'meta))

;; Others
(setq use-short-answers t)
(setq confirm-kill-emacs #'yes-or-no-p
      inhibit-startup-message t
      make-backup-files nil
      display-line-numbers-type t
      find-file-visit-truename t
      display-line-numbers-width 4
      )
(add-hook 'prog-mode-hook #'electric-pair-mode)
(add-hook 'prog-mode-hook #'show-paren-mode)
(column-number-mode t)
(global-auto-revert-mode t)
(delete-selection-mode t)
(global-display-line-numbers-mode 1)

(savehist-mode 1)

(setq scroll-margin 4
      scroll-step 1
      scroll-conservatively 10000
      scroll-preserve-screen-position 0)

;; Allow emacs in terminal mode share macOS's pasteboard
(when (and (eq system-type 'darwin) (not (display-graphic-p)))
  (defun copy-from-osx ()
    (shell-command-to-string "pbpaste"))
  (defun paste-to-osx (text &optional push)
    (let ((process-connection-type nil))
      (let ((proc (start-process "pbcopy" "*Messages*" "pbcopy")))
        (process-send-string proc text)
        (process-send-eof proc))))
  (setq interprogram-cut-function 'paste-to-osx)
  (setq interprogram-paste-function 'copy-from-osx))

(provide 'core-base)
;;; core-base.el ends here
