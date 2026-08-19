;; -*- lexical-binding: t; -*-

;; Suppress lexical-binding warnings for old packages
(setq warning-suppress-types '((lexical-binding)))
(setq warning-suppress-log-types '((lexical-binding)))
(setq byte-compile-warnings '(not lexical))
(setq warning-minimum-level :emergency)  ; Only show critical warnings
(modify-all-frames-parameters '((inhibit-double-buffering . t)))

;; npm install -g prettier typescript
;; Ensure tree-sitter is enabled and set up the grammar repositories
(require 'treesit)

;; Set the default installation directory (optional, but clean)
(setq treesit-extra-load-path '("~/.emacs.d/tree-sitter/"))

;; Reinstall the grammars
;; (dolist (grammar treesit-language-source-alist)
;;   (treesit-install-language-grammar (car grammar)))

(setq treesit-language-source-alist
      '((javascript "https://github.com/tree-sitter/tree-sitter-javascript" "v0.23.0")
        (typescript "https://github.com/tree-sitter/tree-sitter-typescript" "master" "typescript/src")
        (tsx "https://github.com/tree-sitter/tree-sitter-typescript" "master" "tsx/src")))

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

;; Ensure use-package is installed
(unless (package-installed-p 'use-package)
  (package-install 'use-package))
(require 'use-package)
(require 'ruby-end)

(setq use-package-always-ensure t)

(load "~/configuration/emacs/fedeaux-mode/mql-mode.el")
(load "~/configuration/emacs/fedeaux-mode/emacs.el")
(load "~/configuration/emacs/fedeaux-mode/themes/fedeaux-light-theme.el")
(load "~/configuration/emacs/fedeaux-mode/themes/fedeaux-white-sand-theme.el")

(setq ring-bell-function 'ignore)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(auth-source-save-behavior nil)
 '(custom-safe-themes
   '("9afcf2d0d88a677acd2c5db94e867fff840beef6bf2dbcdae25a61a1fb5ffd2b"
     "2e33194d8a0462aba0aa31f09a61067edaea8b57ced86919bece8b7f655f8009"
     "b5df39cbce73b09140244bdfae0ac5e3fd4eccc966976e917afe3be8599628ba"
     "7b5909e52169f5ab61e200147cff389a3cefff33ffbdbd5a66ffdff7cc3abdc7"
     "f6640c96f6de4ead8399bf8b0c36766c299b9cc7823a6ea228dfd312688eabc0"
     "d6e59d5d3e1e4ec825322deed1e154251abecff0b2bb6d32ac62b117f623bd50"
     "04dd0236a367865e591927a3810f178e8d33c372ad5bfef48b5ce90d4b476481"
     default))
 '(flymd-markdown-file-type '("\\.txt\\'" "\\.md\\'" "\\.markdown\\'"))
 '(package-selected-packages nil)
 '(tramp-backup-directory-alist '(("." . "~/tmp/emacs-stuff/")) t))

(defun common-save-file ()
  (delete-trailing-whitespace)
  (untabify (point-min) (point-max))
  )

(defun pretend-it-is-ret ()
  (interactive)
  (execute-kbd-macro (kbd "RET"))
  )

(defun customize-stuff()
  (load-theme 'alect-black)
  (setq ns-menu-bar-color "black")
  ;; (load-theme 'fedeaux-white-sand)

  (when (memq window-system '(mac ns x))
    (exec-path-from-shell-initialize)
    (exec-path-from-shell-copy-env "PATH"))

  ;; Ido
  (ido-mode 1)
  (setq ido-create-new-buffer 'always)
  (setq ido-use-virtual-buffers t)
  (setq ido-decorations (quote ("\n-> " "" "\n   " "\n   ..." "[" "]" " [No match]" " [Matched]" " [Not readable]" " [Too big]" " [Confirm]")))
  (setq ido-show-confirm-message nil)
  (defun ido-disable-line-truncation () (set (make-local-variable 'truncate-lines) nil))
  (add-hook 'ido-minibuffer-setup-hook 'ido-disable-line-truncation)

  (defun ido-define-keys ()
    (define-key ido-completion-map (kbd "<down>") 'ido-next-match)
    (define-key ido-completion-map (kbd "<up>") 'ido-prev-match)
    (define-key ido-completion-map (kbd "<tab>") 'pretend-it-is-ret)
    )

  (add-hook 'ido-setup-hook 'ido-define-keys)

  ;; Random
  (column-number-mode 1)
  (delete-selection-mode 1)
  (scroll-bar-mode -1)
  (show-smartparens-global-mode t)
  (smartparens-global-mode t)
  (toggle-scroll-bar -1)
  (tool-bar-mode -1)
  (visual-line-mode 1)
  (setq create-lockfiles nil)
  (setq vc-follow-symlinks nil)
  (setq scroll-conservatively 10)
  (setq scroll-margin 7)

  ;; Indent Highlight
  ;; (defun custom-indent-guide-highlighter (level responsive display)
  ;;   (if (> 1 level)
  ;;       nil
  ;;     (highlight-indent-guides--highlighter-default level responsive display)))

  ;; (setq highlight-indent-guides-method 'character)
  ;; (setq highlight-indent-guides-highlighter-function 'custom-indent-guide-highlighter)
  ;; (add-hook 'prog-mode-hook 'highlight-indent-guides-mode)

  ;; Tmp files location
  (add-to-list 'backup-directory-alist
               (cons "." "~/tmp/emacs-stuff/"))
  (customize-set-variable
   'tramp-backup-directory-alist backup-directory-alist)

  ;; Ruby
  (setq ruby-insert-encoding-magic-comment nil)
  (setq ruby-end-insert-newline -1)  ;; This might already be the default
  (setq enh-ruby-add-encoding-comment-on-save nil)
  (rvm-use-default)
  ;; (add-hook 'ruby-mode-hook 'flymake-ruby-load)
  (add-hook 'ruby-mode-hook 'robe-mode)

  ;; JS
  (setq-default js2-basic-offset 2
                js-indent-level 2)

  (add-to-list 'auto-mode-alist '("\\.jsx\\'" . javascript-mode))

  ;; Install jtsx
  (use-package jtsx
    :ensure t
    :mode (("\\.jsx\\'" . jtsx-jsx-mode)
           ("\\.tsx\\'" . jtsx-tsx-mode))
    :config
    ;; Enable electric closing tag (auto-closes when you type `>`)
    (setq jtsx-auto-indent nil)  ; <-- FLICKERING ADDED THIS
    (setq jtsx-enable-jsx-electric-closing-element t)
    (setq-local js-indent-level 2)
    (setq-local js2-basic-offset 2)
    (setq jtsx-indent-level 2)
    ;; (setq jtsx-auto-close-tags t)
    ;; (add-hook 'jtsx-jsx-mode-hook 'electric-pair-mode)
    ;; (add-hook 'jtsx-tsx-mode-hook 'electric-pair-mode)
    )

  ;; Python
  (setq-default python-indent 2)

  ;; Web mode
  (defun my-web-mode-hook ()
    "Hooks for Web mode."
    (setq web-mode-markup-indent-offset 2)
    (setq web-mode-css-indent-offset 2)
    (setq web-mode-code-indent-offset 2)
    (setq web-mode-enable-auto-indentation nil)
    )
  (add-hook 'web-mode-hook 'my-web-mode-hook)
  (add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))

  (defun tide-setup-hook()
    (interactive)
    (tide-setup)
    (prettier-mode)
    ;; (prettier-js-mode)
    )

  (use-package prettier
    :ensure t
    :hook (js-mode-hook . prettier-mode)
    :hook (rjsx-mode-hook . prettier-mode)
    :hook (web-mode-hook . prettier-mode))

  (add-hook 'rjsx-mode-hook 'tide-setup-hook)
  (add-hook 'jtsx-jsx-mode-hook 'tide-setup-hook)

  ;; php
  (add-hook 'php-mode-hook 'my-php-mode-hook)
  (defun my-php-mode-hook ()
    "My PHP mode configuration."
    (setq indent-tabs-mode nil
          tab-width 2
          c-basic-offset 2))

  ;; company
  (setq company-idle-delay 0)
  (setq company-dabbrev-downcase nil)
  (setq company-dabbrev-ignore-case nil)
  (setq company-minimum-prefix-length 1)

  ;; yas
  (setq yas-prompt-functions '(yas-no-prompt))
  (setq yas-snippet-dirs '("~/configuration/emacs/yas-snippets"))
  )

(defun local-ensure-key (key callback)
  (local-unset-key key)
  (local-set-key key callback)
  )
(defun reload-all ()
  (interactive)
  (load-file "~/.emacs")
  )
(defun set-custom-keys ()
  (local-unset-key (kbd "<f9>"))
  (local-unset-key "\C-C\C-C")
  (local-ensure-key "\C-Z" 'undo)
  (local-ensure-key "\C-X\C-R" 'replace-string)
  (local-ensure-key "\C-C\C-C" 'comment-region)
  (local-ensure-key "\C-C\C-U" 'uncomment-region)
  (local-ensure-key "\C-X\C-L" 'goto-line)
  (local-ensure-key "\C-C\C-S" 'sort-lines)
  (local-ensure-key "\C-X\C-Y" 'yas-insert-snippet)
  (local-ensure-key "\C-L" 'reload-all)
  (local-ensure-key "\C-C\C-E" 'eval-buffer)
  (local-ensure-key "\C-F\C-F" 'projectile-find-file)
  )

(defun on-after-init ()
  (yas-global-mode 1)
  (global-company-mode)
  (push '(company-yasnippet company-dabbrev-code company-robe) company-backends)
  ;; (push '(company-yasnippet company-dabbrev company-dabbrev-code company-robe) company-backends)
  (global-auto-revert-mode 1)
  (server-start)
  (setup-fedeaux-mode)
  )

;; source: http://steve.yegge.googlepages.com/my-dot-emacs-file
(defun rename-file-and-buffer (new-name)
  "Renames both current buffer and file it's visiting to NEW-NAME."
  (interactive "sNew name: ")
  (let ((name (buffer-name))
        (filename (buffer-file-name)))
    (if (not filename)
        (message "Buffer '%s' is not visiting a file!" name)
      (if (get-buffer new-name)
          (message "A buffer named '%s' already exists!" new-name)
        (progn
          (rename-file filename new-name 1)
          (rename-buffer new-name)
          (set-visited-file-name new-name)
          )
        )
      )
    )
  )

(add-to-list 'default-frame-alist '(fullscreen . maximized))
(add-hook 'before-save-hook 'common-save-file)
(add-hook 'after-change-major-mode-hook 'set-custom-keys)
(add-hook 'after-init-hook 'on-after-init)

(with-eval-after-load 'company
  (interactive)
  '(push 'company-yasnippet company-backends))

(defun ensure-keybinding (key expected-fn)
  "If KEY is not bound to EXPECTED-FN, bind it."
  (let* ((key-vector (if (vectorp key) key (kbd key)))
         (current-fn (lookup-key global-map key-vector)))
    (unless (eq current-fn expected-fn)
      (global-set-key key-vector expected-fn)
      (message "Bound %s to %s (was %s)"
               (key-description key-vector)
               expected-fn
               current-fn))))

;; (defun fix-mac-port-keybindings ()
;;   "Ensure macOS keybindings work correctly on the Mac port."
;;   (interactive)
;;   ;; Standard macOS shortcuts
;;   (ensure-keybinding "M-z" 'undo)
;;   (ensure-keybinding "M-S-z" 'undo-redo)
;;   (ensure-keybinding "M-x" 'kill-region)           ; Cut
;;   (ensure-keybinding "M-c" 'kill-ring-save)        ; Copy
;;   (ensure-keybinding "M-v" 'yank)                  ; Paste
;;   (ensure-keybinding "M-a" 'mark-whole-buffer)     ; Select all
;;   (ensure-keybinding "M-s" 'save-buffer)           ; Save

;;   ;; Backspace
;;   (ensure-keybinding "M-<backspace>" 'backward-kill-word)
;;   (ensure-keybinding "A-<backspace>" 'backward-kill-word)
;;   (ensure-keybinding "M-<delete>" 'kill-word)

;;   (message "Mac port keybindings fixed!"))

;; (add-hook 'after-init-hook 'fix-mac-port-keybindings)

(customize-stuff)
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
