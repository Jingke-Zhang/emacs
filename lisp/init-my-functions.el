;;; init-my-functions.el --- load the full configuration -*- lexical-binding: t -*-
;;; Commentary:

;;; Code:

(defun my/reload-init-file ()
  "Reload the Emacs initialization file."
  (interactive)
  (load-file user-init-file)
  (message "Emacs configuration reloaded successfully!"))

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

(provide 'init-my-functions)
;;; init-my-functions.el ends here
