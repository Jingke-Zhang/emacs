;;; framework-language.el --- setup completion system -*- lexical-binding: t -*-
;;; Commentary:

;;; Code:
;; Snippet
(use-package yasnippet
  :ensure t
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
 :after yasnippet)

;; Syntax Checking
(use-package flycheck
 :ensure t
 :config
 (setq truncate-lines nil)
 :hook
 (prog-mode . flycheck-mode))

;; LSP
(use-package lsp-mode
  :ensure t
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
  :config
  (define-key lsp-ui-mode-map [remap xref-find-definitions] #'lsp-ui-peek-find-definitions)
  (define-key lsp-ui-mode-map [remap xref-find-references] #'lsp-ui-peek-find-references)
  (setq lsp-ui-doc-position 'top))

(use-package lsp-treemacs
  :ensure t
  :config
  (lsp-treemacs-sync-mode 1)
  :custom
  (lsp-treemacs-theme "nerd-icons-ext")
  :commands lsp-treemacs-errors-list)

(use-package lsp-treemacs-nerd-icons
  :ensure
  (:host github :repo "Velnbur/lsp-treemacs-nerd-icons" :files ("*.el"))
  :custom
  (lsp-treemacs-theme "nerd-icons-ext")
  :init
  (with-eval-after-load 'lsp-treemacs
          (require 'lsp-treemacs-nerd-icons)))

(provide 'framework-language)
;;; framework-language.el ends here
