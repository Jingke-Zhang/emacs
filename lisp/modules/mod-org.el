;;; mod-org.el --- config for org-mode -*- lexical-binding: t -*-
;;; Commentary:

;;; Code:
(defvar my/org-path "~/Documents/02-areas/org/")

(use-package org
  :ensure nil
  :hook ((org-mode . org-indent-mode)
         (org-mode . variable-pitch-mode))
  :config
  (setq org-hide-emphasis-markers t
        org-startup-with-inline-images t
        org-image-actual-width nil
        org-fontify-done-headline t
        org-fontify-whole-heading-line t
        org-fontify-quote-and-verse-blocks t
        org-adapt-indentation nil
        org-src-tab-acts-natively t
        org-src-fontify-natively t)
  (setq org-format-latex-options 
        (plist-put org-format-latex-options :scale 1.5))
  (custom-set-faces
   '(org-level-1 ((t (:inherit outline-1 :height 1.4 :weight bold))))
   '(org-level-2 ((t (:inherit outline-2 :height 1.2 :weight bold))))
   '(org-level-3 ((t (:inherit outline-3 :height 1.1 :weight bold))))
   '(org-document-title ((t (:height 1.5 :weight bold :underline nil))))))

(use-package org-modern
  :ensure t
  :after org
  :hook (org-mode . org-modern-mode)
  :config
  (setq org-modern-star '("◉" "○" "◈" "◇" "✳"))
  (setq org-modern-list '((?- . "•") (?+ . "◦")))
  (setq org-modern-table nil)
  (setq org-modern-block-fringe nil))

(use-package org-appear
  :after org
  :hook (org-mode . org-appear-mode)
  :ensure t)


(use-package org-roam
  :ensure t
  :custom
  (org-roam-directory (file-truename (expand-file-name "roam" my/org-path)))
  :bind (("C-c n l" . org-roam-buffer-toggle)
         ("C-c n f" . org-roam-node-find)
         ("C-c n g" . org-roam-graph)
         ("C-c n i" . org-roam-node-insert)
         ("C-c n c" . org-roam-capture)
         ;; Dailies
         ("C-c n j" . org-roam-dailies-capture-today))
  :config
  ;; If you're using a vertical completion framework, you might want a more informative completion interface
  (setq org-roam-node-display-template (concat "${title:*} " (propertize "${tags:10}" 'face 'org-tag)))
  (org-roam-db-autosync-mode)
  ;; If using org-roam-protocol
  (require 'org-roam-protocol))

(use-package org-journal
  :ensure t
  :defer t
  :init
  ;; Change default prefix key; needs to be set before loading org-journal
  (setq org-journal-prefix-key "C-c j")
  :config
  (setq org-journal-dir (expand-file-name "journal" my/org-path)
        org-journal-date-format "%Y-%m-%d, %A"))

(provide 'mod-org)
;;; mod-doc.el ends here
