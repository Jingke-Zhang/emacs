;;; lang-beancount.el --- beancount configuration -*- lexical-binding: t -*-
;;; Commentary:

;;; Code:
(defvar my/beancount-root "~/Documents/02-areas/beancount/")

(defun my/beancount-open-file-this-month ()
  "Search file in beancount folder of this month"
  (interactive)
  (find-file (concat my/beancount-root (format-time-string "%Y/%m.beancount"))))

(defun my/beancount-insert-account ()
  "Insert account using standard beancount source, BUT SORTED.
Extracts candidates from the official table, sorts them, and uses Vertico."
  (interactive)
  (let* ((word (thing-at-point 'word))

         (candidates (sort (all-completions "" #'beancount-account-completion-table)
                           #'string<))
         (account (completing-read "Account: "
                                   candidates
                                   nil t word)))
    
    (let ((bounds (bounds-of-thing-at-point 'word)))
      (when bounds
        (delete-region (car bounds) (cdr bounds))))
    
    (insert account)))

(general-define-key
  "C-x f b" 'my/beancount-open-file-this-month)

(use-package beancount
  :ensure t
  :defer t
  :mode ("\\.beancount\\'" . beancount-mode)
  :hook
  (beancount-mode . lsp-deferred)
  (beancount-mode . (lambda () (setq-local electric-indent-chars nil)))
  :config
  (with-eval-after-load 'lsp-mode
    (setq lsp-beancount-journal-file (concat my/beancount-root "main.beancount"))
    (lsp-register-client
     (make-lsp-client
      :new-connection (lsp-stdio-connection "beancount-language-server")
      :major-modes '(beancount-mode)
      :server-id 'beancount-language-server
      :initialization-options
      (lambda () 
        (list :journal_file lsp-beancount-journal-file
              :formatting '(:prefix_width 30 
                            :currency_column 60 
                            :number_currency_spacing 1))))))
  :init
  (with-eval-after-load 'nerd-icons
    (add-to-list 'nerd-icons-extension-icon-alist
                 '("beancount" nerd-icons-faicon "nf-fa-money" :face nerd-icons-lblue))
    (add-to-list 'nerd-icons-mode-icon-alist
                 '(beancount-mode nerd-icons-faicon "nf-fa-money" :face nerd-icons-lblue)))
  :general
  (:keymaps 'beancount-mode-map
            "C-c a" 'my/beancount-insert-account
            "C-c d" 'beancount-insert-date
            "C-c n" 'beancount-date-up-day
            "C-c p" 'beancount-date-down-day))

(provide 'lang-beancount)
;;; lang-beancount.el ends here
