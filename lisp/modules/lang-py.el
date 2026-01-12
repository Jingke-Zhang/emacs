;;; lang-py.el --- python configuration -*- lexical-binding: t -*-
;;; Commentary:

;;; Code:
(use-package lsp-pyright
  :ensure t
  :defer t
  :custom (lsp-pyright-langserver-command "pyright")
  :hook (python-mode . (lambda ()
                          (require 'lsp-pyright)
                          (lsp-deferred))))

(provide 'lang-py)
;;; lang-py.el ends here
