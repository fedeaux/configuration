;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

(when (>= emacs-major-version 24)
  (require 'package)
  (add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
  )

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes (quote (manoj-dark)))
 '(custom-safe-themes
   (quote
    ("4cf9ed30ea575fb0ca3cff6ef34b1b87192965245776afa9e9e20c17d115f3fb" "939ea070fb0141cd035608b2baabc4bd50d8ecc86af8528df9d41f4d83664c6a" "e1d09f1b2afc2fed6feb1d672be5ec6ae61f84e058cb757689edb669be926896" "a06658a45f043cd95549d6845454ad1c1d6e24a99271676ae56157619952394a" "123a8dabd1a0eff6e0c48a03dc6fb2c5e03ebc7062ba531543dfbce587e86f2a" "b89ae2d35d2e18e4286c8be8aaecb41022c1a306070f64a66fd114310ade88aa" default)))
 '(delete-selection-mode t)
 '(fci-rule-column 90)
 '(coffee-tab-width 2)
 '(coffee-indent-like-python-mode t)
 '(highlight-indent-guides-method (quote character))
 '(iswitchb-mode t)
 '(js-indent-level 2)
 '(mmm-submode-decoration-level 0)
 '(package-selected-packages
   (quote
    (lua-mode typescript-mode company smartparens yasnippet fill-column-indicator rainbow-mode highlight-indent-guides indent-info yaml-mode sass-mode pug-mode rvm robe gruvbox-theme auto-complete powerline enh-ruby-mode slim-mode vue-mode coffee-mode js2-mode)))
 '(ring-bell-function (quote ignore))
 '(scroll-bar-mode nil)
 '(tool-bar-mode nil)
 '(yas-global-mode t)
 '(typescript-indent-level 2))

(global-unset-key "\C-Z")
(global-unset-key "\C-X\C-Z")

(global-set-key "\C-C\C-C" 'comment-region)
(global-set-key "\C-C\C-U" 'uncomment-region)
(global-set-key "\C-C\C-S" 'sort-lines)
(global-set-key "\C-X\C-L" 'goto-line)
(global-set-key "\C-X\C-R" 'replace-string)
(global-set-key "\C-X\C-Y" 'yas-insert-snippet)

;; Don't polute clipboard when deleting words
(defun backward-delete-word (arg)
  "Delete characters backward until encountering the beginning of a word.
With argument ARG, do this that many times."
  (interactive "p")
  (delete-region (point) (progn (backward-word arg) (point)))
)

(global-set-key "\M-\d" 'backward-delete-word)

(defalias 'yes-or-no-p 'y-or-n-p)

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; Recreates *scratch* automatically
(save-excursion
  (set-buffer (get-buffer-create "*scratch*"))
  (lisp-interaction-mode)
  (make-local-variable 'kill-buffer-query-functions)
  (add-hook 'kill-buffer-query-functions 'kill-scratch-buffer))

(defun kill-scratch-buffer ()
  ;; The next line is just in case someone calls this manually
  (set-buffer (get-buffer-create "*scratch*"))
  ;; Kill the current (*scratch*) buffer
  (remove-hook 'kill-buffer-query-functions 'kill-scratch-buffer)
  (kill-buffer (current-buffer))
  ;; Make a brand new *scratch* buffer
  (set-buffer (get-buffer-create "*scratch*"))
  (lisp-interaction-mode)
  (make-local-variable 'kill-buffer-query-functions)
  (add-hook 'kill-buffer-query-functions 'kill-scratch-buffer)
  ;; Since we killed it, don't let caller do that.
  nil)

;; Smartparens
(require 'smartparens-config)
(require 'smartparens-ruby)
(smartparens-global-mode)
(show-smartparens-global-mode t)
(sp-with-modes '(rhtml-mode)
  (sp-local-pair "<" ">")
  (sp-local-pair "<%" "%>"))

;; Indent Guide
(defun custom-indent-guide-highlighter(level responsive display)
  (if (> 1 level)
      nil
    (highlight-indent-guides--highlighter-default level responsive display)))

(setq highlight-indent-guides-highlighter-function 'custom-indent-guide-highlighter)

;; max column line
(require 'fill-column-indicator)

;; ;; Autocomplete Mode
;; (require 'auto-complete-config)
;; (ac-config-default)
;; (setq ac-ignore-case nil)
;; (global-auto-complete-mode t)

(add-hook 'after-init-hook 'global-company-mode)

;; Ruby
(global-robe-mode)
(add-hook 'enh-ruby-mode-hook 'robe-mode)
;; (add-hook 'robe-mode-hook 'ac-robe-setup)
(defadvice inf-ruby-console-auto (before activate-rvm-for-robe activate)
  (rvm-activate-corresponding-ruby))

(autoload 'enh-ruby-mode "enh-ruby-mode" "Major mode for ruby files" t)

(add-to-list 'auto-mode-alist '("\\.rb$" . enh-ruby-mode))
(add-to-list 'auto-mode-alist '("\\.erb$" . enh-ruby-mode))
(add-to-list 'auto-mode-alist '("\\.rake$" . enh-ruby-mode))
(add-to-list 'auto-mode-alist '("Rakefile$" . enh-ruby-mode))
(add-to-list 'auto-mode-alist '("\\.gemspec$" . enh-ruby-mode))
(add-to-list 'auto-mode-alist '("\\.ru$" . enh-ruby-mode))
(add-to-list 'auto-mode-alist '("Gemfile$" . enh-ruby-mode))
(add-to-list 'auto-mode-alist '("\\.cjsx" . coffee-mode))
(add-to-list 'auto-mode-alist '("\\.tsx" . typescript-mode))

(add-to-list 'interpreter-mode-alist '("ruby" . enh-ruby-mode))

(setq enh-ruby-bounce-deep-indent t)
(setq enh-ruby-hanging-brace-indent-level 2)

;; Start Maximized
(add-to-list 'default-frame-alist '(fullscreen . maximized))

;; Reload changed files
(global-auto-revert-mode t)

;; Enable things by default
(defun common-find-file ()
  ;; (auto-complete-mode)
  (highlight-indent-guides-mode)
  (column-number-mode)
  )

(defun common-save-file ()
  (delete-trailing-whitespace)
  (untabify (point-min) (point-max)))

(add-hook 'find-file-hook 'common-find-file)
(add-hook 'before-save-hook 'common-save-file)

;; Don't polute dir with auto-save-files.rb~
(setq auto-save-file-name-transforms
  `((".*" "~/.emacs-saves/" t)))

(setq backup-directory-alist
      '((".*" . "~/.emacs-saves")))

;; (load-file (concat (file-name-directory (message load-file-name)) "~/configuration/fedeaux-mode/emacs.el"))
(load-file "~/configuration/fedeaux-mode/emacs.el")
