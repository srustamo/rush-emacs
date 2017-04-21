
;;* Launchers
;;* Utility
;;;###autoload
(defun rush-ctrltab ()
  "List buffers and give it focus."
  (interactive)
  (if (string= "*Buffer List*" (buffer-name))
      ;; Go to next line. Go to first line if end is reached.
      (progn
        (revert-buffer)
        (if (>= (line-number-at-pos)
                (count-lines (point-min) (point-max)))
            (goto-char (point-min))
          (forward-line)))
    (list-buffers)
    (switch-to-buffer "*Buffer List*")
    (delete-other-windows)
    (forward-line)))

;;;###autoload
 (defun update-all-autoloads ()
   (interactive)
   (cd emacs-d)
   (let ((generated-autoload-file
          (expand-file-name "loaddefs.el")))
     (when (not (file-exists-p generated-autoload-file))
       (with-current-buffer (find-file-noselect generated-autoload-file)
         (insert ";;") ;; create the file with non-zero size to appease autoload
         (save-buffer)))
     (mapcar #'update-directory-autoloads
             ;; '("" "modes" "git/org-fu"))
             '("" "modes"))

     (cd "personal")
     (setq generated-autoload-file (expand-file-name "loaddefs.el"))
     (update-directory-autoloads "")

     (cd "../elisp")
     (setq generated-autoload-file (expand-file-name "loaddefs.el"))
     (update-directory-autoloads "")))

;;;###autoload
(defun rush-terminal ()
  "Switch to terminal. Launch if nonexistent."
  (interactive)
  (let ((term-buffer (if (eq system-type 'windows-nt)
                         "*shell*"
                       "*ansi-term*")))
    (if (get-buffer term-buffer)
        (switch-to-buffer term-buffer)
      (if (eq system-type 'windows-nt)
          (shell)
        (ansi-term "/bin/bash")))
    (get-buffer-process term-buffer)))

;;;###autoload
(defun rush-ediff-buffers ()
  (interactive)
  (if (= 2 (length (window-list)))
      (ediff-buffers (window-buffer (nth 1 (window-list)))
                     (current-buffer))
    (call-interactively 'ediff-buffers)))

;;* Bookmarks
;;;###autoload
(defun bmk/magit-status ()
  "Bookmark for `magit-status'."
  (interactive)
  (when (and (equal system-name "firefly")
             (buffer-file-name))
    (delete-trailing-whitespace)
    (save-buffer))
  (call-interactively 'magit-status))

;;;###autoload
(defun bmk/scratch ()
  "Bookmark for *scratch*."
  (interactive)
  (switch-to-buffer
   (get-buffer-create "*scratch*"))
  (lisp-interaction-mode))

;;;###autoload
(defun bmk/function (bookmark)
  "Handle a function bookmark BOOKMARK."
  (funcall (bookmark-prop-get bookmark 'function)))

(defun ora-bookmark+-to-bookmark ()
  "Strip bookmark+-specific properties."
  (setq bookmark-alist
        (mapcar
         (lambda (x)
           (delq nil
                 (list
                  (substring-no-properties (car x))
                  (assoc 'filename x)
                  (assoc 'front-context-string x)
                  (assoc 'rear-context-string x)
                  (assoc 'position x)
                  (assoc 'function x)
                  (assoc 'handler x))))
         bookmark-alist)))

;;* Local variables 
;; Local Variables:
;; outline-regexp: ";;\\*+\\|\\`"
;; orgstruct-heading-prefix-regexp: ";;\\*+\\|\\`"
;; eval: (when after-init-time (orgstruct-mode) (org-global-cycle 3))
;; End:
