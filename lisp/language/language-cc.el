;;; language-cc.el --- c & cpp configuration -*- lexical-binding: t -*-
;;; Commentary:

;;; Code:
(use-package c++-mode
 :functions  ; suppress warnings
 c-toggle-hungry-state
 :hook
 (c-mode . lsp-deferred)
 (c++-mode . lsp-deferred)
 (c++-mode . c-toggle-hungry-state))

(provide 'language-cc)
;;; language-cc.el ends here
