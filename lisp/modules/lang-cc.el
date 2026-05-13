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

(use-package c-ts-mode
  :ensure nil
  :defer t
  :init
  (add-to-list 'major-mode-remap-alist '(c-mode . c-ts-mode))
  (add-to-list 'major-mode-remap-alist '(c++-mode . c++-ts-mode))
  (add-to-list 'major-mode-remap-alist '(c-or-c++-mode . c-or-c++-ts-mode))

  :config
  (dolist (lang-src '((c "https://github.com/tree-sitter/tree-sitter-c")
                      (cpp "https://github.com/tree-sitter/tree-sitter-cpp")
                      (cmake "https://github.com/uyha/tree-sitter-cmake")))
    (add-to-list 'treesit-language-source-alist lang-src))

  :hook
  ((c-ts-mode c++-ts-mode) . my/google-c-ts-style)
  ((c-ts-mode c++-ts-mode) . lsp-deferred))

(use-package cmake-ts-mode
  :ensure nil
  :defer t
  :mode ("CMakeLists\\.txt\\'" "\\.cmake\\'")
  :hook (cmake-ts-mode . lsp-deferred))

(provide 'lang-cc)
;;; lang-cc.el ends here
