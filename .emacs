(load "package")
(package-initialize)

(add-to-list 'load-path "~/.emacs.d/custom/")

(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)

(setq x-select-enable-clipboard t)
(setq interprogram-paste-function
      'x-cut-buffer-or-selection-value)

(menu-bar-mode -1)
(tool-bar-mode -1)
(toggle-scroll-bar -1)
(iswitchb-mode 1)
(delete-selection-mode 1)
(column-number-mode 1)
(show-paren-mode 1)
(visual-line-mode 1)
;;(toggle-truncate-lines 1)

;; Custom Keys
(global-unset-key "\C-Z")
(global-set-key "\C-Z" 'undo)

(global-set-key "\C-X\C-R" 'replace-string)

(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
                         ("marmalade" . "http://marmalade-repo.org/packages/")
                         ("melpa" . "http://melpa.milkbox.net/packages/")))

(defun toggle-fullscreen ()
  (interactive)
  (x-send-client-message nil 0 nil "_NET_WM_STATE" 32
	    		 '(2 "_NET_WM_STATE_MAXIMIZED_VERT" 0))
  (x-send-client-message nil 0 nil "_NET_WM_STATE" 32
	    		 '(2 "_NET_WM_STATE_MAXIMIZED_HORZ" 0))
)

;; AutoComplete

;; Web Mode
(require 'web-mode)

(add-to-list 'auto-mode-alist '("\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.jsp\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))

(toggle-fullscreen)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector ["#242424" "#e5786d" "#95e454" "#cae682" "#8ac6f2" "#333366" "#ccaa8f" "#f6f3e8"])
 '(custom-enabled-themes (quote (manoj-dark))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(setq tab-width 2
      indent-tabs-mode nil)
(defalias 'yes-or-no-p 'y-or-n-p)

(global-set-key (kbd "\C-R") 'comment-or-uncomment-region)

(require 'auto-complete-config)
(ac-config-default)


;; Hooks
(defun coffee-custom ()
  "coffee-mode-hook"
  (make-local-variable 'tab-width)
  (set 'tab-width 2))

(add-hook 'coffee-mode-hook 'coffee-custom)

(defun common-find-file ()
  (auto-complete-mode)
  (flex-autopair-mode)
)

(add-hook 'find-file-hook 'common-find-file)

(defun common-save-file ()
  (delete-trailing-whitespace)
)

(add-hook 'before-save-hooke 'common-save-file)
