;;; core-funcs.el --- some functions and keybindings -*- lexical-binding: t -*-
;;; Commentary:

;;; Code:

(defun my/find-emacs-config-file ()
  "Find file in emacs configuration."
  (interactive)
  (let ((default-directory user-emacs-directory))
    (project-find-file)))

(defun my/open-zsh-config ()
  (interactive)
  (find-file "~/.zshrc"))

(defun my/switch-to-last-buffer ()
  "Switch to the last buffer."
  (interactive)
  (switch-to-buffer nil))

(general-define-key
 :prefix "C-x f"
 "p" 'my/find-emacs-config-file
 "z" 'my/open-zsh-config)

(general-define-key
 "C-`" 'my/switch-to-last-buffer)

(provide 'core-funcs)
;;; core-funcs.el ends here
