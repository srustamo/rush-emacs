;;

;;;### (autoloads nil "init" "init.el" (22765 54234 0 0))
;;; Generated autoloads from init.el

(winner-mode 1)

(autoload 'mode-line-bell "init" "\
Briefly display a highlighted message in the mode-line.

The string displayed is the value of `mode-line-bell-string',
with a red background; the background highlighting extends to the
right margin.  The string is displayed for `mode-line-bell-delay'
seconds.

This function is intended to be used as a value of `ring-bell-function'.

\(fn)" nil nil)

(setq ring-bell-function 'mode-line-bell)

;;;***

;;;### (autoloads nil "modes/rush-buffer-menu" "modes/rush-buffer-menu.el"
;;;;;;  (22746 12398 0 0))
;;; Generated autoloads from modes/rush-buffer-menu.el

(autoload 'rush-buffer-menu-hook "modes/rush-buffer-menu" "\


\(fn)" nil nil)

(autoload 'rush-bmenu-hook "modes/rush-buffer-menu" "\


\(fn)" nil nil)

;;;***

;;;### (autoloads nil "modes/rush-dired" "modes/rush-dired.el" (22763
;;;;;;  31697 0 0))
;;; Generated autoloads from modes/rush-dired.el

(autoload 'rush-dired-hook "modes/rush-dired" "\


\(fn)" nil nil)

;;;***

;;;### (autoloads nil "modes/rush-eshell" "modes/rush-eshell.el"
;;;;;;  (22710 25910 0 0))
;;; Generated autoloads from modes/rush-eshell.el

(autoload 'eshell-this-dir "modes/rush-eshell" "\
Open or move eshell in `default-directory'.

\(fn)" t nil)

;;;***

;;;### (autoloads nil "modes/rush-ibuffer" "modes/rush-ibuffer.el"
;;;;;;  (22749 922 0 0))
;;; Generated autoloads from modes/rush-ibuffer.el

(autoload 'rush-ibuffer-hook "modes/rush-ibuffer" "\


\(fn)" nil nil)

;;;***

;;;### (autoloads nil "modes/rush-latex" "modes/rush-latex.el" (22765
;;;;;;  59850 0 0))
;;; Generated autoloads from modes/rush-latex.el

(autoload 'rush-latex-hook "modes/rush-latex" "\


\(fn)" nil nil)

;;;***

;;;### (autoloads nil "modes/rush-magit" "modes/rush-magit.el" (22746
;;;;;;  22146 0 0))
;;; Generated autoloads from modes/rush-magit.el

(autoload 'rush-magit-status-hook "modes/rush-magit" "\


\(fn)" nil nil)

(autoload 'rush-magit-log-hook "modes/rush-magit" "\


\(fn)" nil nil)

(autoload 'rush-magit-commit-hook "modes/rush-magit" "\


\(fn)" nil nil)

(autoload 'rush-magit-diff-hook "modes/rush-magit" "\


\(fn)" nil nil)

(autoload 'rush-magit-branch-manager-hook "modes/rush-magit" "\


\(fn)" nil nil)

;;;***

;;;### (autoloads nil "modes/rush-mode" "modes/rush-mode.el" (22746
;;;;;;  8840 0 0))
;;; Generated autoloads from modes/rush-mode.el

(autoload 'rush-mode "modes/rush-mode" "\
A minor mode so that my key settings override annoying major modes.

\(fn &optional ARG)" t nil)

(defvar global-rush-mode nil "\
Non-nil if Global Rush mode is enabled.
See the `global-rush-mode' command
for a description of this minor mode.
Setting this variable directly does not take effect;
either customize it (see the info node `Easy Customization')
or call the function `global-rush-mode'.")

(custom-autoload 'global-rush-mode "modes/rush-mode" nil)

(autoload 'global-rush-mode "modes/rush-mode" "\
Toggle Rush mode in all buffers.
With prefix ARG, enable Global Rush mode if ARG is positive;
otherwise, disable it.  If called from Lisp, enable the mode if
ARG is omitted or nil.

Rush mode is enabled in all buffers where
`rush-mode' would do it.
See `rush-mode' for more information on Rush mode.

\(fn &optional ARG)" t nil)

;;;***

;;;### (autoloads nil "modes/rush-nextmagit" "modes/rush-nextmagit.el"
;;;;;;  (22746 31842 0 0))
;;; Generated autoloads from modes/rush-nextmagit.el

(autoload 'rush-nextmagit-status-hook "modes/rush-nextmagit" "\


\(fn)" nil nil)

(autoload 'rush-nextmagit-log-hook "modes/rush-nextmagit" "\


\(fn)" nil nil)

(autoload 'rush-nextmagit-commit-hook "modes/rush-nextmagit" "\


\(fn)" nil nil)

(autoload 'rush-nextmagit-diff-hook "modes/rush-nextmagit" "\


\(fn)" nil nil)

(autoload 'rush-nextmagit-branch-manager-hook "modes/rush-nextmagit" "\


\(fn)" nil nil)

;;;***

;;;### (autoloads nil "rush-auto" "rush-auto.el" (22756 36808 0 0))
;;; Generated autoloads from rush-auto.el

(autoload 'rush-ctrltab "rush-auto" "\
List buffers and give it focus.

\(fn)" t nil)

(autoload 'update-all-autoloads "rush-auto" "\


\(fn)" t nil)

(autoload 'rush-terminal "rush-auto" "\
Switch to terminal. Launch if nonexistent.

\(fn)" t nil)

(autoload 'rush-ediff-buffers "rush-auto" "\


\(fn)" t nil)

(autoload 'bmk/magit-status "rush-auto" "\
Bookmark for `magit-status'.

\(fn)" t nil)

(autoload 'bmk/scratch "rush-auto" "\
Bookmark for *scratch*.

\(fn)" t nil)

(autoload 'bmk/function "rush-auto" "\
Handle a function bookmark BOOKMARK.

\(fn BOOKMARK)" nil nil)

;;;***

;;;### (autoloads nil nil ("company-statistics-cache.el" "custom.el"
;;;;;;  "hooks.el" "keys.el" "modes/rush-ag.el" "modes/rush-company.el"
;;;;;;  "modes/rush-evil.el" "modes/rush-ivy.el" "my-loadpackages.el"
;;;;;;  "my-noexternals.el" "my-packages.el" "org-repair-property-drawers.el")
;;;;;;  (22765 60343 0 0))

;;;***


;;;***
