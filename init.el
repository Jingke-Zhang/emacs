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

(my/add-dirs-to-load-path '("lisp/core"
                            "lisp/modules"))
  
(defconst *spell-check-support-enabled* nil)
(defconst *is-a-mac* (eq system-type 'darwin))

;; Raise GC during startup, then restore it so interactive editing stays smooth.
(setq gc-cons-threshold (* 128 1024 1024))
(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold (* 32 1024 1024))))
(setq read-process-output-max (* 4 1024 1024))
(setq process-adaptive-read-buffering nil)

;; Load custom file
(setq custom-file (locate-user-emacs-file "custom.el"))

;; Load configuration
(require 'core-elpa)
(require 'core-base)
(require 'core-edit)
(require 'core-ui)
(require 'core-comp)
(require 'core-funcs)

(require 'mod-dev)
(require 'mod-tools)
(require 'mod-org)
(require 'mod-tex)
(require 'mod-pdf)

(require 'lang-cc)
(require 'lang-py)
(require 'lang-beancount)

(provide 'init)
;;; init.el ends here
