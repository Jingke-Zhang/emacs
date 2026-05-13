;;; mod-dev.el --- -*- lexical-binding: t -*-
;;; Commentary:

;;; Code:
(use-package ibuffer
  :ensure nil
  :defer t
  :hook (ibuffer-mode . ibuffer-auto-mode-switch-setup)
  :config
  (setq ibuffer-expert t)
  (setq ibuffer-show-empty-filter-groups nil)
  :general
  ("C-x C-b" 'ibuffer))

(defun my/project-try-local (dir)
  "Determine if DIR is a non-git project."
  (let ((root (locate-dominating-file dir ".project")))
    (and root (cons 'transient root))))

(use-package project
  :defer t
  :ensure nil
  :config
  (add-to-list 'project-find-functions 'my/project-try-local))

(use-package transient
  :defer t
  :ensure t)

(use-package magit
  :ensure t
  :defer t
  :general ("C-x g"  'magit-status))

(use-package diff-hl
  :ensure t
  :defer t
  :hook
  (magit-post-refresh-hook . diff-hl-magit-post-refresh)
  (magit-pre-refresh-hook . diff-hl-magit-pre-refresh)
  (prog-mode . diff-hl-mode)
  (dired-mode . diff-hl-dired-mode)
  (text-mode . diff-hl-mode)
  (conf-mode . diff-hl-mode))

(use-package yasnippet
  :ensure t
  :hook
  (prog-mode . yas-minor-mode)
  (text-mode . yas-minor-mode)
  (conf-mode . yas-minor-mode)
  :general
  (:keymaps 'yas-minor-mode-map
            "TAB" nil
            "<tab>" nil
            "S-<tab>" 'yas-expand))
  
(use-package yasnippet-snippets
  :ensure t
  :after yasnippet)

;; Syntax Checking
(use-package flycheck
  :ensure t
  :defer t
  :custom
  (flycheck-indication-mode 'right-fringe)
  (truncate-lines nil)
  :hook
  (prog-mode . flycheck-mode))

(use-package lsp-mode
  :ensure t
  :defer t
  :init
  (setq lsp-keymap-prefix "C-c l"
        lsp-ts-query-parser-install-directories
        (vector (expand-file-name "tree-sitter" user-emacs-directory)))
  :custom
  (lsp-completion-provider :none)
  (lsp-enable-on-type-formatting nil)
  (lsp-file-watch-threshold 500)
  (lsp-format-buffer-on-save nil)
  (lsp-headerline-breadcrumb-enable t)
  (lsp-headerline-breadcrumb-icons-enable t)
  (lsp-idle-delay 0.50)
  :hook  (lsp-mode . lsp-enable-which-key-integration) ; which-key integration
  :commands (lsp lsp-deferred))
	
(use-package lsp-ui
  :ensure t
  :after lsp-mode
  :defer t
  :custom
  (lsp-ui-doc-enable nil)
  (lsp-ui-doc-position 'top)
  (lsp-ui-sideline-enable nil)
  (lsp-ui-sideline-show-code-actions t)
  :general
  (:keymaps 'lsp-ui-mode-map
            [remap xref-find-definitions] #'lsp-ui-peek-find-definitions
            [remap xref-find-references]  #'lsp-ui-peek-find-references))

(use-package docker
  :ensure t
  :defer t
  :general
  ("C-c d" 'docker))

(provide 'mod-dev)
;;; mod-dev.el ends here
