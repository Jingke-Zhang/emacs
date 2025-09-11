;;; init-github.el --- setup github -*- lexical-binding: t -*-
;;; Commentary:

;;; Code:
(use-package forge
  :ensure t
  :init
  (setq auth-sources '("~/.authinfo"))
  :after magit)

(provide 'init-github)
;;; init-github.el ends here
