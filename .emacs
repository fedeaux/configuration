(load "package")
(package-initialize)

(add-to-list 'load-path "~/.emacs.d/custom/")

(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)

(setq x-select-enable-clipboard t)
;; (setq interprogram-paste-function
;;       'x-cut-buffer-or-selection-value)

(menu-bar-mode -1)
(tool-bar-mode -1)
(toggle-scroll-bar -1)
(scroll-bar-mode -1)
(iswitchb-mode 1)
(delete-selection-mode 1)
(column-number-mode 1)
(show-paren-mode 1)
(visual-line-mode 1)
;;(toggle-truncate-lines 1)

;; Custom Keys
(global-unset-key (kbd "<f9>"))
(global-unset-key "\C-Z")
(global-set-key "\C-Z" 'undo)

(global-set-key "\C-X\C-R" 'replace-string)
(global-set-key "\C-C\C-C" 'comment-region)
(global-set-key "\C-X\C-L" 'goto-line)
(global-set-key "\C-C\C-S" 'sort-lines)

(global-set-key "\C-Q" 'ace-jump-char-mode)

(global-unset-key "\C-X\C-Z")

(setq package-archives '(
                         ;; ("gnu" . "http://elpa.gnu.org/packages/")
                         ;; ("marmalade" . "http://marmalade-repo.org/packages/")
                         ;; ("melpa" . "http://melpa.milkbox.net/packages/")
                         ("melpa-stable" . "http://melpa-stable.milkbox.net/packages/")))

;; (defun toggle-fullscreen ()
;;   (interactive)
;;   (x-send-client-message nil 0 nil "_NET_WM_STATE" 32
;;                       '(2 "_NET_WM_STATE_MAXIMIZED_VERT" 0))
;;   (x-send-client-message nil 0 nil "_NET_WM_STATE" 32
;;                       '(2 "_NET_WM_STATE_MAXIMIZED_HORZ" 0))
;; )

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

(add-to-list 'auto-mode-alist '("\\.cjsv\\'" . haml-mode))
(add-to-list 'auto-mode-alist '("\\.boo\\'" . python-mode))
(add-to-list 'auto-mode-alist '("\\.jsx\\'" . javascript-mode))
(add-to-list 'auto-mode-alist '("Gemfile" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.rake\\'" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.jbuilder\\'" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.rabl\\'" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.scss\\'" . sass-mode))
(add-to-list 'auto-mode-alist '("\\.sass\\'" . sass-mode))

;; (toggle-fullscreen)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector ["#242424" "#e5786d" "#95e454" "#cae682" "#8ac6f2" "#333366" "#ccaa8f" "#f6f3e8"])
 '(custom-enabled-themes (quote (manoj-dark))))

(custom-set-variables '(coffee-tab-width 2))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(setq-default indent-tabs-mode nil)
(setq-default tab-width 2)
(defalias 'yes-or-no-p 'y-or-n-p)

(require 'auto-complete-config)
(ac-config-default)
(setq ac-ignore-case nil)
(global-auto-complete-mode t)

(defun configure-auto-complete-for-sass ()
  (add-to-list 'ac-sources 'ac-source-css-property))
(add-hook 'sass-mode-hook 'configure-auto-complete-for-sass)
(add-to-list 'ac-modes 'sass-mode)

;; Hooks
(defun coffee-custom ()
  "coffee-mode-hook"
  (make-local-variable 'tab-width)
  (set 'tab-width 2)
)

(add-hook 'coffee-mode-hook 'coffee-custom)

(require 'android-mode)
(custom-set-variables '(android-mode-sdk-dir "~/.rubymotion-android/sdk"))

(defun common-find-file ()
  (auto-complete-mode)
)

(add-hook 'find-file-hook 'common-find-file)

(require 'smartparens-config)
(require 'smartparens-ruby)
(smartparens-global-mode)
(show-smartparens-global-mode t)
(sp-with-modes '(rhtml-mode)
  (sp-local-pair "<" ">")
  (sp-local-pair "<%" "%>"))

(textmate-mode)

(defun common-save-file ()
  (delete-trailing-whitespace)
  (untabify (point-min) (point-max))
)

(defun backward-delete-word (arg)
  "Delete characters backward until encountering the beginning of a word.
With argument ARG, do this that many times."
  (interactive "p")
  (delete-region (point) (progn (backward-word arg) (point)))
)

(global-set-key "\M-\d" 'backward-delete-word)

(add-hook 'before-save-hook 'common-save-file)

(custom-set-variables
 '(initial-frame-alist (quote ((fullscreen . maximized)))))

(setq backup-directory-alist '(("" . "~/.emacs.d/emacs-backup")))
(setq auto-save-default nil)

;; If the *scratch* buffer is killed, recreate it automatically
;; FROM: Morten Welind
;;http://www.geocrawler.com/archives/3/338/1994/6/0/1877802/
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

(setq js-indent-level 2)
