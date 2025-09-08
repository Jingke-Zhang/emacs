;;; init--utils.el --- setup some useful utils -*- lexical-binding: t -*-
;;; Commentary:

;;; Code:
(use-package which-key
  :ensure t
  :init
  (which-key-mode)
  :config
  (setq which-key-popup-type 'minibuffer
	which-key-separator " → "
	which-key-unicode-correction 3
	which-key-idle-delay 0.5))

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


(provide 'init-utils)
;;; init-utils.el ends here
