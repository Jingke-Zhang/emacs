;;; lang-py.el --- python configuration -*- lexical-binding: t -*-
;;; Commentary:

;;; Code:
(use-package python
  :ensure nil
  :defer t
  :init
  (add-to-list 'major-mode-remap-alist '(python-mode . python-ts-mode))
  
  :config
  (add-to-list 'treesit-language-source-alist 
               '(python "https://github.com/tree-sitter/tree-sitter-python"))
  (setq python-indent-offset 4))

(use-package lsp-pyright
  :ensure t
  :defer t
  :custom (lsp-pyright-langserver-command "pyright")
  :hook (python-ts-mode . (lambda ()
                          (require 'lsp-pyright)
                          (lsp-deferred))))

(provide 'lang-py)
;;; lang-py.el ends here
