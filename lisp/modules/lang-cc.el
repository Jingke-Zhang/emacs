;;; lang-cc.el --- c & cpp configuration -*- lexical-binding: t -*-
;;; Commentary:

;;; Code:
;; (use-package c++-mode
;;  :functions  ; suppress warnings
;;  c-toggle-hungry-state
;;  :hook
;;  (c-mode . lsp-deferred)
;;  (c++-mode . c-ts-mode)
;;  (c++-mode . lsp-deferred)
;;  (c++-mode . c-toggle-hungry-state)
;;  :config
;;  (setq c-default-style "google"
;;         c-basic-offset 2))
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
  
  (setq c-ts-mode-indent-offset 2)
  (setq c-ts-mode-indent-style 'k&r)
  
  :hook
  ((c-ts-mode c++-ts-mode) . lsp-deferred))

;; (use-package cmake-mode
;;   :ensure t
;;   :mode ("CMakeLists\\.txt\\'" "\\.cmake\\'")
;;   :hook (cmake-mode . (lambda ()
;;                         (setq indent-tabs-mode nil)
;;                         (whitespace-mode 1)))
;;   (cmake-mode . lsp-deferred))

;; (use-package cmake-font-lock
;;   :ensure t
;;   :defer t
;;   :after cmake-mode
;;   :config
;;   (cmake-font-lock-activate))

(use-package cmake-ts-mode
  :ensure nil
  :defer t
  :mode ("CMakeLists\\.txt\\'" "\\.cmake\\'")
  :hook (cmake-ts-mode . lsp-deferred))

(provide 'lang-cc)
;;; lang-cc.el ends here
