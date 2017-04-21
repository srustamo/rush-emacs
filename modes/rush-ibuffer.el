(require 'ibuffer)
(require 'ibuffer-git)
(require 'ibuffer-vc)
;; (setq ibuffer-movement-cycle nil)
;; no prompt on buffer delete
(setq ibuffer-expert t)
(setq ibuffer-show-empty-filter-groups nil)
(csetq ibuffer-formats
   (quote
       ((mark modified read-only git-status-mini " "
                  (name 18 18 :left :elide)
                  " "
                  (size-h 9 -1 :right)
                  " "
                  (mode 16 16 :left :elide)
                  " "
                  (git-status 8 8 :left)
                  " "
				  filename-and-process)
		(mark " "
                  (name 16 -1)
                  " " filename))))

;; (setq ibuffer-formats
;;       '((mark modified read-only vc-status-mini " "
;;               (name 18 18 :left :elide)
;;               " "
;;               (size-h 9 -1 :right)
;;               " "
;;               (mode 16 16 :left :elide)
;;               " "
;;               (vc-status 16 16 :left)
;;               " "
;;               filename-and-process)))
(define-ibuffer-column size-h
       (:name "size" :inline t)
       (cond
        ((> (buffer-size) 1000000) (format "%7.1fM" (/ (buffer-size) 1000000.0)))
        ((> (buffer-size) 1000) (format "%7.1fk" (/ (buffer-size) 1000.0)))
        (t (format "%8d" (buffer-size)))))

;; (define-key ibuffer-mode-map "j" 'ibuffer-jump-to-buffer)
(define-key ibuffer-mode-map "j" 'ibuffer-forward-line)
;; (define-key ibuffer-mode-map "k" 'ibuffer-do-kill-lines)
(define-key ibuffer-mode-map "k" 'ibuffer-backward-line)
;; (define-key ibuffer-mode-map (kbd "C-t") nil)

(setq ibuffer-saved-filter-groups '(("default"
	 ("version control" (or (mode . svn-status-mode)
		    (mode . svn-log-edit-mode)
		    (name . "^\\*svn-")
		    (name . "^\\*vc\\*$")
		    (name . "^\\*Annotate")
		    (name . "^\\*git-")
		    (name . "^\\*vc-")))
	 ("emacs" (or (name . "^\\*scratch\\*$")
		      (name . "^\\*Messages\\*$")
		      (name . "^\\*ELP Profiling Results\\*$")
		      (name . "^TAGS\\(<[0-9]+>\\)?$")
		      (name . "^\\*Help\\*$")
		      (name . "^\\*info\\*$")
		      (name . "^\\*Occur\\*$")
		      (name . "^\\*grep\\*$")
		      (name . "^\\*Apropos\\*$")
		      (name . "^\\*Compile-Log\\*$")
		      (name . "^\\*Backtrace\\*$")
		      (name . "^\\*Packages\\*$")
		      (name . "^\\*Process List\\*$")
		      (name . "^\\*gud\\*$")
		      (name . "^\\*Man")
		      (name . "^\\*WoMan")
		      (name . "^\\*Kill Ring\\*$")
		      (name . "^\\*Completions\\*$")
		      (name . "^\\*tramp")
		      (name . "^\\*shell\\*$")
		      (name . "^\\*compilation\\*$")
		      (mode . Custom-mode)))
	 ("EMMS" (or  (name . "^\\*Music\\*$")
		      (name . "^\\*EMMS")
		      (mode . emms-browser-mode)))
	 ("IRC" (or (name . "^\\*Finger")
		    (mode . erc-mode)))
	 ("emacs source" (or (mode . emacs-lisp-mode)
			     (filename . "\\.el\\.gz$")))
	 ("agenda" (or (name . "^\\*Calendar\\*$")
		       (name . "^diary$")
		       (name . "^\\*Agenda")
		       (name . "^\\*org-")
		       (name . "^\\*Org")
		       (mode . org-mode)
		       (mode . muse-mode)))
	 ("latex" (or (mode . latex-mode)
		      (mode . LaTeX-mode)
		      (mode . bibtex-mode)
		      (mode . reftex-mode)))
	 ("dired" (or (mode . dired-mode))))))

;; (add-hook 'ibuffer-hook
;; 	  (lambda ()
;; 	    (ibuffer-switch-to-saved-filter-groups "default")))

(add-hook 'ibuffer-hook
    (lambda ()
      (ibuffer-projectile-set-filter-groups)
      (unless (eq ibuffer-sorting-mode 'alphabetic)
        (ibuffer-do-sort-by-alphabetic))))

;; (ibuffer-switch-to-saved-filter-groups "default")
;; (setq ibuffer-default-sorting-mode 'major-mode)

;; 29-03-2017
;;https://www.emacswiki.org/emacs/IbufferMode
;; (defadvice ibuffer-update-title-and-summary (after remove-column-titles)
;;    (save-excursion
;;       (set-buffer "*Ibuffer*")
;;       (toggle-read-only 0)
;;       (goto-char 1)
;;       (search-forward "-\n" nil t)
;;       (delete-region 1 (point))
;;       (let ((window-min-height 1)) 
;;         ;; save a little screen estate
;;         (shrink-window-if-larger-than-buffer))
;;       (toggle-read-only)))
  
;; (ad-activate 'ibuffer-update-title-and-summary)
;;30-03-2017
;;http://acidwords.com/posts/2016-06-18-collapsing-all-filter-groups-in-ibuffer.html

(defun ibuffer-collapse-all-filter-groups ()
  "Collapse all filter groups at once"
  (interactive)
  (setq ibuffer-hidden-filter-groups
        (mapcar #'car (ibuffer-current-filter-groups-with-position)))
  (ibuffer-update nil t))

;;;###autoload
(defun rush-ibuffer-hook ())

