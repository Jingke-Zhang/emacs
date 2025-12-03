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


(provide 'init-functions)
;;; init-functions.el ends here
