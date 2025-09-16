;;; init.el --- load the full configuration -*- lexical-binding: t -*-
;;; Commentary:

;;; Code:
;; Basic configuration
(defun my/add-dirs-to-load-path (dirs)
  "Iterates through a list of directories and add them to `load-path'.
DIRS is a list of relative paths from `user-emacs-directory'."
  (dolist (dir dirs)
    (let ((full-path (expand-file-name dir user-emacs-directory)))
      (when (file-directory-p full-path)
	(add-to-list 'load-path full-path)))))

(my/add-dirs-to-load-path '("lisp"
			    "lisp/framework"
			    "lisp/language"
			    "lisp/modules"))
  
(defconst *spell-check-support-enabled* nil)
(defconst *is-a-mac* (eq system-type 'darwin))

;; Adjust garbage collection thresholds during startup, and thereafter
(setq gc-cons-threshold (* 128 1024 1024))
(setq read-process-output-max (* 4 1024 1024))
(setq process-adaptive-read-buffering nil)

;; Load custom file
(setq custom-file (locate-user-emacs-file "custom.el"))

;; Load configuration
(require 'framework-elpa)
(require 'framework-keybinding)
(require 'framework-completion)
(require 'framework-language)
(require 'framework-project)
(require 'framework-appearance)
(require 'init-my-functions)
(require 'init-basic)
(require 'init-utils)
(require 'init-modules)
(require 'init-github)
(require 'language-cc)
(require 'language-beancount)

(provide 'init)
;;; init.el ends here
