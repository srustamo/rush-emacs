;;* Customs
(require 'magit)
(csetq magit-item-highlight-face 'bold)
(csetq magit-log-margin-spec '(30 nil magit-duration-spec))
(csetq magit-time-format-string "%Y-%m-%d")
;;* Maps
;;** Status
(define-key magit-status-mode-map "j" 'magit-goto-next-section)
(define-key magit-status-mode-map "k" 'magit-goto-previous-section)
;(define-key magit-status-mode-map "h" 'magit-goto-previous-section)
;(define-key magit-status-mode-map "\C-k" 'magit-discard-item)
;(define-key magit-status-mode-map "\C-d" 'magit-discard-item)
;(define-key magit-status-mode-map "d" 'magit-discard-item)
;(define-key magit-status-mode-map "i" 'magit-toggle-section)
;(define-key magit-status-mode-map (kbd "M-m") 'lispy-mark-symbol)
;(define-key magit-status-mode-map "C" 'rush-magit-commit-add-log)
;(define-key magit-status-mode-map "v" (lambda () (interactive) (magit-visit-item t)))
;(define-key magit-status-mode-map "V" 'projectile-find-file)
;(define-key magit-status-mode-map "h" 'rush-magit-find-main-file)
;(define-key magit-status-mode-map "ox" 'rush-magit-simple-commit)
;;** Log
(define-key magit-log-mode-map "j" 'magit-goto-next-section)
(define-key magit-log-mode-map "k" 'magit-goto-previous-section)
;; (define-key magit-log-mode-map (kbd "M-w") 'rush-magit-copy-item-as-kill)
;; (define-key magit-log-mode-map "n" 'rush-magit-copy-item-as-kill)
;; (define-key magit-log-mode-map "v" 'rush-magit-visit)
;; (define-key magit-log-mode-map "o" 'rush-magit-visit-item-other-window)
;;** Commit
(define-key magit-commit-mode-map "i" 'magit-toggle-section)
(define-key magit-commit-mode-map "j" 'magit-goto-next-section)
;; (define-key magit-commit-mode-map "k" 'magit-goto-previous-section)
;; (define-key magit-commit-mode-map "n" 'rush-magit-copy-item-as-kill)
;; (define-key magit-commit-mode-map "C" 'rush-magit-commit-add-log)
;; (define-key magit-commit-mode-map "o" 'rush-magit-visit-item-other-window)
;;** Diff
(define-key magit-diff-mode-map "i" 'magit-toggle-section)
(define-key magit-diff-mode-map "j" 'magit-goto-next-section)
;; (define-key magit-diff-mode-map "k" 'magit-goto-previous-section)
;; (define-key magit-diff-mode-map "o"
;;   (lambda () (interactive) (magit-visit-item t)))
;;** Manager
(define-key magit-branch-manager-mode-map "j" 'magit-goto-next-section)
(define-key magit-branch-manager-mode-map "k" 'magit-goto-previous-section)
;; (define-key magit-branch-manager-mode-map "d" 'magit-discard-item)
;; (define-key magit-branch-manager-mode-map "u" 'magit-diff-working-tree)
;;** Blame
(eval-after-load 'magit-blame
  '(progn
    (define-key magit-blame-map "n" nil)
    (define-key magit-blame-map "p" nil)
    (define-key magit-blame-map "j" 'magit-blame-next-chunk)
    (define-key magit-blame-map "k" 'magit-blame-previous-chunk)))
;;* Hooks
;;;###autoload
(defun rush-magit-status-hook ()
  (yas-minor-mode 0))
;;;###autoload
(defun rush-magit-log-hook ())
;;;###autoload
(defun rush-magit-commit-hook ())
;;;###autoload
(defun rush-magit-diff-hook ())
;;;###autoload
(defun rush-magit-branch-manager-hook ())
;;* Functions
(defun rush-magit-find-main-file ()
  "Open the main file of the repo."
  (interactive)
  (let* ((dirname (car (last (split-string default-directory "/" t))))
         (fname (format "%s.el" dirname)))
    (when (file-exists-p fname)
      (find-file fname))))

(defun rush-magit-copy-item-as-kill ()
  (interactive)
  (let ((section (magit-current-section)))
    (if (eq (magit-section-type section) 'message)
        (let* ((basestr (buffer-substring-no-properties
                         (magit-section-beginning section)
                         (magit-section-end section)))
               (newstr
                (mapconcat
                 (lambda (x)
                   (if (> (length x) 4)
                       (substring x 4)
                     x))
                 (split-string basestr "\n")
                 "\n")))
          (kill-new newstr)
          (message "COMMIT_MSG"))
      (magit-copy-item-as-kill))))

(defun rush-magit-visit ()
  (interactive)
  (magit-section-action visit (info parent-info)
    ((diff diffstat [file untracked])
     (magit-visit-file-item info nil))
    (hunk (magit-visit-file-item parent-info nil
                                 (magit-hunk-item-target-line it)
                                 (current-column)))
    (commit (rush-magit-show-commit info))
    (stash (magit-diff-stash info))
    (branch (magit-checkout info))))

(defun rush-magit-show-commit (commit)
  "Show information about COMMIT."
  (interactive (list (magit-read-rev-with-default
                      "Show commit (hash or ref)")))
  (when (magit-git-failure "cat-file" "commit" commit)
    (user-error "%s is not a commit" commit))
  (magit-mode-setup magit-commit-buffer-name
                    #'switch-to-buffer
                    #'magit-commit-mode
                    #'magit-refresh-commit-buffer
                    commit))

(defun rush-magit-commit-add-log ()
  (interactive)
  (let* ((section (magit-current-section))
         (fun (cond ((region-active-p)
                     (prog1 (lispy--string-dwim)
                       (deactivate-mark)))
                    ((eq (magit-section-type section) 'hunk)
                     (save-window-excursion
                       (save-excursion
                         (magit-visit-item)
                         (add-log-current-defun))))))
         (file (magit-section-info
                (cl-case (magit-section-type section)
                  (hunk (magit-section-parent section))
                  (diff section)
                  (t (user-error "No change at point")))))
         (locate-buffer (lambda ()
                          (cl-find-if
                           (lambda (buf)
                             (with-current-buffer buf
                               (derived-mode-p 'git-commit-mode)))
                           (append (buffer-list (selected-frame))
                                   (buffer-list)))))
         (buffer (funcall locate-buffer)))
    (unless buffer
      (magit-commit)
      (while (not (setq buffer (funcall locate-buffer)))
        (sit-for 0.01)))
    (pop-to-buffer buffer)
    (goto-char (point-min))
    (cond ((not (re-search-forward (format "^\\* %s" (regexp-quote file))
                                   nil t))
           ;; No entry for file, create it.
           (goto-char (point-max))
           (forward-comment -1000)
           (if (= (point) 1)
               (insert file)
             (insert (format "\n\n* %s" file)))
           (when fun
             (insert (format " (%s)" fun)))
           (insert ": "))
          (fun
           ;; found entry for file, look for fun
           (let ((limit (or (save-excursion
                              (and (re-search-forward "^\\* " nil t)
                                   (match-beginning 0)))
                            (point-max))))
             (cond ((re-search-forward
                     (format "(.*\\<%s\\>.*):" (regexp-quote fun))
                     limit t)
                    ;; found it, goto end of current entry
                    (if (re-search-forward "^(" limit t)
                        (backward-char 2)
                      (goto-char limit))
                    (forward-comment -1000))
                   (t
                    ;; not found, insert new entry
                    (goto-char limit)
                    (forward-comment -1000)
                    (if (bolp)
                        (open-line 1)
                      (newline))
                    (insert (format "(%s): " fun))))))
          (t
           ;; found entry for file, look for beginning  it
           (when (looking-at ":")
             (forward-char 2))))))

(defun endless/add-PR-fetch ()
  "If refs/pull is not defined on a GH repo, define it."
  (interactive)
  (let ((fetch-address "+refs/pull/*/head:refs/pull/origin/*"))
    (unless (member fetch-address
                    (magit-get-all "remote" "origin" "fetch"))
      (when (string-match
             "github" (magit-get "remote" "origin" "url"))
        (magit-git-string
         "config" "--add" "remote.origin.fetch"
         fetch-address)))))

(defun rush-magit-visit-item-other-window ()
  (interactive)
  (magit-visit-item t))

(defun rush-magit-simple-commit ()
  (interactive)
  (save-window-excursion
    (let ((item (elt (magit-current-section) 2)))
      (ignore-errors (magit-stage-item))
      (search-forward item)
      (rush-magit-commit-add-log)
      (insert "Update")
      (git-commit-commit))))

;; (add-hook 'magit-mode-hook #'endless/add-PR-fetch)

(provide 'rush-magit)

;;* Local variables 
;; Local Variables:
;; outline-regexp: ";;\\*+\\|\\`"
;; orgstruct-heading-prefix-regexp: ";;\\*+\\|\\`"
;; eval: (when after-init-time (orgstruct-mode) (org-global-cycle 3))
;; End:
