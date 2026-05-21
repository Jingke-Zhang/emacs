;;; mod-dict.el --- dictionary lookup -*- lexical-binding: t -*-
;;; Commentary:

;;; Code:

(require 'dictionary)
(require 'subr-x)

(defgroup my/dict nil
  "Dictionary lookup helpers."
  :group 'tools)

(defcustom my/dict-server "dict.org"
  "Dictionary server used by `dictionary-search'."
  :type 'string)

(defcustom my/dict-default-dictionary "*"
  "Default dictionary used by `dictionary-search'."
  :type 'string)

(defun my/dict--thing-at-point ()
  "Return active region text or symbol at point."
  (string-trim
   (cond
    ((use-region-p)
     (buffer-substring-no-properties (region-beginning) (region-end)))
    ((thing-at-point 'word t))
    ((thing-at-point 'symbol t))
    (t ""))))

(defun my/dict-lookup (query)
  "Look up QUERY in an Emacs dictionary buffer."
  (interactive
   (let ((default (my/dict--thing-at-point)))
     (list (read-string
            (if (string-empty-p default)
                "Dictionary lookup: "
              (format "Dictionary lookup (%s): " default))
            nil nil default))))
  (setq query (string-trim query))
  (unless (string-empty-p query)
    (let ((dictionary-server my/dict-server)
          (dictionary-default-dictionary my/dict-default-dictionary))
      (dictionary-search query my/dict-default-dictionary))))

(my/leader-def
  "d" 'my/dict-lookup)

(provide 'mod-dict)
;;; mod-dict.el ends here
