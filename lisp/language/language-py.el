;;; language-py.el --- python configuration -*- lexical-binding: t -*-
;;; Commentary:

;;; Code:
(use-package lsp-pyright
  :ensure t
  :custom (lsp-pyright-langserver-command "pyright")
  :hook (python-mode . (lambda ()
                          (require 'lsp-pyright)
                          (lsp-deferred))))
(provide 'language-py)
;;; language-py.el ends here
