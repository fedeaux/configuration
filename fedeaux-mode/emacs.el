(require 'json)

;; Commands
(defun fedeaux-mode-smart-guess()
  (interactive)
  (mapcar
   'fedeaux-mode-interpret-smart-guess
   (json-read-from-string
    (fedeaux-mode-command
     (list "smart_guess" (get-selected-text))
     )
    )
   )
  )

(defun fedeaux-mode-interpret-smart-guess(params)
  (funcall (intern (cdr (assoc 'action params))) (cdr (assoc 'args params)))
  )

(defun fedeaux-mode-find-thing()
  (interactive)
  (let ((result (fedeaux-mode-command-as-list (list "find_thing" (thing-at-point 'symbol)))))
    (message (concat "Oi amor: " result))
    (if (eq (length result) 1)
        (let ((file-name (concat fedeaux-mode-parent-root-directory (car result))))
          (if (file-exists-p file-name)
              (find-file file-name))
          )
      )
    )
  )

(defun fedeaux-mode-find-branch()
  (interactive)
  (let ((choices (fedeaux-mode-command-as-list (list "list_branch"))))
    (let ((file-name (ido-completing-read "Files changed in this branch:" choices)))
      (find-file (concat fedeaux-mode-parent-root-directory file-name))
      )
    )
  )

;; Commands Helpers
(defun fedeaux-mode-command-as-list(args)
  (string-as-lines (fedeaux-mode-command args))
  )

(defun fedeaux-mode-command(args)
  (interactive)
  (find-parent-root-directory)
  (if fedeaux-mode-parent-root-directory
      (let
          (
           (cmd
            (format "ruby ~/configuration/fedeaux-mode/cli.rb %s %s %s"
                    fedeaux-mode-parent-root-directory (car args) (concat "\"" (string-join (cdr args) " ") "\""))
            )
           )
        ;; (message cmd)
        (shell-command-to-string cmd)
        )
    (message "fedeaux-mode: Couldn't find root directory")
    )
  )

;; General Helpers
(defun copy-to-clipboard(string)
  (kill-new string)
  )

(defun replace-region(string)
  (delete-region (region-beginning) (region-end))
  (insert string)
  )

(defun string-as-lines(string)
  (delete "" (split-string string "\n"))
  )

(defun get-selected-text()
  (interactive)
  (buffer-substring-no-properties (region-beginning) (region-end))
  )

(defun copy-file-name-to-clipboard ()
  "Copy the current buffer file name to the clipboard."
  (interactive)
  (let ((filename (if (equal major-mode 'dired-mode)
                      default-directory
                    (buffer-file-name))))

    (when filename
      (kill-new filename)
      (message "Copied buffer file name '%s' to the clipboard." filename)
      )
    )
  )

;; Directories
(defun find-parent-root-directory()
  (interactive)
  (setq fedeaux-mode-parent-root-directory nil)

  (if (buffer-file-name)
      (rec-find-parent-root-directory (file-name-directory (buffer-file-name)))
    )
  )

(defun rec-find-parent-root-directory(current-dir)
  (if current-dir
      (if (is-root-directory current-dir)
          (setq fedeaux-mode-parent-root-directory current-dir)
        (rec-find-parent-root-directory (parent-dir current-dir))
        )
    )
  )

(defun is-root-directory(dir)
  (or (is-git-directory dir)
      (is-gemfile-directory dir)
      (is-son-of-gems dir))
  )

(defun is-git-directory(dir)
  (and dir (file-exists-p (concat dir ".git")))
  )

(defun is-gemfile-directory(dir)
  (and dir (file-exists-p (concat dir "Gemfile")))
  )

(defun is-son-of-gems(dir)
  nil
  ;; (let ((parent (parent-dir dir)))
  ;;   (if parent (message (concat "caralho" (car (last (split-string parent "/"))))))

  ;;   ;; (message (car (last (split-string parent "/"))))
  ;;   (and dir
  ;;        parent
  ;;        (eq (car (last (split-string parent "/"))) "")
  ;;        )
  ;;   )
  ;; ;; (message (last (split-string (parent-dir dir) "/")))
  ;; ;; (and dir (eq (last (split-string (parent-dir dir) "/")) "gems"))
  )

(defun parent-dir (file &optional relativep)
  "Return the parent directory of FILE, or nil if none.
Optional arg RELATIVEP non-nil means return a relative name, that is,
just the parent component."
  (let ((parent  (file-name-directory (directory-file-name (expand-file-name file))))
        relparent)
    (when relativep
      (setq relparent (file-name-nondirectory (directory-file-name parent))))
    (and (not (equal parent file)) (or relparent parent))))

;; (message (is-son-of-gems "alface/gems"))
;; (message "Caralho")

(defun setup-fedeaux-mode()
  (interactive)
  (local-set-key "\C-F\C-T" 'fedeaux-mode-find-thing)
  (local-set-key "\C-F\C-B" 'fedeaux-mode-find-branch)
  (local-set-key "\C-F\C-G" 'fedeaux-mode-smart-guess)
  )

(setup-fedeaux-mode)
