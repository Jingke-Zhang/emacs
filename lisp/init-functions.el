;;; init-functions.el --- some functions and keybindings -*- lexical-binding: t -*-
;;; Commentary:

;;; Code:
(defun my/find-emacs-config-file ()
  "Find file in emacs configuration."
  (interactive)
  (projectile-find-file-in-directory user-emacs-directory))

(defun my/open-zsh-config ()
  (interactive)
  (find-file "~/.zshrc"))

(defun my/switch-to-last-buffer ()
  "Switch to the last buffer."
  (interactive)
  (switch-to-buffer nil))

(my/find-file-def
 "p" 'my/find-emacs-config-file
 "z" 'my/open-zsh-config)

(general-define-key
 "C-`" 'my/switch-to-last-buffer)

;;; Hydra
;; Base
(defhydra hydra-base
  (:foreign-keys warn :exit t)
  ("z" hydra-fold/body "fold")
  ("m" hydra-move/body "move")
  ("a" hydra-avy/body "avy")
  ("q" nil "exit"))

(general-define-key
 "C-o" 'hydra-base/body)

;; Fold
(defhydra hydra-fold
  (:foreign-keys warn
   :exit t)
  ("c" hs-hide-block "Close at point")
  ("o" hs-show-block "Open at point")
  ("M" hs-hide-all "Close all")
  ("R" hs-show-all "Open all")
  ("q" nil "Exit"))

;; Move
(defhydra hydra-move
  (:exit nil
   :foreign-keys run
   :hint nil
   :pre (set-cursor-color "#40e0d0")
   :post (progn
           (set-cursor-color "#ffffff")))
  "Move with fbnp"
  ("f" forward-char)
  ("b" backward-char)
  ("n" next-line)
  ("p" previous-line)
  ("a" mwim-beginning-of-code-or-line)
  ("e" mwim-end-of-code-or-line)
  ("v" scroll-up-command)
  ("V" scroll-down-command)
  (";" avy-goto-char)
  ("'" avy-goto-char-timer)
  ("q" nil))

(defhydra hydra-avy
  (:exit t
   :foreign-keys warn)
  ("l" avy-goto-line-below "line below")
  ("L" avy-goto-line-above "line above")
  ("w" avy-goto-word-below "word below")
  ("W" avy-goto-word-above "word above")
  ("q" nil "exit"))

(provide 'init-functions)
;;; init-functions.el ends here
