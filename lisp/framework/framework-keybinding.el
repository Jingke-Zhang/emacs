;;; framework-keybinding.el --- setup keybinding system -*- lexical-binding: t -*-
;;; Commentary:

;;; Code:
(use-package hydra
  :ensure (:wait t))

(use-package use-package-hydra
  :ensure (:wait t)
  :after hydra)

(use-package pretty-hydra
  :ensure t
  :after hydra)

(use-package which-key
  :ensure t
  :init
  (which-key-mode)
  :config
  (setq which-key-popup-type 'minibuffer
	which-key-separator " → "
	which-key-unicode-correction 3
	which-key-idle-delay 0.5))

(use-package general
  :ensure (:wait t)
  :demand t
  :config
  (general-create-definer my/C-x
    :prefix "C-x")
  (general-create-definer my/C-c
    :prefix "C-c")
  (general-unbind
    "C-x f")
  (general-create-definer my/find-file-def
    :prefix "C-x f")
  (general-create-definer my/toggle-def
    :prefix "C-x t")
  (general-create-definer my/fold-def
    :prefix "C-c f")
  (general-create-definer my/persp-def
    :prefix "C-c p")
  (general-create-definer my/project-def
    :prefix "C-x p"))

(provide 'framework-keybinding)
;;; framework-keybinding.el ends here
