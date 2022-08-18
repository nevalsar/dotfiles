(setq inhibit-startup-message t)	; disable startup message
(menu-bar-mode -1)			; hide menu bar
(tool-bar-mode -1)			; hide tool bar
(column-number-mode)			; show column numbers
(global-display-line-numbers-mode)	; show line numbers
;; (setq-default line-spacing 2)

; use a central backup folder
(setq backup-directory-alist `(("." . "~/.emacs-saves")))

;; Configure scroll behaviour
(setq scroll-margin 3
      scroll-step 1
      hscroll-step 1
      hscroll-margin 1
      scroll-conservatively 101
      scroll-up-aggressively 0.01
      scroll-down-aggressively 0.01
      mouse-wheel-scroll-amount '(2 ((shift) . 1))	; mouse scrolls by 2 lines, by 1 if shift is held
      mouse-wheel-progressive-speed nil)

(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)

;; --------------------------------------------------
;; Using straight.el for package management
;; --------------------------------------------------

(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

;; Prevent package.el loading packages prior to init-file loading
(setq package-enable-at-startup nil)  
;; Set up use-package integration with straight.el
(straight-use-package 'use-package)
;; Ensure packages are installed, download if misisng
;; Equivalent to setting `:ensure t` for all packages
(setq straight-use-package-by-default t)

;; --------------------------------------------------

;; Configure color theme
;; https://github.com/hlissner/emacs-doom-themes
(use-package doom-themes
  :config
  (load-theme 'doom-tomorrow-night t)
  (doom-themes-visual-bell-config)
  (doom-themes-org-config))

;; Configure doom-modeline status bar
;; https://github.com/seagle0128/doom-modeline
(use-package doom-modeline
  :init (doom-modeline-mode t)
  :custom
  (doom-modeline-height 25)
  (doom-modeline-icon t)
  (doom-modeline-major-mode-icon t)
  (doom-modeline-major-mode-color-icon t)
  (doom-modeline-buffer-file-name-style 'truncate-upto-project)
  (doom-modeline-buffer-state-icon t)
  (doom-modeline-buffer-modification-icon t))

;; Magit git porcelain
;; https://github.com/magit/magit
(use-package magit)

;; Rainbow delimiters
;; https://github.com/Fanael/rainbow-delimiters
(use-package rainbow-delimiters)
(with-eval-after-load 'rainbow-delimiters
  (add-hook 'prog-mode-hook #'rainbow-delimiters-mode))


;; Add vertico completion UI
;; https://github.com/minad/vertico
(use-package vertico
  :custom
  (vertico-cycle t)
  :init
  (vertico-mode)
  )

;; Add orderless for orderless completion
;; https://github.com/oantolin/orderless
(use-package orderless
  :init
  (setq completion-styles '(orderless)
        completion-category-defaults nil
        completion-category-overrides '((file (styles partial-completion)))))

;; A few more useful configurations...
(use-package emacs
  :init
  ;; Add prompt indicator to `completing-read-multiple'.
  ;; Alternatively try `consult-completing-read-multiple'.
  (defun crm-indicator (args)
    (cons (concat "[CRM] " (car args)) (cdr args)))
  (advice-add #'completing-read-multiple :filter-args #'crm-indicator)

  ;; Do not allow the cursor in the minibuffer prompt
  (setq minibuffer-prompt-properties
        '(read-only t cursor-intangible t face minibuffer-prompt))
  (add-hook 'minibuffer-setup-hook #'cursor-intangible-mode)

  ;; Emacs 28: Hide commands in M-x which do not work in the current mode.
  ;; Vertico commands are hidden in normal buffers.
  ;; (setq read-extended-command-predicate
  ;;       #'command-completion-default-include-p)

  ;; Enable recursive minibuffers
  (setq enable-recursive-minibuffers t))
;; End set up vertico

;; Persist history over Emacs restarts.
(use-package savehist
  :init
  (savehist-mode))

;; Add marginalia for annotations to minibuffer completions
;; https://github.com/minad/marginalia
(use-package marginalia
  :after vertico
  :ensure t
  :custom
  (marginalia-annotators '(marginalia-annotators-heavy marginalia-annotators-light nil))
  :init
  (marginalia-mode))

;; Add markdown support
;; https://github.com/jrblevin/markdown-mode
(use-package markdown-mode
  :mode ("README\\.md\\'" . gfm-mode)
  :init (setq markdown-command "marked"))

;; Rename current buffer and visited file in-place
;; https://stackoverflow.com/questions/384284/how-do-i-rename-an-open-file-in-emacs
(defun rename-current-buffer-file ()
  "Renames current buffer and file it is visiting."
  (interactive)
  (let* ((name (buffer-name))
        (filename (buffer-file-name))
        (basename (file-name-nondirectory filename)))
    (if (not (and filename (file-exists-p filename)))
        (error "Buffer '%s' is not visiting a file!" name)
      (let ((new-name (read-file-name "New name: " (file-name-directory filename) basename nil basename)))
        (if (get-buffer new-name)
            (error "A buffer named '%s' already exists!" new-name)
          (rename-file filename new-name 1)
          (rename-buffer new-name)
          (set-visited-file-name new-name)
          (set-buffer-modified-p nil)
          (message "File '%s' successfully renamed to '%s'"
                   name (file-name-nondirectory new-name)))))))

;; Install latest version of org
;; https://elpa.gnu.org/packages/org.html
(use-package org)

;; Load languages for org-babel
;; https://orgmode.org/worg/org-contrib/babel/languages/index.html
(org-babel-do-load-languages
 'org-babel-load-languages
 '(
   (shell . t)
   (python . t)
  ))

;; ;; Org-mode
;; ;; (setq org-hide-emphasis-markers t)
;; ;; Improve org mode looks
;; (setq org-startup-indented t
;;   org-pretty-entities t
;;   org-hide-emphasis-markers t
;;   org-startup-with-inline-images t
;;   org-image-actual-width '(300))

;; ;; Show hidden emphasis markers
;; ;; Render latex characters
;; (use-package org-appear
;;   :hook (org-mode . org-appear-mode))

;; ;; Increase size of LaTeX fragment previews
;;   (plist-put org-format-latex-options :scale 4)

;; ;; Set default, fixed and variabel pitch fonts
;; ;; Use M-x menu-set-font to view available fonts
;; (use-package mixed-pitch
;;   :hook
;;   (text-mode . mixed-pitch-mode)
;;   :config
;;   (set-face-attribute 'default nil :font "DejaVu Sans Mono" :height 140)
;;   (set-face-attribute 'fixed-pitch nil :font "SauceCodePro Nerd Font")
;;   (set-face-attribute 'variable-pitch nil :font "ETBembo"))

;; ;; org-superstar for pretty bullets in org mode
;; ;; https://github.com/sabof/org-bullets
;; (use-package org-superstar
;;   :after org
;;   :config
;;   (add-hook 'org-mode-hook (lambda () (org-superstar-mode 1)))
;;   :custom
;;   (org-superstar-remove-leading-stars t)
;;   (org-superstar-headline-bullets-list '("◉" "○" "●" "○" "●" "○" "●")))


(setq
 ;; Edit settings
 org-auto-align-tags nil
 org-tags-column 0
 org-catch-invisible-edits 'show-and-error
 org-special-ctrl-a/e t
 org-insert-heading-respect-content t

 ;; Org styling, hide markup etc.
 org-hide-emphasis-markers t
 org-pretty-entities t
 org-ellipsis "…"

 ;; Agenda styling
 org-agenda-block-separator ?─
 org-agenda-time-grid
 '((daily today require-timed)
   (800 1000 1200 1400 1600 1800 2000)
   " ┄┄┄┄┄ " "┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄")
 org-agenda-current-time-string
 "⭠ now ─────────────────────────────────────────────────")

(use-package org-modern
  :hook
  (org-mode . org-modern-mode)
  (org-agenda-finalize . org-modern-agenda))

;; Add deft-mode
;; https://jblevins.org/projects/deft/
(use-package deft
  :commands (deft)
  :config (setq deft-directory "~/notes"
                deft-recursive t
                deft-default-extension "md"
                deft-new-file-format "%Y_%m_%d-T%H%M"))

;; Add undo-tree-mode
;; https://elpa.gnu.org/packages/undo-tree.html
(use-package undo-tree
  :config
  (global-undo-tree-mode))

;; page-break-lines
;; https://github.com/purcell/page-break-lines
(use-package page-break-lines
  :config
  (global-page-break-lines-mode))

;; emacs-dashboard
;; https://github.com/emacs-dashboard/emacs-dashboard
(use-package dashboard
  :init
  (setq initial-buffer-choice (lambda () (get-buffer "*dashboard*")))
  (setq dashboard-startup-banner 'logo)
  (setq dashboard-banner-logo-title "Emacs Dashboard")
  (setq dashboard-page-separator "\n\n\f\n\n")
  :config
  (dashboard-setup-startup-hook))

;; diff-hl - Provides git gutter
;; https://github.com/dgutov/diff-hl
(use-package diff-hl
  :config
  (global-diff-hl-mode)
  (add-hook 'magit-pre-refresh-hook 'diff-hl-magit-pre-refresh)
  (add-hook 'magit-post-refresh-hook 'diff-hl-magit-post-refresh))


;; Configure clang-format
(when (file-exists-p "/usr/share/emacs/site-lisp/clang-format-12/clang-format.el")
  (progn
    (load "/usr/share/emacs/site-lisp/clang-format-12/clang-format.el")
    (global-set-key [C-M-tab] 'clang-format-region)
    (require 'clang-format)
    (setq clang-format-style "file")))
