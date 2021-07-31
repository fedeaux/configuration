(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

(setq ring-bell-function 'ignore)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("04dd0236a367865e591927a3810f178e8d33c372ad5bfef48b5ce90d4b476481" default))
 '(package-selected-packages '(yasnippet alect-themes)))

(defun common-save-file ()
  (delete-trailing-whitespace)
  (untabify (point-min) (point-max))
  )


(defun customize-stuff()
  (load-theme 'alect-black)

  (column-number-mode 1)
  (delete-selection-mode 1)
  (ido-mode 1)
  (menu-bar-mode -1)
  (scroll-bar-mode -1)
  (show-paren-mode 1)
  (toggle-scroll-bar -1)
  (tool-bar-mode -1)
  (visual-line-mode 1)
  (yas-global-mode 1)
  (setq ruby-insert-encoding-magic-comment nil)
  (setq enh-ruby-add-encoding-comment-on-save nil)
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
  )

(setq yas-snippet-dirs '("~/configuration/emacs/yas-snippets"))

 ;; or M-x yas-reload-all if you've started YASnippet already.

(add-to-list 'default-frame-alist '(fullscreen . maximized))
(add-hook 'before-save-hook 'common-save-file)
(add-hook 'after-change-major-mode-hook 'set-custom-keys)
(customize-stuff)
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
