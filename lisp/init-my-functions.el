;;; init-my-functions.el --- load the full configuration -*- lexical-binding: t -*-
;;; Commentary:

;;; Code:

(defun my/reload-init-file ()
  "Reload the Emacs initialization file."
  (interactive)
  (load-file user-init-file)
  (message "Emacs configuration reloaded successfully!"))

(defun my/find-emacs-config-file ()
  (interactive)
  (dired user-emacs-directory))

(defun my/open-zsh-config ()
  (interactive)
  (find-file "~/.zshrc"))

(provide 'init-my-functions)
;;; init-my-functions.el ends here
