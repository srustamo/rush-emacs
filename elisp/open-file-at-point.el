;;** Open file/url at cursor
;; 30 Jan 2014
;; http://ergoemacs.org/emacs/emacs_open_file_path_fast.html
;;;###autoload
(defun open-file-at-cursor ()
    "Open the file path under cursor.
    If there is text selection, uses the text selection for path.
    If the path is starts with “http://”, open the URL in browser.
    Input path can be {relative, full path, URL}.
    This command is similar to `find-file-at-point' but without prompting for confirmation."
  (interactive)
  (let ( (path (if (region-active-p)
		   (buffer-substring-no-properties (region-beginning) (region-end))
		 (thing-at-point 'filename) ) ))
    (if (string-match-p "\\`https?://" path)
	(browse-url path)
      (progn ; not starting “http://”
	(if (file-exists-p path)
	    (find-file path)
	  (if (file-exists-p (concat path ".el"))
	      (find-file (concat path ".el"))
	    (when (y-or-n-p (format "file doesn't exist: 「%s」. Create?" path) )
	      (find-file path )) ) ) ) ) ))

(provide 'open-file-at-point)
