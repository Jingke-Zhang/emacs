;;; lang-cc.el --- c & cpp configuration -*- lexical-binding: t -*-
;;; Commentary:

;;; Code:

(defun my/google-c-ts-style ()
  "Google C/C++ style settings for tree-sitter C modes."
  (setq-local c-ts-mode-indent-offset 2)
  (setq-local c-ts-mode-indent-style 'bsd)
  (setq-local indent-tabs-mode nil)
  (setq-local tab-width 2)
  (setq-local fill-column 80))

(defconst my/doxygen-tags
  '("@author" "@brief" "@bug" "@code" "@date" "@deprecated" "@details"
    "@endcode" "@example" "@file" "@note" "@param" "@return" "@retval"
    "@see" "@since" "@tparam" "@throw" "@throws" "@todo" "@version"
    "@warning")
  "Doxygen tags offered for completion in C/C++ comments.")

(defconst my/doxygen-tag-regexp
  (concat "\\(?:^\\|[^[:alnum:]_]\\)\\("
          (regexp-opt my/doxygen-tags)
          "\\)\\_>")
  "Regexp matching Doxygen tags in C/C++ comments.")

(defun my/c-ts-doxygen-font-lock-setup ()
  "Highlight Doxygen tags in C/C++ tree-sitter comments."
  (font-lock-add-keywords
   nil
   `((,my/doxygen-tag-regexp 1 font-lock-keyword-face prepend))
   'append))

(defun my/c-ts-doxygen-capf ()
  "Complete Doxygen tags at point inside C/C++ comments."
  (when (nth 4 (syntax-ppss))
    (let ((end (point)))
      (when (save-excursion
              (skip-chars-backward "[:alnum:]_")
              (eq (char-before) ?@))
        (save-excursion
          (skip-chars-backward "[:alnum:]_")
          (let ((start (1- (point))))
            (list start end my/doxygen-tags
                  :exclusive 'no
                  :annotation-function
                  (lambda (_candidate) " Doxygen"))))))))

(defun my/c-ts-doxygen-completion-setup ()
  "Enable Doxygen tag completion in C/C++ tree-sitter comments."
  (add-hook 'completion-at-point-functions #'my/c-ts-doxygen-capf nil t))

(use-package c-ts-mode
  :ensure nil
  :defer t
  :init
  (add-to-list 'major-mode-remap-alist '(c-mode . c-ts-mode))
  (add-to-list 'major-mode-remap-alist '(c++-mode . c++-ts-mode))
  (add-to-list 'major-mode-remap-alist '(c-or-c++-mode . c-or-c++-ts-mode))
  (with-eval-after-load 'treesit
    (dolist (lang-src '((c "https://github.com/tree-sitter/tree-sitter-c")
                        (cpp "https://github.com/tree-sitter/tree-sitter-cpp")
                        (cmake "https://github.com/uyha/tree-sitter-cmake")))
      (add-to-list 'treesit-language-source-alist lang-src)))

  :hook
  ((c-ts-mode c++-ts-mode) . my/google-c-ts-style)
  ((c-ts-mode c++-ts-mode) . my/c-ts-doxygen-font-lock-setup)
  ((c-ts-mode c++-ts-mode) . my/c-ts-doxygen-completion-setup)
  ((c-ts-mode c++-ts-mode) . lsp-deferred))

(use-package cmake-ts-mode
  :ensure nil
  :defer t
  :mode ("CMakeLists\\.txt\\'" "\\.cmake\\'")
  :hook (cmake-ts-mode . lsp-deferred))

(provide 'lang-cc)
;;; lang-cc.el ends here
