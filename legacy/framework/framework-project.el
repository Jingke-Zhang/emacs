;;; framework-project.el --- setup completion system -*- lexical-binding: t -*-
;;; Commentary:

;;; Code:
(use-package projectile
  :ensure t
  :defer t
  :init
  (projectile-mode 1)
  (setq projectile-project-search-path '("~/Documents/" "~/.config/")
	projectile-ignored-projects '("~/"))
  :config
  (setq projectile-enable-caching t
	projectile-require-project-root t
	projectile-track-known-projects-automatically nil)
  (my/C-x
    "p" 'projectile-command-map))

(use-package perspective
  :ensure t
  :defer t
  :init
  (setq persp-suppress-no-prefix-key-warning t)
  (persp-mode)
  :config
  (my/C-x
   "b" 'consult-project-buffer
   "C-b" 'persp-ibuffer
   "B" 'consult-buffer
   "M-b" 'ibuffer)
  (my/persp-def
   "p" 'persp-switch
   "l" 'persp-switch-last
   "k" 'persp-kill))

(use-package persp-projectile
  :ensure t
  :defer t
  :after (perspective projectile)
  :bind
  ("C-x p p" . projectile-persp-switch-project))

(use-package ibuffer
  :ensure nil
  :hook (ibuffer-mode . ibuffer-auto-mode-switch-setup)
  :config
  (setq ibuffer-expert t)
  (setq ibuffer-show-empty-filter-groups nil))


(use-package transient
  :ensure t)

(use-package magit
  :ensure t
  :defer t
  :bind (("C-x g" . magit-status)))

(use-package diff-hl
  :ensure t
  :defer t
  :init
  (global-diff-hl-mode)
  :hook
  (magit-post-refresh-hook . diff-hl-magit-post-refresh))

(use-package treemacs
  :ensure t
  :defer t)

(use-package treemacs-nerd-icons
  :ensure t
  :after treemacs
  :config
  (treemacs-load-theme "nerd-icons"))
 
(provide 'framework-project)
;;; framework-project.el ends here
