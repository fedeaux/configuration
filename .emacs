;; -*- lexical-binding: t; -*-

;; Suppress lexical-binding warnings for old packages
(setq warning-suppress-types '((lexical-binding)))
(setq warning-suppress-log-types '((lexical-binding)))
(setq byte-compile-warnings '(not lexical))
(setq warning-minimum-level :emergency)

(modify-all-frames-parameters '((inhibit-double-buffering . t)))

;; Package Initialization
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

;; Ensure use-package is installed
(unless (package-installed-p 'use-package)
  (package-install 'use-package))
(require 'use-package)
(setq use-package-always-ensure t)

;; Load Custom Modes & Themes safely
(when (file-exists-p "~/configuration/emacs/fedeaux-mode/mql-mode.el")
  (load "~/configuration/emacs/fedeaux-mode/mql-mode.el"))
(when (file-exists-p "~/configuration/emacs/fedeaux-mode/emacs.el")
  (load "~/configuration/emacs/fedeaux-mode/emacs.el"))
(when (file-exists-p "~/configuration/emacs/fedeaux-mode/themes/fedeaux-light-theme.el")
  (load "~/configuration/emacs/fedeaux-mode/themes/fedeaux-light-theme.el"))
(when (file-exists-p "~/configuration/emacs/fedeaux-mode/themes/fedeaux-white-sand-theme.el")
  (load "~/configuration/emacs/fedeaux-mode/themes/fedeaux-white-sand-theme.el"))

(setq ring-bell-function 'ignore)

(custom-set-variables
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
  (untabify (point-min) (point-max)))

(defun pretend-it-is-ret ()
  (interactive)
  (execute-kbd-macro (kbd "RET")))

(defun customize-stuff ()
  (load-theme 'alect-black t)
  (when (boundp 'ns-menu-bar-color)
    (setq ns-menu-bar-color "black"))

  (when (memq window-system '(mac ns x))
    (use-package exec-path-from-shell
      :config
      (exec-path-from-shell-initialize)
      (exec-path-from-shell-copy-env "PATH")))

  ;; Ido
  (ido-mode 1)
  (setq ido-create-new-buffer 'always)
  (setq ido-use-virtual-buffers t)
  (setq ido-decorations '("\n-> " "" "\n    " "\n    ..." "[" "]" " [No match]" " [Matched]" " [Not readable]" " [Too big]" " [Confirm]"))
  (setq ido-show-confirm-message nil)
  (add-hook 'ido-minibuffer-setup-hook (lambda () (setq truncate-lines nil)))

  (defun ido-define-keys ()
    (define-key ido-completion-map (kbd "<down>") 'ido-next-match)
    (define-key ido-completion-map (kbd "<up>") 'ido-prev-match)
    (define-key ido-completion-map (kbd "<tab>") 'pretend-it-is-ret))

  (add-hook 'ido-setup-hook 'ido-define-keys)

  ;; Global Editor Settings
  (column-number-mode 1)
  (delete-selection-mode 1)
  (when (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
  (when (fboundp 'tool-bar-mode) (tool-bar-mode -1))
  (global-visual-line-mode 1)
  (setq create-lockfiles nil)
  (setq vc-follow-symlinks nil)
  (setq scroll-conservatively 10)
  (setq scroll-margin 7)

  ;; Temp files location
  (add-to-list 'backup-directory-alist (cons "." "~/tmp/emacs-stuff/"))
  (setq tramp-backup-directory-alist backup-directory-alist)

  ;; Ruby
  (use-package ruby-mode
    :ensure nil
    :config
    (setq ruby-insert-encoding-magic-comment nil)
    (setq ruby-end-insert-newline -1))

  (use-package rvm
    :if (executable-find "rvm")
    :config
    (rvm-use-default))

  (use-package robe
    :hook (ruby-mode . robe-mode))

  ;; JS / TS / JSX
  (setq-default js2-basic-offset 2
                js-indent-level 2)

  (use-package typescript-mode
    :mode "\\.ts\\'"
    :config
    (setq typescript-indent-level 2))

  (use-package rjsx-mode
    :mode (("\\.jsx\\'" . rjsx-mode)
           ("\\.tsx\\'" . rjsx-mode))
    :config
    (setq js-indent-level 2)
    (setq sgml-basic-offset 2))

  ;; Python
  (setq-default python-indent-offset 2)

  ;; Web mode
  (use-package web-mode
    :mode "\\.erb\\'"
    :config
    (setq web-mode-markup-indent-offset 2
          web-mode-css-indent-offset 2
          web-mode-code-indent-offset 2
          web-mode-enable-auto-indentation nil))

  ;; Prettier & Tide
  (use-package tide
    :after (typescript-mode rjsx-mode))

  (defun tide-setup-hook ()
    (interactive)
    (when (fboundp 'tide-setup) (tide-setup))
    (prettier-mode 1))

  (use-package prettier
    :hook ((js-mode . prettier-mode)
           (rjsx-mode . prettier-mode)
           (typescript-mode . prettier-mode)
           (web-mode . prettier-mode)))

  (add-hook 'rjsx-mode-hook 'tide-setup-hook)
  (add-hook 'typescript-mode-hook 'tide-setup-hook)

  ;; PHP
  (add-hook 'php-mode-hook
            (lambda ()
              (setq indent-tabs-mode nil
                    tab-width 2
                    c-basic-offset 2)))

  ;; Yasnippet
  (use-package yasnippet
    :config
    (setq yas-prompt-functions '(yas-no-prompt))
    (setq yas-snippet-dirs '("~/configuration/emacs/yas-snippets"))

    ;; Define a function to expand snippet OR fallback to default indent/completion
    ;; (defun check-expansion ()
    ;;   (interactive)
    ;;   (if (and (boundp 'yas-minor-mode)
    ;;            yas-minor-mode
    ;;            (yas-expand))
    ;;       t
    ;;     (company-indent-for-tab-command)))
    (defun check-expansion ()
      (interactive)
      (if (and (boundp 'yas-minor-mode)
               yas-minor-mode
               (yas-expand))
          t
        (if (and (boundp 'company-my-key-custom) ; fallback check
                 (company-complete-selection))
            t
          (company-complete-selection))))
    :bind
    (:map company-active-map
          ("TAB" . check-expansion)
          ("<tab>" . check-expansion))
    )

  ;; Company
  (use-package company
    :config
    (setq company-idle-delay 0)
    (setq company-dabbrev-downcase nil)
    (setq company-dabbrev-ignore-case nil)
    (setq company-minimum-prefix-length 1)
    (setq company-selection-wrap-around t)
    )
  )

;; Keybinding Utilities
(defun reload-all ()
  (interactive)
  (load-file user-init-file))

(defun set-custom-keys ()
  (global-set-key (kbd "C-z") 'undo)
  (global-set-key (kbd "C-x C-r") 'replace-string)
  (global-set-key (kbd "C-c C-c") 'comment-region)
  (global-set-key (kbd "C-c C-u") 'uncomment-region)
  (global-set-key (kbd "C-x C-l") 'goto-line)
  (global-set-key (kbd "C-c C-s") 'sort-lines)
  (global-set-key (kbd "C-x C-y") 'yas-insert-snippet)
  (global-set-key (kbd "C-l") 'reload-all)
  (global-set-key (kbd "C-c C-e") 'eval-buffer)
  (when (fboundp 'projectile-find-file)
    (global-set-key (kbd "C-f C-f") 'projectile-find-file)))

(defun on-after-init ()
  (when (fboundp 'yas-global-mode) (yas-global-mode 1))
  (when (fboundp 'global-company-mode)
    (global-company-mode 1)
    (setq company-backends '((company-yasnippet company-dabbrev-code company-robe))))
  (electric-pair-mode 1)
  (global-auto-revert-mode 1)
  (unless (and (fboundp 'server-running-p) (server-running-p))
    (server-start))
  (when (fboundp 'setup-fedeaux-mode)
    (setup-fedeaux-mode)))

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
          (set-visited-file-name new-name))))))

;; Frame & Hook Setup
(add-to-list 'default-frame-alist '(fullscreen . maximized))
(add-hook 'before-save-hook 'common-save-file)
(add-hook 'after-init-hook 'on-after-init)

;; Set macOS Keys
(setq mac-command-modifier 'super)
(setq mac-option-modifier 'meta)

;; Run Initialization
(customize-stuff)
(set-custom-keys)

(custom-set-faces)
