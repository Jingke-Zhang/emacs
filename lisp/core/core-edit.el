;;; core-edit.el --- setup edit and keybinding system -*- lexical-binding: t -*-
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
  (global-unset-key (kbd "C-z"))
  (general-create-definer my-leader-def
    :prefix "C-z")
  (general-unbind
    "C-x f"))

;; better undo
(setq undo-limit 6710886400)
(setq undo-strong-limit 100663296)
(setq undo-outer-limit 1006632960)

(use-package vundo
  :ensure t
  :defer t
  :config
  (setq vundo-glyph-alist vundo-unicode-symbols)
  (setq vundo-roll-back-on-quit nil)

  :general
  ("C-x u" 'vundo)
  
  (:keymaps 'vundo-mode-map
   "C-f" 'vundo-forward
   "C-b" 'vundo-backward
   "f"   'vundo-forward
   "b"   'vundo-backward

   "C-n" 'vundo-next
   "C-p" 'vundo-previous
   "n"   'vundo-next
   "p"   'vundo-previous

   "C-g" 'vundo-quit
   "q"   'vundo-quit))


(provide 'core-edit)
;;; core-edit.el ends here
