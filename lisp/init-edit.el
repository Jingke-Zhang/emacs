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

(use-package hideshow
  :config
  (my/fold-def
   "f" 'hs-toggle-hiding
   "a" 'hs-hide-all
   "s" 'hs-show-all
   "l" 'hs-hide-level))

(provide 'init-edit)
;;; init-edit.el ends here
