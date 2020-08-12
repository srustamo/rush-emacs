;;https://emacs.stackexchange.com/questions/7650/how-to-open-a-external-terminal-from-emacs/7651#7651
;; ##########################################################
;; ### Open terminal
;; ##########################################################

;; Define a function to recognize the desktop environment easily
;; You shouldn't need to touch this function
(defun get-desktop-environment ()
  (interactive)
  (let (
    ;; Create new variable with DE name
    (de_env (getenv "XDG_CURRENT_DESKTOP"))
    ;; Make sure search is case insensitive
    (case-fold-search t))
    (cond ((eq system-type 'darwin)
       "darwin")
      ((memq system-type '(windows-nt ms-dos cygwin))
       "windows")
      ((string-match ".*kde.*" de_env)
       "kde")
      ((string-match ".*gnome.*" de_env)
       "gnome")
      ((string-match ".*unity.*" de_env)
       "unity")
      ((string-match ".*xfce.*" de_env)
       "xfce")
      ((string-match ".*lxde.*" de_env)
       "lxde")
      ((string-match ".*mate.*" de_env)
       "mate")
      ((string-match ".*cinnamon.*" de_env)
       "cinnamon")
      (t "unknown"))))

;; You can edit this function if you want to change the default command for a specific desktop
(defun get-terminal (path)
  (alist-get (get-desktop-environment)
         '(("darwin" . ("open" "-a" "Terminal.app" "."))
           ("windows" . ("cmd.exe" "/c" "start" "/wait" "C:\\Users\\srstan\\AppData\\Local\\Microsoft\\WindowsApps\\wt.exe" "-d" "."))
           ;; ("windows" . ("cmd.exe" "/k" "mode con:cols=100 lines=500"))
           ;; ("windows" . ("cmd.exe" "/c" "start" "mode con:cols=250 lines=50" "/wait" "C:\\Users\\srstan\\AppData\\Local\\Microsoft\\WindowsApps\\wt.exe" "-d" "."))
           ("kde" . ("konsole" "--workdir" "."))
           ("gnome" . ("gnome-terminal" "--working-directory=."))
           ("xfce" . ("xfce4-terminal" "--working-directory=.")))
         '("x-terminal-emulator") nil 'equal))

(use-package terminal-here
  :ensure t
  :bind (("<f6>" . terminal-here-launch))
  :config
  (setq terminal-here-terminal-command #'get-terminal))

(provide 'rush-terminal-here)
