;;; core-edit.el --- setup edit and keybinding system -*- lexical-binding: t -*-
;;; Commentary:

;;; Code:
(setq-default fill-column 80)
(add-hook 'prog-mode-hook #'display-fill-column-indicator-mode)

(add-hook 'text-mode-hook #'auto-fill-mode)
(add-hook 'prog-mode-hook #'auto-fill-mode)

(use-package hydra
  :ensure t
  :defer t)

(use-package use-package-hydra
  :ensure t
  :defer t
  :after hydra)

(use-package pretty-hydra
  :ensure t
  :defer t
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
  (global-unset-key (kbd "M-z"))
  (general-create-definer my/leader-def
    :prefix "M-z")
  (general-unbind
    "C-x f"))

(my/leader-def
  "s" 'scratch-buffer
  "z" 'zap-to-char
  "M-z" 'zap-up-to-char
  ;; eval
  "e" '(:ignore t :which-key "eval")
  "eb" 'eval-buffer
  "er" 'eval-region
  "ee" 'eval-last-sexp
  "ef" 'eval-defun)


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
