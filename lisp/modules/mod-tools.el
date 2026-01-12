;;; mod-tools.el --- some useful tools-*- lexical-binding: t -*-
;;; Commentary:

;;; Code:
(use-package dash)

(use-package dired-hacks-utils
  :ensure (:host github
           :repo "Fuco1/dired-hacks"
           :files ("*.el")
           :build (:not byte-compile)) 
  :after dired)
(use-package dired-subtree
  :after dired-hacks-utils
  :config
  (setq dired-subtree-line-prefix "  │ ")
  ;; (setq dired-subtree-use-backgrounds nil)
  (add-hook 'dired-subtree-after-insert-hook
            (lambda ()
              (when (fboundp 'nerd-icons-dired-mode)
                (nerd-icons-dired-mode -1)
                (nerd-icons-dired-mode 1))))
  (general-define-key
   :keymaps 'dired-mode-map
   "TAB"       'dired-subtree-toggle
   "<backtab>" 'dired-subtree-cycle))

(use-package dired-filter
  :after dired-hacks-utils
  :hook (dired-mode . dired-filter-mode)
  :config
  (setq dired-filter-group-saved-groups
        '(("default"
           ("Code" (extension "cpp" "c" "h" "hpp" "py" "el" "rs" "go"))
           ("Build" (extension "o" "a" "so" "class")))))
  (general-define-key
   :keymaps 'dired-mode-map
   :prefix "/"
   "n" 'dired-filter-by-name
   "e" 'dired-filter-by-extension
   "g" 'dired-filter-group-mode
   "/" 'dired-filter-pop-all-persistant))

(use-package dired-narrow
  :after dired-hacks-utils
  :config
  (general-define-key
   :keymaps 'dired-mode-map
   "s" 'dired-narrow))

(use-package dired-collapse
  :after dired-hacks-utils
  :hook (dired-mode . dired-collapse-mode))

(use-package expand-region
  :ensure t
  :defer t
  :general
  ("C-=" 'er/expand-region))

(use-package smartparens
  :ensure t
  :defer t
  :hook
  (prog-mode text-mode markdown-mode)
  :config
  (require 'smartparens-config))

(use-package hideshow
  :general
  ("C-c f f" 'hs-toggle-hiding
   "C-c f a" 'hs-hide-all
   "C-c f s" 'hs-show-all
   "C-c f l" 'hs-hide-level))

(use-package ace-window
  :ensure t
  :defer t
  :general
  ("C-x o" 'ace-window))

(use-package mwim
  :ensure t
  :defer t
  :general
  ("C-a" 'mwim-beginning-of-code-or-line
   "C-e" 'mwim-end-of-code-or-line))

(use-package undo-tree
  :ensure t
  :defer t
  :init (global-undo-tree-mode)
  :custom
  (undo-tree-auto-save-history nil))

(use-package avy
  :ensure t
  :defer t
  :general
  ("C-;" 'avy-goto-char-timer))

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
                 (window-parameters . ((select . t)))))
  :general
  (:keymaps 'vterm-mode-map
            "C-<return>" 'vterm-toggle-insert-cd
            "C-y" 'vterm-yank))

(general-define-key
 :keymaps 'override
 "C-t" 'vterm-toggle)
  
(use-package pdf-tools
  :ensure t
  :defer t
  :defer t)


(provide 'mod-tools)
;;; mod-tools.el ends here
