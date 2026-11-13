;;; videoer-script-mode.el --- Major mode for Videoer .scr script files -*- lexical-binding: t; -*-

;;; Code:

(defgroup videoer-script nil
  "Major mode for Videoer .scr script files."
  :group 'text)

(defface videoer-script-flag-face
  '((t (:inherit font-lock-keyword-face :weight bold)))
  "Face for line-leading flags."
  :group 'videoer-script)

(defface videoer-script-flag-attr-face
  '((t (:inherit font-lock-variable-name-face :slant italic)))
  "Face for flag attribute names."
  :group 'videoer-script)

(defface videoer-script-flag-string-face
  '((t (:inherit font-lock-string-face)))
  "Face for quoted string values inside flags."
  :group 'videoer-script)

(defun videoer-script--propertize-strings (start end)
  (save-excursion
    (goto-char start)
    (while (re-search-forward
            "^\\\\[a-zA-Z_][a-zA-Z0-9_]*(\\([^)]*\\))" end t)
      (let ((paren-start (match-beginning 1))
            (paren-end (match-end 1)))
        (save-excursion
          (goto-char paren-start)
          (while (re-search-forward "\"[^\"]*\"" paren-end t)
            (put-text-property (match-beginning 0) (1+ (match-beginning 0))
                               'syntax-table (string-to-syntax "\""))
            (put-text-property (1- (match-end 0)) (match-end 0)
                               'syntax-table (string-to-syntax "\""))
            (put-text-property (match-beginning 0) (match-end 0)
                               'syntax-multiline t)))))))

(defun videoer-script-syntactic-face (state)
  (cond
    ((nth 3 state) 'videoer-script-flag-string-face)
    ((nth 4 state) 'font-lock-comment-face)
    (t nil)))

(defvar videoer-script-font-lock-keywords
  '(("^\\\\\\([a-zA-Z_][a-zA-Z0-9_]*\\)"
     1 'videoer-script-flag-face))
  "Search-based font lock keywords for `videoer-script-mode'.")

(defvar videoer-script-mode-syntax-table
  (let ((table (make-syntax-table)))
    (modify-syntax-entry ?\" "." table)
    (modify-syntax-entry ?_ "_" table)
    table)
  "Syntax table for `videoer-script-mode'.")

(defun videoer-script--fontify-attrs (&rest _)
  "Apply the attr face to `key:' inside flag parens in the visible region."
  (when (derived-mode-p 'videoer-script-mode)
    (let ((start (window-start))
          (end (window-end nil t)))
      (when (and start end)
        (with-silent-modifications
          (save-excursion
            (goto-char start)
            (while (re-search-forward
                    "^\\\\[a-zA-Z_][a-zA-Z0-9_]*(\\([^)]*\\))" end t)
              (let ((paren-start (match-beginning 1))
                    (paren-end (match-end 1)))
                (save-excursion
                  (goto-char paren-start)
                  (while (re-search-forward
                          "\\([a-zA-Z_][a-zA-Z0-9_]*\\)[ \t]*:" paren-end t)
                    (put-text-property (match-beginning 1) (match-end 1)
                                       'face 'videoer-script-flag-attr-face)))))))))))

;;;###autoload
(define-derived-mode videoer-script-mode text-mode "Videoer"
  "Major mode for editing Videoer script (.scr) files."
  :syntax-table videoer-script-mode-syntax-table

  (setq-local comment-start "# ")
  (setq-local comment-end "")

  (setq-local syntax-propertize-function #'videoer-script--propertize-strings)

  (setq-local font-lock-defaults
              '(videoer-script-font-lock-keywords
                nil nil nil nil
                (font-lock-syntactic-face-function
                 . videoer-script-syntactic-face)))

  ;; Let font-lock know we manage `face` in some places
  (add-to-list 'font-lock-extra-managed-props 'face)

  ;; Run after font-lock so it can't overwrite our attrs
  (add-hook 'font-lock-after-fontify-buffer-hook
            #'videoer-script--fontify-attrs nil t)
  (add-hook 'post-command-hook #'videoer-script--fontify-attrs nil t)

  (setq-local indent-line-function #'indent-relative)
  (setq-local truncate-lines nil)

  (font-lock-flush))

;;;###autoload
(add-to-list 'auto-mode-alist '("\\.scr\\'" . videoer-script-mode))

(provide 'videoer-script-mode)
;;; videoer-script-mode.el ends here
