;;; lang-cc.el --- c & cpp configuration -*- lexical-binding: t -*-
;;; Commentary:

;;; Code:
(use-package c++-mode
 :functions  ; suppress warnings
 c-toggle-hungry-state
 :hook
 (c-mode . lsp-deferred)
 (c++-mode . c-ts-mode)
 (c++-mode . lsp-deferred)
 (c++-mode . c-toggle-hungry-state)
 :config
 (setq c-default-style "google"
        c-basic-offset 2))

(use-package cmake-mode
  :ensure t
  :mode ("CMakeLists\\.txt\\'" "\\.cmake\\'")
  :hook (cmake-mode . (lambda ()
                        (setq indent-tabs-mode nil)
                        (whitespace-mode 1)))
  (cmake-mode . lsp-deferred))

(use-package cmake-font-lock
  :ensure t
  :after cmake-mode
  :config
  (cmake-font-lock-activate))

(use-package cmake-ts-mode
  :ensure nil
  :mode ("CMakeLists\\.txt\\'" "\\.cmake\\'"))

(use-package c-ts-mode
  :ensure nil
  :mode ("\\.cpp\\'" "\\.c\\'" "\\.h\\'"))

(provide 'lang-cc)
;;; lang-cc.el ends here
