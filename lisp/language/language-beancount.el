;;; language-beancount.el --- beancount configuration -*- lexical-binding: t -*-
;;; Commentary:

;;; Code:
(defvar my/beancount-root "~/Documents/02-areas/beancount/")

(use-package beancount
  :ensure t
  :config
  (add-to-list 'auto-mode-alist '("\\.beancount\\'" . beancount-mode))
  :hook
  (beancount-mode . (lambda () (setq-local electric-indent-chars nil)))
  :init
  (with-eval-after-load 'nerd-icons
    (add-to-list 'nerd-icons-extension-icon-alist
                 '("beancount" nerd-icons-faicon "nf-fa-money" :face nerd-icons-lblue))
    (add-to-list 'nerd-icons-mode-icon-alist
                 '(beancount-mode nerd-icons-faicon "nf-fa-money" :face nerd-icons-lblue)))
)

(use-package lsp-mode
  :hook (beancount-mode . lsp-deferred)
  :config
  (setq lsp-beancount-journal-file (concat my/beancount-root "main.beancount"))
  (lsp-register-client
   (make-lsp-client
    :new-connection (lsp-stdio-connection "beancount-language-server")
    :major-modes '(beancount-mode)
    :server-id 'beancount-language-server
    :initialization-options
    (lambda () (list :journal_file (concat my/beancount-root "main.beancount")
                     :formatting '(:prefix_width 30 :currency_column 60 :number_currency_spacing 1))))))

(defun my/beancount-search-file ()
  "Search file in beancount folder"
  (interactive)
  (projectile-find-file-in-directory my/beancount-root))

(defun my/beancount-search-file-this-year ()
  "Search file in beancount folder of this year"
  (interactive)
  (projectile-find-file-in-directory (concat my/beancount-root (format-time-string "%Y/"))))

(defun my/beancount-open-routine-this-year ()
  "Search routine file in beancount folder of this year"
  (interactive)
  (find-file (concat my/beancount-root (format-time-string "%Y/routine.beancount"))))

(defun my/beancount-open-file-this-month ()
  "Search file in beancount folder of this month"
  (interactive)
  (find-file (concat my/beancount-root (format-time-string "%Y/%m.beancount"))))

(my/find-file-def
  "b f" 'my/beancount-search-file
  "b y" 'my/beancount-search-file-this-year
  "b r" 'my/beancount-open-routine-this-year
  "b b" 'my/beancount-open-file-this-month)

(provide 'language-beancount)
;;; language-beancount.el ends here
