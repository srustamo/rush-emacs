;;* Requires
(require 'org)

;;* org-agenda-mode-map
(require 'org-agenda)

(let ((map org-agenda-mode-map))
  ;; unbind
  ;; (define-key map "a" 'worf-reserved)
  ;; (define-key map "b" 'worf-reserved)
  ;; (define-key map "c" 'worf-reserved)
  ;; (define-key map "d" 'worf-reserved)
  ;; (define-key map "e" 'worf-reserved)
  ;; (define-key map "f" 'worf-reserved)
  ;; (define-key map "n" 'worf-reserved)
  ;; (define-key map "o" 'org-agenda-show)
  ;; (define-key map "u" 'worf-reserved)
  ;; (define-key map "w" 'worf-reserved)
  ;; (define-key map "y" 'worf-reserved)
  ;; (define-key map "z" 'worf-reserved)
  ;; arrows
  (define-key map "j" 'org-agenda-next-item)
  (define-key map "k" 'org-agenda-previous-item)
  (define-key map "h" 'org-agenda-earlier)
  (define-key map "l" 'org-agenda-later)
  ;; worf
  ;; (define-key map "s" 'worf-schedule)
  ;; (define-key map "N" 'worf-agenda-narrow)
  ;; (define-key map "W" 'worf-agenda-widen)
  ;; (define-key map "t" 'worf-todo)
  ;; misc
  ;; (define-key map "p" 'ora-org-pomodoro)
  (define-key map (kbd "C-j") 'org-open-at-point)
  (define-key map "i" 'org-agenda-clock-in)
  (define-key map "O" 'org-agenda-clock-out)
  (define-key map "0" 'digit-argument)
  (define-key map "1" 'digit-argument)
  (define-key map "v" 'hydra-org-agenda-view/body)
  (define-key map "x" 'hydra-org-agenda-ex/body)
  (define-key map "S" 'org-save-all-org-buffers)
  ;; (define-key map "T" 'worf-clock-in-and-out)
  ;; disable
  (define-key map "f" nil))

(defhydra hydra-org-agenda-ex (:color blue :columns 2)
  "x"
  ("a" org-agenda-archive-default-with-confirmation "archive")
  ("b" org-agenda-earlier "earlier")
  ("c" org-agenda-goto-calendar "calendar")
  ("e" org-agenda-set-effort "effort")
  ("h" org-agenda-holidays "holidays")
  ("i" org-agenda-diary-entry "diary entry")
  ("j" org-agenda-goto-date "goto date")
  ("k" org-agenda-capture "capture")
  ("l" org-agenda-log-mode "log-mode")
  ("o" delete-other-windows "one window")
  ("r" org-agenda-redo "redo")
  ("u" org-agenda-bulk-unmark "unmark")
  ("z" org-agenda-add-note "note"))

(provide 'rush-org)
