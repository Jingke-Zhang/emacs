;;; core-comp.el --- setup completion system -*- lexical-binding: t -*-
;;; Commentary:

;;; Code:
;; Enable Vertico.
(use-package vertico
  :ensure t
  :defer t
  :custom
  (vertico-scroll-margin 2) ;; Different scroll margin
  (vertico-count 20) ;; Show more candidates
  (vertico-resize nil) ;; Grow and shrink the Vertico minibuffer
  (vertico-cycle t) ;; Enable cycling for `vertico-next/previous'
  :init
  (vertico-mode)
  :config
  (define-key vertico-map (kbd "<backspace>") #'vertico-directory-delete-char))

;; Emacs minibuffer configurations.
(use-package emacs
  :custom
  (context-menu-mode t)
  (enable-recursive-minibuffers t)
  (read-extended-command-predicate #'command-completion-default-include-p)
  (minibuffer-prompt-properties
   '(read-only t cursor-intangible t face minibuffer-prompt)))

;; Persist history over Emacs restarts. Vertico sorts by history position.
(use-package savehist
  :init
  (savehist-mode))

;; Consult for better searching
(use-package consult
  :ensure t
  :defer t
  :general
  (general-define-key
   [remap switch-to-buffer]              #'consult-buffer
   [remap switch-to-buffer-other-window] #'consult-buffer-other-window
   [remap bookmark-jump]                 #'consult-bookmark
   [remap project-switch-to-buffer]      #'consult-project-buffer
   [remap yank-pop]                      #'consult-yank-pop
   [remap goto-line]                     #'consult-goto-line
   [remap imenu]                         #'consult-imenu)

  :init
  (advice-add #'register-preview :override #'consult-register-window)
  (setq register-preview-delay 0.5)
  (setq xref-show-xrefs-function #'consult-xref
        xref-show-definitions-function #'consult-xref)

  :config
  (consult-customize
   consult-theme :preview-key '(:debounce 0.2 any)
   consult-ripgrep consult-git-grep consult-grep consult-man
   consult-bookmark consult-recent-file consult-xref
   :preview-key '(:debounce 0.4 any))

  (setq consult-narrow-key "<"))

;; Completion
(use-package corfu
  :ensure t
  :defer t
  :custom
  (corfu-cycle t)                ;; Enable cycling for `corfu-next/previous'
  (corfu-quit-at-boundary nil)   ;; Never quit at completion boundary
  (corfu-preview-current t)
  
  :init
  (global-corfu-mode)

  (corfu-history-mode)
  (corfu-popupinfo-mode)
    
  :custom
  (corfu-auto nil)
  (corfu-min-width 80)
  (corfu-max-width corfu-min-width)       ; Always have the same width
  (corfu-count 14)
  (corfu-scroll-margin 4)
  :general
  ("M-/" 'completion-at-point))
  
;; Emacs completion configuration
(use-package emacs
  :custom
  (tab-always-indent t)
  (text-mode-ispell-word-completion nil)
  (read-extended-command-predicate #'command-completion-default-include-p))


(use-package cape
  :ensure t
  :defer t
  :init
  (add-hook 'completion-at-point-functions #'cape-dabbrev)
  (add-hook 'completion-at-point-functions #'cape-file)
  (add-hook 'completion-at-point-functions #'cape-elisp-block)
  (add-hook 'completion-at-point-functions #'cape-history)
  ;; :general
  ;; ("M-p" cape-prefix-map)
)

;; Optionally use the `orderless' completion style.
(use-package orderless
  :demand t
  :ensure t
  :config
  (setq completion-styles '(orderless partial-completion)
        completion-category-defaults nil
        completion-category-overrides '((file (styles . (partial-completion))))))

(use-package nerd-icons-corfu
  :ensure t
  :defer t
  :after corfu
  :init (add-to-list 'corfu-margin-formatters #'nerd-icons-corfu-formatter))

;; Enable rich annotations using the Marginalia package
(use-package marginalia
  :ensure t
  :defer t
  :bind (:map minibuffer-local-map
         ("M-A" . marginalia-cycle))
  :init
  (marginalia-mode))

(provide 'core-comp)
;;; core-comp.el ends here
