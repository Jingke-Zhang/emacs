;;; mod-pdf.el --- config for pdf -*- lexical-binding: t -*-
;;; Commentary:

;;; Code:
(require 'cl-lib)
(require 'subr-x)

(defgroup my/pdf nil
  "Personal PDF reading setup."
  :group 'multimedia)

(defcustom my/pdf-place-file
  (locate-user-emacs-file "pdf-places.el")
  "File used to remember the last page visited in each PDF."
  :type 'file)

(defcustom my/pdf-bookmark-file
  (locate-user-emacs-file "pdf-bookmarks.el")
  "File used to remember per-PDF page bookmarks."
  :type 'file)

(defcustom my/pdf-sidebar-width 34
  "Width of the PDF outline sidebar."
  :type 'integer)

(defvar my/pdf--places (make-hash-table :test #'equal))
(defvar my/pdf--bookmarks (make-hash-table :test #'equal))
(defvar my/pdf--places-loaded nil)
(defvar my/pdf--bookmarks-loaded nil)
(defvar-local my/pdf--window-configuration nil)
(defvar-local my/pdf--saved-mode-line-format nil)
(defvar-local my/pdf--saved-cursor-type nil)
(defvar-local my/pdf--current-annotation nil)

(defun my/pdf--annotation-sort-key (annotation)
  "Return a sort key for ANNOTATION."
  (let* ((page (pdf-annot-get annotation 'page 0))
         (edges (car-safe (pdf-annot-get-display-edges annotation)))
         (top (or (cadr edges) 0)))
    (cons page top)))

(defun my/pdf--annotation-key< (left right)
  "Return non-nil when annotation key LEFT is before RIGHT."
  (or (< (car left) (car right))
      (and (= (car left) (car right))
           (< (cdr left) (cdr right)))))

(defun my/pdf--annotations ()
  "Return PDF annotations sorted by page and vertical position."
  (require 'pdf-annot)
  (sort (pdf-annot-getannots nil pdf-annot-list-listed-types)
        (lambda (left right)
          (my/pdf--annotation-key<
           (my/pdf--annotation-sort-key left)
           (my/pdf--annotation-sort-key right)))))

(defun my/pdf--active-annotation-key (fallback-top)
  "Return the active annotation key or current page with FALLBACK-TOP."
  (if (and my/pdf--current-annotation
           (= (pdf-annot-get my/pdf--current-annotation 'page 0)
              (pdf-view-current-page)))
      (my/pdf--annotation-sort-key my/pdf--current-annotation)
    (cons (pdf-view-current-page) fallback-top)))

(defun my/pdf-goto-annotation (annotation)
  "Go to ANNOTATION and highlight it briefly."
  (setq my/pdf--current-annotation annotation)
  (pdf-view-goto-page (pdf-annot-get annotation 'page))
  (pdf-annot-show-annotation annotation t))

(defun my/pdf-next-annotation ()
  "Go to the next annotation in the current PDF."
  (interactive)
  (let* ((key (my/pdf--active-annotation-key -1))
         (annotations (my/pdf--annotations))
         (next (cl-find-if
                 (lambda (annotation)
                   (my/pdf--annotation-key<
                    key
                    (my/pdf--annotation-sort-key annotation)))
                 annotations)))
    (if next
        (my/pdf-goto-annotation next)
      (message "No later PDF annotation."))))

(defun my/pdf-previous-annotation ()
  "Go to the previous annotation in the current PDF."
  (interactive)
  (let* ((key (my/pdf--active-annotation-key most-positive-fixnum))
         (annotations (reverse (my/pdf--annotations)))
         (previous (cl-find-if
                      (lambda (annotation)
                        (my/pdf--annotation-key<
                         (my/pdf--annotation-sort-key annotation)
                         key))
                      annotations)))
    (if previous
        (my/pdf-goto-annotation previous)
      (message "No earlier PDF annotation."))))

(defun my/pdf--document-key ()
  "Return a stable key for the current PDF buffer."
  (when-let* ((file (buffer-file-name)))
    (file-truename file)))

(defun my/pdf--load-places ()
  "Load remembered PDF places from `my/pdf-place-file'."
  (unless my/pdf--places-loaded
    (setq my/pdf--places-loaded t)
    (when (file-readable-p my/pdf-place-file)
      (with-temp-buffer
        (insert-file-contents my/pdf-place-file)
        (let ((data (read (current-buffer))))
          (clrhash my/pdf--places)
          (dolist (entry data)
            (pcase-let ((`(,file . ,page) entry))
              (when (and (stringp file) (integerp page))
                (puthash file page my/pdf--places)))))))))

(defun my/pdf--write-places ()
  "Persist remembered PDF places to `my/pdf-place-file'."
  (let (data)
    (maphash (lambda (file page)
               (push (cons file page) data))
             my/pdf--places)
    (with-temp-file my/pdf-place-file
      (insert ";;; PDF places -*- mode: emacs-lisp; lexical-binding: t -*-\n")
      (prin1 (sort data (lambda (a b) (string< (car a) (car b))))
             (current-buffer))
      (insert "\n"))))

(defun my/pdf--load-bookmarks ()
  "Load PDF bookmarks from `my/pdf-bookmark-file'."
  (unless my/pdf--bookmarks-loaded
    (setq my/pdf--bookmarks-loaded t)
    (when (file-readable-p my/pdf-bookmark-file)
      (with-temp-buffer
        (insert-file-contents my/pdf-bookmark-file)
        (let ((data (read (current-buffer))))
          (clrhash my/pdf--bookmarks)
          (dolist (entry data)
            (pcase-let ((`(,file . ,pages) entry))
              (when (and (stringp file)
                         (listp pages)
                         (cl-every #'integerp pages))
                (puthash file (sort (copy-sequence pages) #'<)
                         my/pdf--bookmarks)))))))))

(defun my/pdf--write-bookmarks ()
  "Persist PDF bookmarks to `my/pdf-bookmark-file'."
  (let (data)
    (maphash (lambda (file pages)
               (push (cons file pages) data))
             my/pdf--bookmarks)
    (with-temp-file my/pdf-bookmark-file
      (insert ";;; PDF bookmarks -*- mode: emacs-lisp; lexical-binding: t -*-\n")
      (prin1 (sort data (lambda (a b) (string< (car a) (car b))))
             (current-buffer))
      (insert "\n"))))

(defun my/pdf-save-place ()
  "Remember the current page for this PDF."
  (when (derived-mode-p 'pdf-view-mode)
    (when-let* ((file (my/pdf--document-key)))
      (my/pdf--load-places)
      (puthash file (pdf-view-current-page) my/pdf--places)
      (my/pdf--write-places))))

(defun my/pdf-restore-place ()
  "Restore the last remembered page for this PDF."
  (when-let* ((file (my/pdf--document-key)))
    (my/pdf--load-places)
    (when-let* ((page (gethash file my/pdf--places)))
      (ignore-errors
        (pdf-view-goto-page page)))))

(defun my/pdf-open-outline-sidebar ()
  "Open the PDF outline in a left side window when the document has one."
  (interactive)
  (require 'pdf-outline)
  (let ((pdf-window (selected-window))
        (pdf-buffer (current-buffer)))
    (condition-case nil
        (let ((outline-buffer (pdf-outline-noselect pdf-buffer)))
          (display-buffer-in-side-window
           outline-buffer
           `((side . left)
             (slot . -1)
             (window-width . ,my/pdf-sidebar-width)))
          (select-window pdf-window)
          (pdf-view-fit-width-to-window))
      (error
       (message "This PDF has no outline sidebar.")))))

(defun my/pdf-toggle-outline-sidebar ()
  "Toggle the outline sidebar for the current PDF."
  (interactive)
  (require 'pdf-outline)
  (let* ((outline-name (pdf-outline-buffer-name (current-buffer)))
         (outline-buffer (get-buffer outline-name))
         (outline-window (and outline-buffer
                              (get-buffer-window outline-buffer t))))
    (if (window-live-p outline-window)
        (delete-window outline-window)
      (my/pdf-open-outline-sidebar))))

(defun my/pdf-fit-width ()
  "Fit the current PDF to the current window width."
  (interactive)
  (pdf-view-fit-width-to-window))

(defun my/pdf-fit-height ()
  "Fit the current PDF to the current window height."
  (interactive)
  (pdf-view-fit-height-to-window))

(defun my/pdf-fit-page ()
  "Fit the current PDF page to the window."
  (interactive)
  (pdf-view-fit-page-to-window))

(defun my/pdf-goto-page (page)
  "Go to PAGE in the current PDF."
  (interactive
   (list (read-number "Page: " (pdf-view-current-page))))
  (pdf-view-goto-page page))

(defun my/pdf--bookmarks-for-current-buffer ()
  "Return the bookmarks for the current PDF buffer."
  (my/pdf--load-bookmarks)
  (when-let* ((file (my/pdf--document-key)))
    (gethash file my/pdf--bookmarks)))

(defun my/pdf--put-bookmarks-for-current-buffer (pages)
  "Store PAGES as bookmarks for the current PDF buffer."
  (when-let* ((file (my/pdf--document-key)))
    (my/pdf--load-bookmarks)
    (if pages
        (puthash file (sort (cl-remove-duplicates pages) #'<)
                 my/pdf--bookmarks)
      (remhash file my/pdf--bookmarks))
    (my/pdf--write-bookmarks)))

(defun my/pdf-toggle-bookmark ()
  "Toggle a bookmark on the current page."
  (interactive)
  (let* ((page (pdf-view-current-page))
         (pages (my/pdf--bookmarks-for-current-buffer)))
    (if (memq page pages)
        (progn
          (my/pdf--put-bookmarks-for-current-buffer (remove page pages))
          (message "Removed PDF bookmark on page %s" page))
      (my/pdf--put-bookmarks-for-current-buffer (cons page pages))
      (message "Added PDF bookmark on page %s" page))))

(defun my/pdf-jump-to-bookmark ()
  "Jump to a bookmark in the current PDF."
  (interactive)
  (let ((pages (my/pdf--bookmarks-for-current-buffer)))
    (if pages
        (let* ((choices (mapcar (lambda (page)
                                  (format "Page %d" page))
                                pages))
               (choice (completing-read "PDF bookmark: " choices nil t))
               (page (string-to-number (replace-regexp-in-string
                                         "\\`Page " "" choice))))
          (my/pdf-goto-page page))
      (message "This PDF has no bookmarks."))))

(defun my/pdf-delete-bookmark ()
  "Delete a bookmark from the current PDF."
  (interactive)
  (let ((pages (my/pdf--bookmarks-for-current-buffer)))
    (if pages
        (let* ((choices (mapcar (lambda (page)
                                  (format "Page %d" page))
                                pages))
               (choice (completing-read "Delete PDF bookmark: " choices nil t))
               (page (string-to-number (replace-regexp-in-string
                                         "\\`Page " "" choice))))
          (my/pdf--put-bookmarks-for-current-buffer (remove page pages))
          (message "Deleted PDF bookmark on page %s" page))
      (message "This PDF has no bookmarks."))))

(defun my/pdf-next-bookmark ()
  "Jump to the next bookmark in the current PDF."
  (interactive)
  (let* ((page (pdf-view-current-page))
         (pages (my/pdf--bookmarks-for-current-buffer))
         (next (cl-find-if (lambda (bookmark) (> bookmark page)) pages)))
    (if next
        (my/pdf-goto-page next)
      (message "No later PDF bookmark."))))

(defun my/pdf-previous-bookmark ()
  "Jump to the previous bookmark in the current PDF."
  (interactive)
  (let* ((page (pdf-view-current-page))
         (pages (reverse (my/pdf--bookmarks-for-current-buffer)))
         (previous (cl-find-if (lambda (bookmark) (< bookmark page)) pages)))
    (if previous
        (my/pdf-goto-page previous)
      (message "No earlier PDF bookmark."))))

(defun my/pdf-toggle-night-mode ()
  "Toggle a dark reading filter for the current PDF."
  (interactive)
  (pdf-view-midnight-minor-mode 'toggle))

(defun my/pdf-immersive-enter ()
  "Enter the default immersive PDF reading layout."
  (setq-local my/pdf--window-configuration
              (or my/pdf--window-configuration
                  (current-window-configuration)))
  (setq-local my/pdf--saved-mode-line-format mode-line-format
              my/pdf--saved-cursor-type cursor-type
              mode-line-format nil
              cursor-type nil)
  (display-line-numbers-mode -1)
  (setq-local truncate-lines t)
  (when (fboundp 'hl-line-mode)
    (hl-line-mode -1))
  (delete-other-windows)
  (my/pdf-fit-width)
  (my/pdf-restore-place)
  (add-hook 'pdf-view-after-change-page-hook #'my/pdf-save-place nil t))

(defun my/pdf-immersive-quit ()
  "Quit a PDF buffer and restore the previous window configuration."
  (interactive)
  (my/pdf-save-place)
  (let ((configuration my/pdf--window-configuration))
    (kill-current-buffer)
    (when (window-configuration-p configuration)
      (set-window-configuration configuration))))

(use-package pdf-tools
  :ensure t
  :mode
  ("\\.pdf\\'" . pdf-view-mode)
  :magic ("%PDF" . pdf-view-mode)
  :hook ((pdf-view-mode . my/pdf-immersive-enter)
         (kill-buffer . my/pdf-save-place))
  :config
  (setq-default pdf-view-display-size 'fit-width
                pdf-view-continuous nil
                pdf-view-resize-factor 1.15
                pdf-view-midnight-colors '("#cdd6f4" . "#11111b"))

  ;; Install the server on demand instead of rebuilding it during startup.
  (pdf-tools-install :no-query)
  (require 'pdf-annot)

  (define-key pdf-view-mode-map (kbd "q") #'my/pdf-immersive-quit)
  (define-key pdf-view-mode-map (kbd "n") #'pdf-view-next-line-or-next-page)
  (define-key pdf-view-mode-map (kbd "p") #'pdf-view-previous-line-or-previous-page)
  (define-key pdf-view-mode-map (kbd "v") #'pdf-view-scroll-up-or-next-page)
  (define-key pdf-view-mode-map (kbd "V") #'pdf-view-scroll-down-or-previous-page)
  (define-key pdf-view-mode-map (kbd "SPC") #'pdf-view-scroll-up-or-next-page)
  (define-key pdf-view-mode-map (kbd "S-SPC") #'pdf-view-scroll-down-or-previous-page)
  (define-key pdf-view-mode-map (kbd "+") #'pdf-view-enlarge)
  (define-key pdf-view-mode-map (kbd "=") #'pdf-view-enlarge)
  (define-key pdf-view-mode-map (kbd "-") #'pdf-view-shrink)
  (define-key pdf-view-mode-map (kbd "0") #'pdf-view-scale-reset)
  (define-key pdf-view-mode-map (kbd "w") #'my/pdf-fit-width)
  (define-key pdf-view-mode-map (kbd "h") #'my/pdf-fit-height)
  (define-key pdf-view-mode-map (kbd "f") #'my/pdf-fit-page)
  (define-key pdf-view-mode-map (kbd "g") #'my/pdf-goto-page)
  (define-key pdf-view-mode-map (kbd "s") #'isearch-forward)
  (define-key pdf-view-mode-map (kbd "o") #'my/pdf-toggle-outline-sidebar)
  (define-key pdf-view-mode-map (kbd "b") #'pdf-history-backward)
  (define-key pdf-view-mode-map (kbd "r") #'pdf-history-forward)
  (define-key pdf-view-mode-map (kbd "i") #'my/pdf-immersive-enter)
  (define-key pdf-view-mode-map (kbd "m") #'my/pdf-toggle-night-mode)
  (define-key pdf-view-mode-map (kbd "a h") #'pdf-annot-add-highlight-markup-annotation)
  (define-key pdf-view-mode-map (kbd "a u") #'pdf-annot-add-underline-markup-annotation)
  (define-key pdf-view-mode-map (kbd "a s") #'pdf-annot-add-squiggly-markup-annotation)
  (define-key pdf-view-mode-map (kbd "a o") #'pdf-annot-add-strikeout-markup-annotation)
  (define-key pdf-view-mode-map (kbd "a t") #'pdf-annot-add-text-annotation)
  (define-key pdf-view-mode-map (kbd "a l") #'pdf-annot-list-annotations)
  (define-key pdf-view-mode-map (kbd "a d") #'pdf-annot-delete)
  (define-key pdf-view-mode-map (kbd "a e") #'pdf-annot-edit)
  (define-key pdf-view-mode-map (kbd "a n") #'my/pdf-next-annotation)
  (define-key pdf-view-mode-map (kbd "a p") #'my/pdf-previous-annotation)
  (define-key pdf-view-mode-map (kbd "B") #'my/pdf-toggle-bookmark)
  (define-key pdf-view-mode-map (kbd "C-c b m") #'my/pdf-toggle-bookmark)
  (define-key pdf-view-mode-map (kbd "C-c b j") #'my/pdf-jump-to-bookmark)
  (define-key pdf-view-mode-map (kbd "C-c b d") #'my/pdf-delete-bookmark)
  (define-key pdf-view-mode-map (kbd "C-c b n") #'my/pdf-next-bookmark)
  (define-key pdf-view-mode-map (kbd "C-c b p") #'my/pdf-previous-bookmark))


(provide 'mod-pdf)
;;; mod-pdf.el ends here
