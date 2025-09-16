;;; init-utils.el --- setup some useful utils -*- lexical-binding: t -*-
;;; Commentary:

;;; Code:
(use-package ace-window
  :ensure t
  :bind (("C-x o" . 'ace-window)))

(use-package mwim
  :ensure t
  :bind
  ("C-a" . mwim-beginning-of-code-or-line)
  ("C-e" . mwim-end-of-code-or-line))

(use-package undo-tree
  :ensure t
  :init (global-undo-tree-mode)
  :custom
  (undo-tree-auto-save-history nil))

(use-package avy
  :ensure t
  :bind
  (("C-;" . avy-goto-char)
   ("C-'" . avy-goto-char-timer)
   ("M-g g" . avy-goto-line)))

(use-package exec-path-from-shell
  :if (memq window-system '(mac ns))
  :ensure t
  :init
  (setq exec-path-from-shell-arguments nil)
  (exec-path-from-shell-initialize))

(use-package vterm
  :ensure t
  :init
  (require 'module-vterm-toggle)
  :config
  (setq vterm-kill-buffer-on-exit t
	vterm-max-scrollback 5000)
  :general
  ;; (:prefix "C-x t"
  ;; 	   "t" 'vterm-toggle
  ;; 	   "T" 'vterm-toggle-insert-cd))
  (my/toggle-def
    "t" 'vterm-toggle
    "T" 'vterm-toggle-insert-cd))

(use-package pdf-tools
  :ensure t
  :defer t)

(provide 'init-utils)
;;; init-utils.el ends here
