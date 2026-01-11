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
  :defer t
  :init
  (with-eval-after-load 'winum
    (define-key winum-keymap (kbd "M-0") #'treemacs-select-window))
  :config
  (progn
    (setq treemacs-buffer-name-function            #'treemacs-default-buffer-name
          treemacs-buffer-name-prefix              " *Treemacs-Buffer-"
          treemacs-collapse-dirs                   (if treemacs-python-executable 3 0)
          treemacs-deferred-git-apply-delay        0.5
          treemacs-directory-name-transformer      #'identity
          treemacs-display-in-side-window          t
          treemacs-eldoc-display                   'simple
          treemacs-file-event-delay                2000
          treemacs-file-extension-regex            treemacs-last-period-regex-value
          treemacs-file-follow-delay               0.2
          treemacs-file-name-transformer           #'identity
          treemacs-follow-after-init               t
          treemacs-expand-after-init               t
          treemacs-find-workspace-method           'find-for-file-or-pick-first
          treemacs-git-command-pipe                ""
          treemacs-goto-tag-strategy               'refetch-index
          treemacs-header-scroll-indicators        '(nil . "^^^^^^")
          treemacs-hide-dot-git-directory          t
          treemacs-indentation                     2
          treemacs-indentation-string              " "
          treemacs-is-never-other-window           nil
          treemacs-max-git-entries                 5000
          treemacs-missing-project-action          'ask
          treemacs-move-files-by-mouse-dragging    t
          treemacs-move-forward-on-expand          nil
          treemacs-no-png-images                   nil
          treemacs-no-delete-other-windows         t
          treemacs-project-follow-cleanup          nil
          treemacs-persist-file                    (expand-file-name ".cache/treemacs-persist" user-emacs-directory)
          treemacs-position                        'left
          treemacs-read-string-input               'from-child-frame
          treemacs-recenter-distance               0.1
          treemacs-recenter-after-file-follow      nil
          treemacs-recenter-after-tag-follow       nil
          treemacs-recenter-after-project-jump     'always
          treemacs-recenter-after-project-expand   'on-distance
          treemacs-litter-directories              '("/node_modules" "/.venv" "/.cask")
          treemacs-project-follow-into-home        nil
          treemacs-show-cursor                     nil
          treemacs-show-hidden-files               t
          treemacs-silent-filewatch                nil
          treemacs-silent-refresh                  nil
          treemacs-sorting                         'alphabetic-asc
          treemacs-select-when-already-in-treemacs 'move-back
          treemacs-space-between-root-nodes        t
          treemacs-tag-follow-cleanup              t
          treemacs-tag-follow-delay                1.5
          treemacs-text-scale                      nil
          treemacs-user-mode-line-format           nil
          treemacs-user-header-line-format         nil
          treemacs-wide-toggle-width               70
          treemacs-width                           35
          treemacs-width-increment                 1
          treemacs-width-is-initially-locked       t
          treemacs-workspace-switch-cleanup        nil)

    ;; The default width and height of the icons is 22 pixels. If you are
    ;; using a Hi-DPI display, uncomment this to double the icon size.
    ;;(treemacs-resize-icons 44)

    (treemacs-follow-mode t)
    (treemacs-filewatch-mode t)
    (treemacs-fringe-indicator-mode 'always)
    (when treemacs-python-executable
      (treemacs-git-commit-diff-mode t))

    (pcase (cons (not (null (executable-find "git")))
                 (not (null treemacs-python-executable)))
      (`(t . t)
       (treemacs-git-mode 'deferred))
      (`(t . _)
       (treemacs-git-mode 'simple)))

    (treemacs-hide-gitignored-files-mode nil)))
  
(use-package treemacs-projectile
  :after (treemacs projectile)
  :defer t
  :ensure t)

(use-package treemacs-icons-dired
  :defer t
  :hook (dired-mode . treemacs-icons-dired-enable-once)
  :ensure t)

(use-package treemacs-magit
  :defer t
  :after (treemacs magit)
  :ensure t)

(provide 'framework-project)
;;; framework-project.el ends here
