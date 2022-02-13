(setq inhibit-startup-message t)	; disable startup message
(menu-bar-mode -1)			; hide menu bar
(tool-bar-mode -1)			; hide tool bar
(column-number-mode)			; show column numbers
(global-display-line-numbers-mode)	; show line numbers

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

;; Set up use-package integration with straight.el
(straight-use-package 'use-package)
(setq straight-use-package-by-default t)

;; --------------------------------------------------

;; Configure color theme
;; https://github.com/hlissner/emacs-doom-themes
(use-package doom-themes
  :ensure t
  :config
  (load-theme 'doom-tomorrow-night t)
  (doom-themes-visual-bell-config)
  (doom-themes-org-config))

;; Configure doom-modeline status bar
;; https://github.com/seagle0128/doom-modeline
(use-package doom-modeline
  :ensure t
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


;; Ivy, Counsel and Swiper
;; https://github.com/abo-abo/swiper
(use-package ivy
  :diminish
  :config
  (ivy-mode)
  (setq ivy-use-virtual-buffers t
    ivy-count-format "(%d/%d) "))

(use-package counsel
  :after ivy
  :config (counsel-mode))

;; Ivy-rich: Rich output from Ivy and Counsel
;; https://github.com/Yevgnen/ivy-rich
(use-package ivy-rich
  :hook (counsel-mode . ivy-rich-mode)
  :config
  (setq ivy-rich-parse-remote-buffer nil))

;; Use Ivy to search and diff files
;; https://github.com/redguardtoo/find-file-in-project
(use-package find-file-in-project)


;; Add markdown support
;; https://github.com/jrblevin/markdown-mode
(use-package markdown-mode
  :mode ("README\\.md\\'" . gfm-mode)
  :init (setq markdown-command "multimarkdown"))

;; Add deft-mode
;; https://jblevins.org/projects/deft/
(use-package deft
  :commands (deft)
  :config (setq deft-directory "~/notes"
                deft-recursive t
                deft-default-extension "md"
                deft-new-file-format "%Y_%m_%d-T%H%M"))

;; Add prescient.el for frecency-based completion
;; https://github.com/raxod502/prescient.el
(use-package ivy-prescient
  :after counsel
  :config
  (ivy-prescient-mode 1))

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

;; Load languages for org-babel
;; https://orgmode.org/worg/org-contrib/babel/languages/index.html
(org-babel-do-load-languages
 'org-babel-load-languages
 '(
   (shell . t)
   (python . t)
   ))

;; Add undo-tree-mode
;; https://elpa.gnu.org/packages/undo-tree.html
(use-package undo-tree
  :config
  (global-undo-tree-mode))
