;;; init-utils.el --- setup some useful utils -*- lexical-binding: t -*-
;;; Commentary:

;;; Code:
(use-package ace-window
  :ensure t
  :defer t
  :bind (("C-x o" . 'ace-window)))

(use-package mwim
  :ensure t
  :defer t
  :bind
  ("C-a" . mwim-beginning-of-code-or-line)
  ("C-e" . mwim-end-of-code-or-line))

(use-package undo-tree
  :ensure t
  :defer t
  :init (global-undo-tree-mode)
  :custom
  (undo-tree-auto-save-history nil))

(use-package avy
  :ensure t
  :defer t
  :bind
  (("C-;" . avy-goto-char-timer)))

(use-package exec-path-from-shell
  :if (memq window-system '(mac ns))
  :ensure t
  :init
  (exec-path-from-shell-initialize))

(use-package vterm
  :ensure t
  :defer t
  :config
  (setq vterm-kill-buffer-on-exit t
	vterm-timer-delay nil
	vterm-module-cmake-args "-DUSE_SYSTEM_LIBVTERM=no"
	vterm-max-scrollback 10000))

(use-package vterm-toggle
  :ensure (:host github :repo "jixiuf/vterm-toggle")
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
                 (window-height . 0.3)
                 (reusable-frames . visible)
                 (window-parameters . ((select . t))))))

(general-define-key
 :keymaps 'override
 "C-t" 'vterm-toggle)

(general-define-key
 "C-x t t" 'vterm-toggle)

(general-define-key
 :keymaps 'vterm-mode-map
 "C-t" 'vterm-toggle
 "C-<return>" 'vterm-toggle-insert-cd
 "C-y" 'vterm-yank)
  
(use-package pdf-tools
  :ensure t
  :defer t
  :defer t)

(provide 'init-utils)
;;; init-utils.el ends here
