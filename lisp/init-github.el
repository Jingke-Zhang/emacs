;;; init-github.el --- setup github -*- lexical-binding: t -*-
;;; Commentary:

;;; Code:
(use-package async
  :ensure t)

(use-package forge
  :ensure t
  :after magit
  :init
  (setq auth-sources '("~/.authinfo")))

(provide 'init-github)
;;; init-github.el ends here
