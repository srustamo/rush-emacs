;;; loaddefs.el --- automatically extracted autoloads
;;
;;; Code:


;;;### (autoloads nil "buffers" "buffers.el" (23058 49907 0 0))
;;; Generated autoloads from buffers.el

(autoload 'rush/kill-this-buffer "buffers" "\
Kill the current buffer.

\(fn)" t nil)

;;;***

;;;### (autoloads nil "open-file-at-point" "open-file-at-point.el"
;;;;;;  (23054 44497 0 0))
;;; Generated autoloads from open-file-at-point.el

(autoload 'open-file-at-cursor "open-file-at-point" "\
Open the file path under cursor.
    If there is text selection, uses the text selection for path.
    If the path is starts with “http://”, open the URL in browser.
    Input path can be {relative, full path, URL}.
    This command is similar to `find-file-at-point' but without prompting for confirmation.

\(fn)" t nil)

;;;***

;;;### (autoloads nil "open-iterm" "open-iterm.el" (23054 44497 0
;;;;;;  0))
;;; Generated autoloads from open-iterm.el

(autoload 'get-file-dir-or-home "open-iterm" "\
If inside a file buffer, return the directory, else return home

\(fn)" t nil)

(autoload 'iterm-goto-filedir-or-home "open-iterm" "\
Go to present working dir and focus iterm

\(fn)" t nil)

(autoload 'sam--iterm-goto-filedir-or-home "open-iterm" "\
Go to present working dir and focus iterm

\(fn)" t nil)

(autoload 'iterm-focus "open-iterm" "\


\(fn)" t nil)

;;;***

;;;### (autoloads nil "text-manipulation" "text-manipulation.el"
;;;;;;  (23054 54998 0 0))
;;; Generated autoloads from text-manipulation.el

(autoload 'sort-symbols "text-manipulation" "\
Sort symbols in region alphabetically, in REVERSE if negative.
    See `sort-words'.

\(fn REVERSE BEG END)" t nil)

;;;***

;;;### (autoloads nil nil ("list-all-org-tags.el") (23054 51229 0
;;;;;;  0))

;;;***

(provide 'loaddefs)
;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; loaddefs.el ends here
