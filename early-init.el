;;; early-init.el --- Emacs 27+ pre-initialisation config -*- lexical-binding: t; -*-
;;; Commentary:

;; Emacs 27+ loads this file before (normally) calling
;; `package-initialize'.  We use this file to suppress that automatic
;; behaviour so that startup is consistent across Emacs versions.

;;; Code:

(setq package-enable-at-startup nil)

(add-to-list 'default-frame-alist '(undecorated-round . t))
(add-to-list 'default-frame-alist '(width . 120))
(add-to-list 'default-frame-alist '(height . 50))

(when (eq system-type 'darwin)
  (setq frame-resize-pixelwise t))

(setq face-font-rescale-alist '(("PingFang SC" . 1.2) ("Optima" . 1.2)))


(provide 'early-init)
;;; early-init.el ends here
