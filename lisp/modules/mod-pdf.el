;;; mod-pdf.el --- config for pdf -*- lexical-binding: t -*-
;;; Commentary:

;;; Code:
(use-package pdf-tools
  :ensure t
  :mode
  ("\\.pdf\\'" . pdf-view-mode)
  :config
  (pdf-tools-install)
  (add-hook 'pdf-view-mode-hook (lambda () (display-line-numbers-mode -1)))
  ;; :hook
  ;; (pdf-view-mode . pdf-view-roll-minor-mode)
  )


(provide 'mod-pdf)
;;; mod-pdf.el ends here
