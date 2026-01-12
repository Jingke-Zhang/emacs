;;; mod-dev.el --- -*- lexical-binding: t -*-
;;; Commentary:

;;; Code:
(use-package projectile
  :ensure t
  :defer t
  :init
  (projectile-mode 1)
  (setq projectile-project-search-path '("~/Documents/" "~/.config/")
	projectile-ignored-projects '("~/"))
  :config
  (setq projectile-enable-caching t
	projectile-require-project-root t
	projectile-track-known-projects-automatically nil)
  (my/C-x
    "p" 'projectile-command-map))

(use-package perspective
  :ensure t
  :defer t
  :init
  (setq persp-suppress-no-prefix-key-warning t)
  (persp-mode)
  :config
  (my/C-x
   "b" 'consult-project-buffer
   "C-b" 'persp-ibuffer
   "B" 'consult-buffer
   "M-b" 'ibuffer)
  (my/persp-def
   "p" 'persp-switch
   "l" 'persp-switch-last
   "k" 'persp-kill))

(use-package persp-projectile
  :ensure t
  :defer t
  :after (perspective projectile)
  :bind
  ("C-x p p" . projectile-persp-switch-project))

(use-package ibuffer
  :ensure nil
  :hook (ibuffer-mode . ibuffer-auto-mode-switch-setup)
  :config
  (setq ibuffer-expert t)
  (setq ibuffer-show-empty-filter-groups nil))


(use-package transient
  :ensure t)

(use-package magit
  :ensure t
  :defer t
  :bind (("C-x g" . magit-status)))

(use-package diff-hl
  :ensure t
  :defer t
  :init
  (global-diff-hl-mode)
  :hook
  (magit-post-refresh-hook . diff-hl-magit-post-refresh))

(use-package treemacs
  :ensure t
  :defer t)

(use-package treemacs-nerd-icons
  :ensure t
  :after treemacs
  :config
  (treemacs-load-theme "nerd-icons"))

(use-package yasnippet
  :ensure t
  :defer t
  :hook
  (prog-mode . yas-minor-mode)
  :config
  (yas-reload-all)
  (define-key yas-minor-mode-map [(tab)]    nil)
  (define-key yas-minor-mode-map (kbd "TAB")  nil)
  (define-key yas-minor-mode-map (kbd "<tab>") nil)
  :bind
  (:map yas-minor-mode-map ("S-<tab>" . yas-expand)))
  
(use-package yasnippet-snippets
  :ensure t
  :defer t
  :after yasnippet)

;; Syntax Checking
(use-package flycheck
  :ensure t
  :defer t
  :config
  (setq truncate-lines nil)
  :hook
  (prog-mode . flycheck-mode))

;; LSP
(use-package lsp-mode
  :ensure t
  :defer t
  :init
  (setq lsp-keymap-prefix "C-c l"
	lsp-format-buffer-on-save t
	lsp-file-watch-threshold 500)
  :hook  (lsp-mode . lsp-enable-which-key-integration) ; which-key integration
  :commands (lsp lsp-deferred)
  :config
  (setq lsp-completion-provider :none
	lsp-headerline-breadcrumb-enable t
	lsp-enable-on-type-formatting nil
	lsp-headerline-breadcrumb-icons-enable t))
	
(use-package lsp-ui
  :ensure t
  :defer t
  :config
  (define-key lsp-ui-mode-map [remap xref-find-definitions] #'lsp-ui-peek-find-definitions)
  (define-key lsp-ui-mode-map [remap xref-find-references] #'lsp-ui-peek-find-references)
  (setq lsp-ui-doc-position 'top))

(use-package lsp-treemacs
  :ensure t
  :defer t
  :config
  (lsp-treemacs-sync-mode 1)
  :custom
  (lsp-treemacs-theme "nerd-icons-ext")
  :commands lsp-treemacs-errors-list)

(use-package lsp-treemacs-nerd-icons
  :ensure
  (:host github :repo "Velnbur/lsp-treemacs-nerd-icons" :files ("*.el"))
  :defer t
  :custom
  (lsp-treemacs-theme "nerd-icons-ext")
  :init
  (with-eval-after-load 'lsp-treemacs
    (require 'lsp-treemacs-nerd-icons)))


(provide 'mod-dev)
;;; mod-dev.el ends here
