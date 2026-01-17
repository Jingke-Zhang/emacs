;;; mod-tools.el --- some useful tools-*- lexical-binding: t -*-
;;; Commentary:

;;; Code:
(use-package dired-hacks-utils
  :ensure t
  :defer t
  :after (dired dash))

(use-package dired-subtree
  :after dired-hacks-utils
  :ensure t
  :defer t
  :config
  (setq dired-subtree-line-prefix "  │ ")
  (setq dired-subtree-use-backgrounds nil)
  (add-hook 'dired-subtree-after-insert-hook
            (lambda ()
              (when (fboundp 'nerd-icons-dired-mode)
                (nerd-icons-dired-mode -1)
                (nerd-icons-dired-mode 1)))))

(general-define-key
 :keymaps 'dired-mode-map
 "TAB"       'dired-subtree-toggle
 "<backtab>" 'dired-subtree-cycle)

(use-package dired-collapse
  :after dired-hacks-utils
  :defer t
  :ensure t
  :hook (dired-mode . dired-collapse-mode))

(use-package expand-region
  :ensure t
  :defer t
  :general
  ("C-=" 'er/expand-region))

(use-package hideshow
  :hook
  (prog-mode . hs-minor-mode)
  :general
  ("M-t" 'hs-toggle-hiding
   "C-M-t" 'hs-hide-all
   "M-T" 'hs-show-all))

(use-package ace-window
  :ensure t
  :defer t
  :general
  ("M-o" 'ace-window))

(use-package mwim
  :ensure t
  :defer t
  :general
  ("C-a" 'mwim-beginning-of-code-or-line
   "C-e" 'mwim-end-of-code-or-line))

(use-package avy
  :ensure t
  :defer t
  :general
  ("C-;" 'avy-goto-char-timer))

(use-package exec-path-from-shell
  :if (memq window-system '(mac ns))
  :ensure t
  :hook (after-init . exec-path-from-shell-initialize))

(use-package vterm
  :ensure t
  :defer t
  :config
  (setq vterm-kill-buffer-on-exit t
	vterm-timer-delay nil
	vterm-module-cmake-args "-DUSE_SYSTEM_LIBVTERM=no"
	vterm-max-scrollback 10000))
    
(use-package vterm-toggle
  :ensure t
  :after vterm
  :defer t
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
                 (window-parameters . ((select . t)))))
  :general
  (:keymaps 'vterm-mode-map
            ;; "C-t" 'vterm-toggle
            "C-<return>" 'vterm-toggle-insert-cd
            "C-y" 'vterm-yank))

(general-define-key
 :keymaps 'override
 "C-t" 'vterm-toggle)

(provide 'mod-tools)
;;; mod-tools.el ends here
