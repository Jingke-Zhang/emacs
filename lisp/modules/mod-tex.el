;;; mod-tex.el --- config for latex -*- lexical-binding: t -*-
;;; Commentary:

;;; Code:
(use-package tex
  :ensure auctex
  :mode ("\\.tex\\'" . latex-mode)
  :config
  (setq TeX-auto-save t)
  (setq TeX-parse-self t)
  (setq-default TeX-master nil))

(use-package cdlatex
  :ensure t
  :hook (org-mode . org-cdlatex-mode)
  :config
  )

(provide 'mod-tex)
;;; mod-tex.el ends here
