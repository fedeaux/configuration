;;; fedeaux-light-theme.el --- fedeaux-light
;;; Version: 1.0
;;; Commentary:
;;; A theme called fedeaux-light
;;; Code:

(deftheme fedeaux-light "DOCSTRING for fedeaux-light")
  (custom-theme-set-faces 'fedeaux-light
   '(default ((t (:foreground "#424140" :background "#e1e1ec" ))))
   '(cursor ((t (:background "#babaec" ))))
   '(fringe ((t (:background "#eeeeee" ))))
   '(mode-line ((t (:foreground "#282828" :background "#7c6f64" ))))
   '(region ((t (:background "#f1f1f6" ))))
   '(secondary-selection ((t (:background "#e9e9f4" ))))
   '(font-lock-builtin-face ((t (:foreground "#ff00ec" ))))
   '(font-lock-comment-face ((t (:foreground "#53a572" ))))
   '(font-lock-function-name-face ((t (:foreground "#008fff" ))))
   '(font-lock-keyword-face ((t (:foreground "#0008ff" ))))
   '(font-lock-string-face ((t (:foreground "#ee2222" ))))
   '(font-lock-type-face ((t (:foreground "#279bbb" ))))
   '(font-lock-constant-face ((t (:foreground "#50516f" ))))
   '(font-lock-variable-name-face ((t (:foreground "#10690a" ))))
   '(minibuffer-prompt ((t (:foreground "#b8bb26" :bold t ))))
   '(font-lock-warning-face ((t (:foreground "red" :bold t ))))
   )

;;;###autoload
(and load-file-name
    (boundp 'custom-theme-load-path)
    (add-to-list 'custom-theme-load-path
                 (file-name-as-directory
                  (file-name-directory load-file-name))))
;; Automatically add this theme to the load path

(provide-theme 'fedeaux-light)

;;; fedeaux-light-theme.el ends here
