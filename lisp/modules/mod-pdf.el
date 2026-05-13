;;; mod-pdf.el --- config for pdf -*- lexical-binding: t -*-
;;; Commentary:

;;; Code:
(use-package pdf-tools
  :ensure t
  :mode
  ("\\.pdf\\'" . pdf-view-mode)
  :magic ("%PDF" . pdf-view-mode)
  :hook (pdf-view-mode . (lambda () (display-line-numbers-mode -1)))
  :config
  ;; Install the server on demand instead of rebuilding it during startup.
  (pdf-tools-install :no-query))


(provide 'mod-pdf)
;;; mod-pdf.el ends here
