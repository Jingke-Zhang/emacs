;;; init-edit.el --- setup some useful editing utils -*- lexical-binding: t -*-
;;; Commentary:

;;; Code:
(use-package expand-region
  :ensure t
  :defer t
  :general
  ("C-=" 'er/expand-region))

(use-package smartparens
  :ensure t
  :defer t
  :hook
  (prog-mode text-mode markdown-mode)
  :config
  (require 'smartparens-config))

(provide 'init-edit)
;;; init-edit.el ends here
