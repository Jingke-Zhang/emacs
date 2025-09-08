;;; framework-project.el --- setup completion system -*- lexical-binding: t -*-
;;; Commentary:

;;; Code:
(use-package projectile
 :ensure t
 :bind (("C-c p" . projectile-command-map))
 :config
 (setq projectile-mode-line "Projectile")
 (setq projectile-track-known-projects-automatically nil))

(use-package counsel-projectile
 :ensure t
 :after (projectile)
 :init (counsel-projectile-mode))

(use-package transient
  :ensure t)

(use-package magit
  :ensure t
  :bind (("C-x g" . magit-status)))

(use-package diff-hl
  :ensure t
  :init
  (global-diff-hl-mode))

(provide 'framework-project)
;;; framework-project.el ends here
