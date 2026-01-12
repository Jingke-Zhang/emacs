;;; init-dired.el --- Better dired -*- lexical-binding: t -*-
;;; Commentary:

;;; Code:
(use-package dash)

(use-package dired-hacks-utils
  :ensure (:host github
           :repo "Fuco1/dired-hacks"
           :files ("*.el")
           :build (:not byte-compile)) 
  :after dired)
(use-package dired-subtree
  :after dired-hacks-utils
  :config
  (setq dired-subtree-line-prefix "  │ ")
  ;; (setq dired-subtree-use-backgrounds nil)
  (add-hook 'dired-subtree-after-insert-hook
            (lambda ()
              (when (fboundp 'nerd-icons-dired-mode)
                (nerd-icons-dired-mode -1)
                (nerd-icons-dired-mode 1))))
  (general-define-key
   :keymaps 'dired-mode-map
   "TAB"       'dired-subtree-toggle
   "<backtab>" 'dired-subtree-cycle))

(use-package dired-filter
  :after dired-hacks-utils
  :hook (dired-mode . dired-filter-mode)
  :config
  (setq dired-filter-group-saved-groups
        '(("default"
           ("Code" (extension "cpp" "c" "h" "hpp" "py" "el" "rs" "go"))
           ("Build" (extension "o" "a" "so" "class")))))
  (general-define-key
   :keymaps 'dired-mode-map
   :prefix "/"
   "n" 'dired-filter-by-name
   "e" 'dired-filter-by-extension
   "g" 'dired-filter-group-mode
   "/" 'dired-filter-pop-all-persistant))

(use-package dired-narrow
  :after dired-hacks-utils
  :config
  (general-define-key
   :keymaps 'dired-mode-map
   "s" 'dired-narrow))

(use-package dired-collapse
  :after dired-hacks-utils
  :hook (dired-mode . dired-collapse-mode))


(provide 'init-dired)
;;; init-dired.el ends here
