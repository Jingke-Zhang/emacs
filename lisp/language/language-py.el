;;; language-py.el --- python configuration -*- lexical-binding: t -*-
;;; Commentary:

;;; Code:
(use-package lsp-pyright
  :ensure t
  :defer t
  :custom (lsp-pyright-langserver-command "pyright")
  :hook (python-mode . (lambda ()
                          (require 'lsp-pyright)
                          (lsp-deferred))))

(use-package conda
  :ensure t
  :defer t
  :init
  (setq conda-anaconda-home "/opt/anaconda3/bin/"
	conda-env-home-directory "/opt/anaconda3/")
  :config
  (conda-env-initialize-interactive-shells)
  (conda-env-initialize-eshell)
  (conda-env-autoactivate-mode t))
(provide 'language-py)
;;; language-py.el ends here
