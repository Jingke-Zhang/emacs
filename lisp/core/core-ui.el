;;; core-ui.el --- configure ui -*- lexical-binding: t -*-
;;; Commentary:

;;; Code:
;; Font
(set-face-attribute 'default nil
                    :family "CodeNewRoman Nerd Font Mono"
                    :height 150
                    :weight 'regular)

(set-face-attribute 'variable-pitch nil
                    :family "Optima"
                    :height 1.1)

(set-face-attribute 'fixed-pitch nil
                    :family "CodeNewRoman Nerd Font Mono"
                    :height 1.0)

;; Provide icons
(use-package nerd-icons
  :ensure t)

;; Some display settings
(tool-bar-mode -1)
(when (display-graphic-p) (toggle-scroll-bar -1))
(setq inhibit-startup-screen t)
(global-hl-line-mode 1)

(defun my/center-frame (&optional frame)
  "Center FRAME on its current monitor."
  (interactive)
  (let ((frame (or frame (selected-frame))))
    (when (display-graphic-p frame)
      (let* ((workarea (alist-get 'workarea (frame-monitor-attributes frame)))
             (left (nth 0 workarea))
             (top (nth 1 workarea))
             (width (nth 2 workarea))
             (height (nth 3 workarea))
             (frame-width (frame-pixel-width frame))
             (frame-height (frame-pixel-height frame)))
      (set-frame-position
       frame
       (+ left (max 0 (/ (- width frame-width) 2)))
       (+ top (max 0 (/ (- height frame-height) 2))))))))

(defcustom my/default-font-height 150
  "Default font height used by display controls."
  :type 'integer)

(defun my/adjust-default-font-height (delta)
  "Adjust the default font height by DELTA."
  (let ((height (+ (face-attribute 'default :height nil) delta)))
    (set-face-attribute 'default nil :height (max 80 height))))

(defun my/increase-default-font-height ()
  "Increase the default font height."
  (interactive)
  (my/adjust-default-font-height 10))

(defun my/decrease-default-font-height ()
  "Decrease the default font height."
  (interactive)
  (my/adjust-default-font-height -10))

(defun my/reset-default-font-height ()
  "Reset the default font height."
  (interactive)
  (set-face-attribute 'default nil :height my/default-font-height))

(defun my/toggle-frame-fullscreen ()
  "Toggle fullscreen for the selected frame."
  (interactive)
  (set-frame-parameter
   nil 'fullscreen
   (unless (frame-parameter nil 'fullscreen)
     'fullboth)))

(defun my/run-display-control-command (command)
  "Run COMMAND and keep the display hydra alive on errors."
  (condition-case err
      (call-interactively command)
    (error
     (message "%s" (error-message-string err)))))

(defun my/resize-selected-frame (width-delta height-delta)
  "Resize the selected frame by WIDTH-DELTA and HEIGHT-DELTA."
  (let* ((frame (selected-frame))
         (width (max 40 (+ (frame-width frame) width-delta)))
         (height (max 10 (+ (frame-height frame) height-delta))))
    (set-frame-size frame width height)))

(defun my/narrower-frame ()
  "Make the selected frame narrower."
  (interactive)
  (my/resize-selected-frame -5 0))

(defun my/wider-frame ()
  "Make the selected frame wider."
  (interactive)
  (my/resize-selected-frame 5 0))

(defun my/taller-frame ()
  "Make the selected frame taller."
  (interactive)
  (my/resize-selected-frame 0 2))

(defun my/shorter-frame ()
  "Make the selected frame shorter."
  (interactive)
  (my/resize-selected-frame 0 -2))

(defun my/reset-frame-size ()
  "Reset the selected frame size and center it."
  (interactive)
  (set-frame-size
   (selected-frame)
   (or (alist-get 'width default-frame-alist) 120)
   (or (alist-get 'height default-frame-alist) 50))
  (my/center-frame))

(require 'hydra)

(defhydra my/hydra-display-control (:hint nil :color amaranth)
  "
Font: _+_ bigger  _-_ smaller  _0_ reset
Frame: _f_ fullscreen  _r_ reset  _c_ center  _h_ narrower  _l_ wider  _j_ taller  _k_ shorter
"
  ("+" (my/run-display-control-command #'my/increase-default-font-height))
  ("=" (my/run-display-control-command #'my/increase-default-font-height))
  ("-" (my/run-display-control-command #'my/decrease-default-font-height))
  ("0" (my/run-display-control-command #'my/reset-default-font-height))
  ("f" (my/run-display-control-command #'my/toggle-frame-fullscreen))
  ("r" (my/run-display-control-command #'my/reset-frame-size))
  ("c" (my/run-display-control-command #'my/center-frame))
  ("h" (my/run-display-control-command #'my/narrower-frame))
  ("l" (my/run-display-control-command #'my/wider-frame))
  ("j" (my/run-display-control-command #'my/taller-frame))
  ("k" (my/run-display-control-command #'my/shorter-frame))
  ("<left>" (my/run-display-control-command #'my/narrower-frame))
  ("<right>" (my/run-display-control-command #'my/wider-frame))
  ("<down>" (my/run-display-control-command #'my/taller-frame))
  ("<up>" (my/run-display-control-command #'my/shorter-frame))
  ("q" nil "quit" :color blue))

(my/leader-def
  "v" 'my/hydra-display-control/body)

;; Themes
(use-package catppuccin-theme
  :ensure t
  :config
  (setq catppuccin-flavor 'latte)
  (load-theme 'catppuccin t)

  (defun my/transparent-emacs ()
    (unless (display-graphic-p)
      (set-face-background 'default "unspecified-bg")
      (set-face-background 'line-number "unspecified-bg")
      (set-face-background 'fringe "unspecified-bg")))

  (add-hook 'after-make-frame-functions
            (lambda (frame)
              (with-selected-frame frame
                (my/transparent-emacs)))))

;; Modeline
(use-package doom-modeline
  :ensure t
  :init
  (setq doom-modeline-support-imenu t
	    doom-modeline-height 25
	    doom-modeline-hud nil
        doom-modeline-project-detection 'project
        doom-modeline-indent-info t
	    doom-modeline-total-line-number t)
  (doom-modeline-mode 1))

;; Rainbow delimiters
(use-package rainbow-delimiters
  :ensure t
  :defer t
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package paren
  :ensure nil
  :config
  (setq show-paren-delay 0
        show-paren-style 'parenthesis))

(defun my/dashboard-pdf-file-p (file)
  "Return non-nil when FILE is a PDF."
  (string-match-p "\\.pdf\\'" file))

(defun my/dashboard-recent-files ()
  "Return recent files excluding PDFs."
  (seq-remove #'my/dashboard-pdf-file-p recentf-list))

(defun my/dashboard-recent-pdfs ()
  "Return recent PDF files."
  (seq-filter #'my/dashboard-pdf-file-p recentf-list))

(defun my/dashboard-insert-recents (list-size)
  "Add LIST-SIZE recent files, excluding PDFs."
  (setq dashboard--recentf-cache-item-format nil)
  (dashboard-mute-apply
    (recentf-mode 1)
    (when dashboard-remove-missing-entry
      (ignore-errors (recentf-cleanup))))
  (dashboard-insert-section
   "Recent Files:"
   (dashboard-shorten-paths (my/dashboard-recent-files)
                            'dashboard-recentf-alist 'recents)
   list-size
   'recents
   (dashboard-get-shortcut 'recents)
   `(lambda (&rest _)
      (find-file-existing (dashboard-expand-path-alist ,el dashboard-recentf-alist)))
   (let* ((file (dashboard-expand-path-alist el dashboard-recentf-alist))
          (filename (dashboard-f-filename file))
          (path (dashboard-extract-key-path-alist el dashboard-recentf-alist)))
     (cl-case dashboard-recentf-show-base
       (`align
        (unless dashboard--recentf-cache-item-format
          (let* ((len-align (dashboard--align-length-by-type 'recents))
                 (new-fmt (dashboard--generate-align-format
                           dashboard-recentf-item-format len-align)))
            (setq dashboard--recentf-cache-item-format new-fmt)))
        (format dashboard--recentf-cache-item-format filename path))
       (`nil path)
       (t (format dashboard-recentf-item-format filename path))))))

(defun my/dashboard-insert-pdfs (list-size)
  "Add LIST-SIZE recent PDF files."
  (dashboard-mute-apply
    (recentf-mode 1)
    (when dashboard-remove-missing-entry
      (ignore-errors (recentf-cleanup))))
  (dashboard-insert-section
   "PDF Files:"
   (dashboard-shorten-paths (my/dashboard-recent-pdfs)
                            'dashboard-recentf-alist 'pdfs)
   list-size
   'pdfs
   (dashboard-get-shortcut 'pdfs)
   `(lambda (&rest _)
      (find-file-existing (dashboard-expand-path-alist ,el dashboard-recentf-alist)))
   (let* ((file (dashboard-expand-path-alist el dashboard-recentf-alist))
          (filename (dashboard-f-filename file))
          (path (dashboard-extract-key-path-alist el dashboard-recentf-alist)))
     (format dashboard-recentf-item-format filename path))))

;; Dashboard 
(use-package dashboard
  :ensure t
  :demand t
  :init
  (setq dashboard-startup-banner (expand-file-name "attachment/emacs-e-logo.png" user-emacs-directory)
        dashboard-items '((recents   . 5)
                          (pdfs      . 5)
                          (projects  . 5))
        dashboard-item-shortcuts '((recents   . "r")
                                   (pdfs      . "d")
                                   (projects  . "P")))
  :config
  (add-to-list 'dashboard-item-generators '(pdfs . my/dashboard-insert-pdfs))
  (setf (alist-get 'recents dashboard-item-generators)
        #'my/dashboard-insert-recents)
  (dashboard-setup-startup-hook)
  (setq dashboard-navigation-cycle t
        dashboard-display-icons-p t
        dashboard-icon-type 'nerd-icons
        dashboard-set-heading-icons t
        dashboard-set-file-icons t)
  :general
  (:keymaps 'dashboard-mode-map
            "n" 'next-line
            "p" 'previous-line
            "f" 'forward-char
            "b" 'backward-char
            "P" 'dashboard-jump-to-projects
            "<return>" 'dashboard-return
            "g"        'dashboard-refresh-buffer
            "q"        'quit-window))

(use-package tab-bar
  :ensure nil
  :init
  (setq tab-bar-show 1)
  :config
  (setq tab-bar-close-button-show nil
        tab-bar-format '(tab-bar-format-history
                         tab-bar-format-tabs
                         tab-bar-separator)
        tab-bar-separator "  ")
  
  (set-face-attribute 'tab-bar nil :background (face-background 'default) :box nil)
  (set-face-attribute 'tab-bar-tab nil :background (face-foreground 'font-lock-function-name-face) :foreground (face-background 'default) :box nil)
  (set-face-attribute 'tab-bar-tab-inactive nil :background (face-background 'mode-line-inactive) :foreground (face-foreground 'default) :box nil)
  (tab-bar-mode 1))

(use-package nyan-mode
  :ensure t
  :init
  (nyan-mode 1)
  :config
  (setq nyan-wavy-trail t)
  (setq nyan-bar-length 16))

(use-package mixed-pitch
  :ensure t
  :hook
  (text-mode . mixed-pitch-mode))


(provide 'core-ui)
;;; core-ui.el ends here
