;;; lang-py.el --- python configuration -*- lexical-binding: t -*-
;;; Commentary:

;;; Code:
(defun my/python-start-lsp ()
  "Load Pyright support before starting LSP."
  (require 'lsp-pyright)
  (lsp-deferred))

(use-package python
  :ensure nil
  :defer t
  :init
  (add-to-list 'major-mode-remap-alist '(python-mode . python-ts-mode))
  (with-eval-after-load 'treesit
    (add-to-list 'treesit-language-source-alist 
                 '(python "https://github.com/tree-sitter/tree-sitter-python")))
  :custom
  (python-indent-offset 4))

(use-package lsp-pyright
  :ensure t
  :defer t
  :custom (lsp-pyright-langserver-command "pyright")
  :hook (python-ts-mode . my/python-start-lsp))

(provide 'lang-py)
;;; lang-py.el ends here
