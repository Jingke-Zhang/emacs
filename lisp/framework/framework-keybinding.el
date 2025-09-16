;;; framework-keybinding.el --- setup keybinding system -*- lexical-binding: t -*-
;;; Commentary:

;;; Code:
(use-package hydra
  :ensure (:wait t))

(use-package use-package-hydra
  :ensure (:wait t)
  :after hydra)

(use-package which-key
  :ensure t
  :init
  (which-key-mode)
  :config
  (setq which-key-popup-type 'minibuffer
	which-key-separator " → "
	which-key-unicode-correction 3
	which-key-idle-delay 0.5))

(use-package general
  :ensure (:wait t)
  :demand t
  :config
  (general-unbind
    "C-x f")
  (general-create-definer my/find-file-def
    :prefix "C-x f")
  (general-create-definer my/toggle-def
    :prefix "C-x t"))

;;; Hydra block
(defhydra hydra-base
  (:pre (set-cursor-color "#40e0d0")
   :post (progn
           (set-cursor-color "#ffffff"))
   :foreign-keys warn
   :hint nil)
  "
Movement               Fold (z-*)                Other
----------------------------------------------------------
_f_: forward             _zc_: close                 _q_: exit            
_b_: backward            _zo_: open                  _=_: expand region
_n_: next line           _zM_: close all
_p_: previous line       _zR_: open all
_a_: beginning of line
_e_: end of line
"
  ;; Movement
  ("n" next-line)
  ("p" previous-line)
  ("f" forward-char)
  ("b" backward-char)
  ("a" mwim-beginning-of-code-or-line)
  ("e" mwim-end-of-code-or-line)
  ;; Fold
  ("zc" hs-hide-block)
  ("zo" hs-show-block)
  ("zM" hs-hide-all)
  ("zR" hs-show-all)
  ;; Other
  ("q" nil)
  ("=" er/expand-region))

(general-define-key
 "C-o" 'hydra-base/body)

(provide 'framework-keybinding)
;;; framework-keybinding.el ends here
