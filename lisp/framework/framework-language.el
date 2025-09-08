;;; framework-language.el --- setup completion system -*- lexical-binding: t012 -*-
;;; Commentary:

;;; Code:
;; Snippet
(use-package yasnippet
 :ensure t
 :hook
 (prog-mode . yas-minor-mode)
 :config
 (yas-reload-all)
 ;; add company-yasnippet to company-backends
 ;; (defun company-mode/backend-with-yas (backend)
 ;;  (if (and (listp backend) (member 'company-yasnippet backend))
 ;;   backend
 ;;   (append (if (consp backend) backend (list backend))
 ;;        '(:with company-yasnippet))))
 ;; (setq company-backends (mapcar #'company-mode/backend-with-yas company-backends))
 ;; unbind <TAB> completion
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
 ;; set prefix for lsp-command-keymap (few alternatives - "C-l", "C-c l")
 (setq lsp-keymap-prefix "C-c l"
	lsp-file-watch-threshold 500)
 :hook  (lsp-mode . lsp-enable-which-key-integration) ; which-key integration
 :commands (lsp lsp-deferred)
 :config
 (setq lsp-completion-provider :none)
 (setq lsp-headerline-breadcrumb-enable t)
 :bind
 ("C-c l s" . lsp-ivy-workspace-symbol))

(use-package lsp-ui
 :ensure t
 :config
 (define-key lsp-ui-mode-map [remap xref-find-definitions] #'lsp-ui-peek-find-definitions)
 (define-key lsp-ui-mode-map [remap xref-find-references] #'lsp-ui-peek-find-references)
 (setq lsp-ui-doc-position 'top))

(provide 'framework-language)
;;; framework-language.el ends here
