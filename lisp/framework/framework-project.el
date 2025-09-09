;;; framework-project.el --- setup completion system -*- lexical-binding: t -*-
;;; Commentary:

;;; Code:
(use-package projectile
  :ensure t
  :pin melpa-stable
  :bind (("C-c p" . projectile-command-map))
  :init
  (projectile-mode +1)
  (setq projectile-project-search-path '("~/Documents/"))
  :config
  (setq projectile-mode-line "Projectile")
  (setq projectile-track-known-projects-automatically nil))


(use-package transient
  :ensure t)

(use-package magit
  :ensure t
  :bind (("C-x g" . magit-status)))

(use-package diff-hl
  :ensure t
  :init
  (global-diff-hl-mode)
  :hook
  (magit-post-refresh-hook . diff-hl-magit-post-refresh))

(provide 'framework-project)
;;; framework-project.el ends here
