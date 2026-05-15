;;; mod-tools.el --- some useful tools-*- lexical-binding: t -*-
;;; Commentary:

;;; Code:
(use-package embark
  :ensure t

  :bind
  (("C-." . embark-act)         ;; pick some comfortable binding
   ("M-." . embark-dwim)        ;; good alternative: M-.
   ("C-h B" . embark-bindings)) ;; alternative for `describe-bindings'

  :init

  ;; Optionally replace the key help with a completing-read interface
  (setq prefix-help-command #'embark-prefix-help-command)

  ;; Show the Embark target at point via Eldoc. You may adjust the
  ;; Eldoc strategy, if you want to see the documentation from
  ;; multiple providers. Beware that using this can be a little
  ;; jarring since the message shown in the minibuffer can be more
  ;; than one line, causing the modeline to move up and down:

  ;; (add-hook 'eldoc-documentation-functions #'embark-eldoc-first-target)
  ;; (setq eldoc-documentation-strategy #'eldoc-documentation-compose-eagerly)

  ;; Add Embark to the mouse context menu. Also enable `context-menu-mode'.
  ;; (context-menu-mode 1)
  ;; (add-hook 'context-menu-functions #'embark-context-menu 100)

  :config

  ;; Hide the mode line of the Embark live/completions buffers
  (add-to-list 'display-buffer-alist
               '("\\`\\*Embark Collect \\(Live\\|Completions\\)\\*"
                 nil
                 (window-parameters (mode-line-format . none)))))

(use-package embark-consult
  :ensure t)

(use-package dired
  :config
  (when (executable-find "gls")
    (setq insert-directory-program "gls"
          dired-listing-switches
          "-l --almost-all --human-readable --group-directories-first --no-group"))
  ;; this command is useful when you want to close the window of `dirvish-side'
  ;; automatically when opening a file
  (put 'dired-find-alternate-file 'disabled nil))

(defun my/dirvish-subtree-toggle ()
  "Toggle the subtree at point only when it is a directory."
  (interactive)
  (let ((file (dired-get-file-for-visit)))
    (when (file-directory-p file)
      (dirvish-subtree-toggle))))

(use-package dirvish
  :ensure t
  :init
  (dirvish-override-dired-mode)
  :custom
  (dirvish-quick-access-entries ; It's a custom option, `setq' won't work
   '(("h" "~/"                          "Home")
     ("d" "~/Downloads/"                "Downloads")
     ("m" "/mnt/"                       "Drives")
     ("t" "~/.local/share/Trash/files/" "TrashCan")))
  :config
  (dirvish-peek-mode)             ; Preview files in minibuffer
  (dirvish-side-follow-mode)      ; similar to `treemacs-follow-mode'
  (setq dirvish-mode-line-format
        '(:left (sort symlink) :right (omit yank index)))
  (setq dirvish-attributes           ; The order *MATTERS* for some attributes
        '(vc-state subtree-state nerd-icons collapse git-msg file-time file-size)
        dirvish-side-attributes
        '(vc-state nerd-icons collapse file-size))
  ;; open large directory (over 20000 files) asynchronously with `fd' command
  (setq dirvish-large-directory-threshold 20000)
  :bind ; Bind `dirvish-fd|dirvish-side|dirvish-dwim' as you see fit
  (:map dirvish-mode-map               ; Dirvish inherits `dired-mode-map'
   (";"   . dired-up-directory)        ; So you can adjust `dired' bindings here
   ("?"   . dirvish-dispatch)          ; [?] a helpful cheatsheet
   ("a"   . dirvish-setup-menu)        ; [a]ttributes settings:`t' toggles mtime, `f' toggles fullframe, etc.
   ("f"   . dirvish-file-info-menu)    ; [f]ile info
   ("o"   . dirvish-quick-access)      ; [o]pen `dirvish-quick-access-entries'
   ("s"   . dirvish-quicksort)         ; [s]ort flie list
   ("r"   . dirvish-history-jump)      ; [r]ecent visited
   ("l"   . dirvish-ls-switches-menu)  ; [l]s command flags
   ("v"   . dirvish-vc-menu)           ; [v]ersion control commands
   ("*"   . dirvish-mark-menu)
   ("y"   . dirvish-yank-menu)
   ("N"   . dirvish-narrow)
   ("^"   . dirvish-history-last)
   ("TAB" . my/dirvish-subtree-toggle)
   ("M-f" . dirvish-history-go-forward)
   ("M-b" . dirvish-history-go-backward)
   ("M-e" . dirvish-emerge-menu)))

(use-package expand-region
  :ensure t
  :defer t
  :general
  ("C-=" 'er/expand-region))

(use-package hideshow
  :hook
  (prog-mode . hs-minor-mode)
  :general
  ("M-t" 'hs-toggle-hiding
   "C-M-t" 'hs-hide-all
   "M-T" 'hs-show-all))

(use-package ace-window
  :ensure t
  :defer t
  :general
  ("M-o" 'ace-window))

(use-package mwim
  :ensure t
  :defer t
  :general
  ("C-a" 'mwim-beginning-of-code-or-line
   "C-e" 'mwim-end-of-code-or-line))

(use-package avy
  :ensure t
  :defer t
  :general
  ("C-;" 'avy-goto-char-timer))

(use-package exec-path-from-shell
  :if (memq window-system '(mac ns))
  :ensure t
  :hook (after-init . exec-path-from-shell-initialize))

(use-package vterm
  :ensure t
  :defer t
  :config
  (setq vterm-kill-buffer-on-exit t
	vterm-timer-delay nil
	vterm-module-cmake-args "-DUSE_SYSTEM_LIBVTERM=no"
	vterm-max-scrollback 10000))
    
(use-package vterm-toggle
  :ensure t
  :after vterm
  :defer t
  :config
  (setq vterm-toggle-fullscreen-p nil)

  (add-to-list 'display-buffer-alist
               '((lambda (buffer-or-name _)
                   (let ((buffer (get-buffer buffer-or-name)))
                     (with-current-buffer buffer
                       (or (equal major-mode 'vterm-mode)
                           (string-prefix-p vterm-buffer-name (buffer-name buffer))))))
                 (display-buffer-reuse-window display-buffer-at-bottom)
                 (window-height . 0.3)
                 (reusable-frames . visible)
                 (window-parameters . ((select . t)))))
  :general
  (:keymaps 'vterm-mode-map
            ;; "C-t" 'vterm-toggle
            "C-<return>" 'vterm-toggle-insert-cd
            "C-y" 'vterm-yank))

(general-define-key
 :keymaps 'override
 "C-t" 'vterm-toggle)

(provide 'mod-tools)
;;; mod-tools.el ends here
