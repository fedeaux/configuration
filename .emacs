;; npm install -g prettier typescript

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

(require 'smartparens-ruby)

(setq ring-bell-function 'ignore)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("04dd0236a367865e591927a3810f178e8d33c372ad5bfef48b5ce90d4b476481" default))
 '(package-selected-packages
   '(pine-script-mode nginx-mode php-mode highlight-indent-guides sass-mode prettier-js exec-path-from-shell tide coffee-mode web-mode slim-mode yaml-mode lsp-mode rjsx-mode projectile robe flymake-ruby smartparens rvm company yasnippet alect-themes))
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

  (when (memq window-system '(mac ns x))
    (exec-path-from-shell-initialize))

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
  (menu-bar-mode -1)
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
  (defun custom-indent-guide-highlighter (level responsive display)
    (if (> 1 level)
        nil
      (highlight-indent-guides--highlighter-default level responsive display)))

  (setq highlight-indent-guides-method 'character)
  (setq highlight-indent-guides-highlighter-function 'custom-indent-guide-highlighter)
  (add-hook 'prog-mode-hook 'highlight-indent-guides-mode)


  ;; Tmp files location
  (add-to-list 'backup-directory-alist
               (cons "." "~/tmp/emacs-stuff/"))
  (customize-set-variable
   'tramp-backup-directory-alist backup-directory-alist)

  ;; Yas
  (yas-global-mode 1)
  (setq yas-snippet-dirs '("~/configuration/emacs/yas-snippets"))

  ;; Ruby
  (setq ruby-insert-encoding-magic-comment nil)
  (setq enh-ruby-add-encoding-comment-on-save nil)
  (rvm-use-default)
  (add-hook 'ruby-mode-hook 'flymake-ruby-load)
  (add-hook 'ruby-mode-hook 'robe-mode)

  ;; JS
  (setq-default js2-basic-offset 2
                js-indent-level 2)

  ;; Python
  (setq-default python-indent 2)

  ;; Web mode
  (defun my-web-mode-hook ()
    "Hooks for Web mode."
    (setq web-mode-markup-indent-offset 2)
    (setq web-mode-css-indent-offset 2)
    (setq web-mode-code-indent-offset 2)
    )
  (add-hook 'web-mode-hook 'my-web-mode-hook)
  (add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))

  (defun tide-setup-hook()
    (interactive)
    (tide-setup)
    (prettier-js-mode)
    )

  (add-hook 'rjsx-mode-hook 'tide-setup-hook)
  )

(defun local-ensure-key (key callback)
  (local-unset-key key)
  (local-set-key key callback)
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
  (local-ensure-key "\C-L" 'reload-custom)
  (local-ensure-key "\C-C\C-E" 'eval-buffer)
  (local-ensure-key "\C-F\C-F" 'projectile-find-file)
  )

(defun on-after-init ()
  (global-company-mode)
  (server-start)
  )

(with-eval-after-load 'company-mode
  (add-to-list
   'company-backends
   '(company-files company-dabbrev company-yasnippet company-robe company-inf-ruby company-tide company-lsp)
   )
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

(customize-stuff)
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
