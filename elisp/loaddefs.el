;;; loaddefs.el --- automatically extracted autoloads
;;
;;; Code:


;;;### (autoloads nil "open-file-at-point" "open-file-at-point.el"
;;;;;;  (22747 28173 0 0))
;;; Generated autoloads from open-file-at-point.el

(autoload 'open-file-at-cursor "open-file-at-point" "\
Open the file path under cursor.
    If there is text selection, uses the text selection for path.
    If the path is starts with “http://”, open the URL in browser.
    Input path can be {relative, full path, URL}.
    This command is similar to `find-file-at-point' but without prompting for confirmation.

\(fn)" t nil)

;;;***

;;;### (autoloads nil "open-iterm" "open-iterm.el" (22747 28509 0
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

(provide 'loaddefs)
;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; loaddefs.el ends here
