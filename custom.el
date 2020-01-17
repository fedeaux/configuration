(defun fmacs-add-favorite()
  (interactive)
  (femacs-command (string-join (list "favorites_add" (buffer-file-name)) " "))
  )

(defun fmacs-find-favorite()
  (interactive)
  (femacs-command "favorites_find")
  )

(defun femacs-command(args)
  (find-parent-git-directory)
  (message (format "ruby ~/configuration/femacs.rb %s %s" femacs-parent-git-directory args))
  (shell-command (format "ruby ~/configuration/femacs.rb %s %s" femacs-parent-git-directory args))
  )

(defun ensure-femacs-file(dir)
  (shell-command (format "ruby ~/configuration/femacs.rb %s" dir))
  )

(defun start-femacs-mode(dir)
  (ensure-femacs-file dir)
  ;; (setq femacs-config (ensure-femacs-file dir))
  ;; (message femacs-config)
  )

(defun parent-dir (file &optional relativep)
  "Return the parent directory of FILE, or nil if none.
Optional arg RELATIVEP non-nil means return a relative name, that is,
just the parent component."
  (let ((parent  (file-name-directory (directory-file-name (expand-file-name file))))
        relparent)
    (when relativep
      (setq relparent  (file-name-nondirectory (directory-file-name parent))))
    (and (not (equal parent file))  (or relparent  parent))))

(defun is-git-directory(dir)
  (and dir (file-exists-p (concat dir ".git")))
  )

(defun rec-find-parent-git-directory(current-dir)
  (if current-dir
      (if (is-git-directory current-dir)
          (setq femacs-parent-git-directory current-dir)
        (rec-find-parent-git-directory (parent-dir current-dir))
        )
    )
  )

(defun find-parent-git-directory()
  (setq femacs-parent-git-directory nil)

  (if (buffer-file-name)
      (rec-find-parent-git-directory (file-name-directory (buffer-file-name)))
    )
  )

(defun setup-femacs-mode()
  (interactive)
  (local-set-key "\C-F\C-A" 'fmacs-add-favorite)
  (local-set-key "\C-F\C-F" 'fmacs-find-favorite)
  )

(setup-femacs-mode)
