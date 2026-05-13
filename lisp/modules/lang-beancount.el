;;; lang-beancount.el --- beancount configuration -*- lexical-binding: t -*-
;;; Commentary:

;;; Code:
(require 'cl-lib)

(defvar my/beancount-root "~/Documents/02-areas/beancount/")
(defvar my/beancount-account-file "~/Documents/02-areas/beancount/config/account.beancount")
(defvar my/beancount-account-cache nil)
(defvar my/beancount-account-cache-file nil)
(defvar my/beancount-account-cache-mtime nil)

(defun my/beancount-open-file-this-month ()
  "Open the Beancount journal file for the current month."
  (interactive)
  (find-file (concat my/beancount-root (format-time-string "%Y/%m.beancount"))))

(defun my/beancount-disable-electric-indent ()
  "Disable electric indentation in Beancount buffers."
  (setq-local electric-indent-chars nil))

(defun my/beancount-get-accounts-from-file (file-path)
  "Extract active accounts from a specific Beancount file."
  (let* ((file-path (expand-file-name file-path))
         (attrs (file-attributes file-path))
         (mtime (and attrs (file-attribute-modification-time attrs))))
    (if (and my/beancount-account-cache
             (equal file-path my/beancount-account-cache-file)
             (equal mtime my/beancount-account-cache-mtime))
        my/beancount-account-cache
      (let ((accounts '())
            (closed-accounts '()))
        (when (file-exists-p file-path)
          (with-temp-buffer
            (insert-file-contents file-path)
            (goto-char (point-min))
            (while (re-search-forward "^\\([0-9]\\{4\\}-[0-9]\\{2\\}-[0-9]\\{2\\}\\)\\s-+\\(open\\|close\\)\\s-+\\([A-Z][a-zA-Z0-9:]+\\)" nil t)
              (let ((type (match-string 2))
                    (account (match-string 3)))
                (if (string= type "open")
                    (push account accounts)
                  (push account closed-accounts))))))
        (setq accounts (cl-remove-if (lambda (acc) (member acc closed-accounts)) accounts))
        (setq my/beancount-account-cache (delete-dups (sort accounts #'string<))
              my/beancount-account-cache-file file-path
              my/beancount-account-cache-mtime mtime)
        my/beancount-account-cache))))

(defun my/beancount-insert-account ()
  "Insert account by parsing your master account file."
  (interactive)
  (let* ((account-file my/beancount-account-file) 
         (candidates (my/beancount-get-accounts-from-file account-file))
         (selected (completing-read "Account (Static): " candidates nil t)))
    (when selected
      (let ((bounds (bounds-of-thing-at-point 'word)))
        (if bounds
            (replace-region-contents (car bounds) (cdr bounds) (lambda () selected))
          (insert selected))))))

(general-define-key
  "C-x f b" 'my/beancount-open-file-this-month)

(use-package beancount
  :ensure t
  :defer t
  :mode ("\\.beancount\\'" . beancount-mode)
  :hook
  (beancount-mode . lsp-deferred)
  (beancount-mode . my/beancount-disable-electric-indent)
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
