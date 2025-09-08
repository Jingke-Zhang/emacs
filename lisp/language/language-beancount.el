;;; language-beancount.el --- beancount configuration -*- lexical-binding: t -*-
;;; Commentary:

;;; Code:
(use-package beancount
  :ensure t
  :config
  (add-to-list 'auto-mode-alist '("\\.beancount\\'" . beancount-mode))
  :hook
  (beancount-mode . (lambda () (setq-local electric-indent-chars nil))))

(use-package lsp-mode
  :hook (beancount-mode . lsp-deferred)
  :config
  (setq lsp-beancount-journal-file "~/Documents/02-areas/beancount/main.beancount")
  (lsp-register-client
   (make-lsp-client
    :new-connection (lsp-stdio-connection "beancount-language-server")
    :major-modes '(beancount-mode)
    :server-id 'beancount-language-server
    :initialization-options
    (lambda () (list :journal_file "~/Documents/02-areas/beancount/main.beancount"
                     :formatting '(:prefix_width 30 :currency_column 60 :number_currency_spacing 1))))))

(provide 'language-beancount)
;;; language-beancount.el ends here
