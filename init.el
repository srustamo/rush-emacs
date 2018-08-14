;;; Commentary:
;; -*- lexical-binding: t -*-
;;# -*- mode: emacs-lisp -*- 11 Jul 2014 http://stackoverflow.com/questions/2397173/declaring-the-mode-an-emacs-file-should-be-opened-in

;;; Code:
;;* Base directory
; 24_11_2015 abo-abo oremacs init.el 
(defvar emacs-d
  (file-name-directory
;   (file-chase-links load-file-name))
   load-file-name)
  "The giant turtle on which the world rests.")

(setq package-user-dir
      (expand-file-name "elpa" emacs-d))
(package-initialize)

(let ((emacs-git (expand-file-name "git/" emacs-d)))
  (mapc (lambda (x)
          (add-to-list 'load-path (expand-file-name x emacs-git)))
        (delete ".." (directory-files emacs-git))))
(add-to-list 'load-path (expand-file-name "git/org-mode/lisp/" emacs-d))
(add-to-list 'load-path (expand-file-name "git/org-mode/contrib/lisp/" emacs-d))
(add-to-list 'load-path (expand-file-name "git/org-toodledo/" emacs-d))
(add-to-list 'load-path (expand-file-name "git/plain-org-wiki/" emacs-d))
(add-to-list 'load-path (expand-file-name "personal/" emacs-d))
(add-to-list 'load-path (expand-file-name "modes/" emacs-d))
(add-to-list 'load-path (expand-file-name  emacs-d))

(let ((emacs-git (expand-file-name "elisp" emacs-d)))
  (mapc (lambda (x)
          (add-to-list 'load-path (expand-file-name x emacs-git)))
        (delete ".." (directory-files emacs-git))))

;;** Personal directory
(defvar user-personal-directory (let ((dir (concat emacs-d 
                                                   "personal/"))) ; must end with /
                                  (make-directory dir :parents)
                                  dir)
  "User's personal directory to contain non-git-controlled files.")
;;* Bootstrap
;;** garbage collection threshold
;;28-02-2017 https://github.com/redguardtoo/emacs.d
(defvar best-gc-cons-threshold 4000000 "Best default gc threshold value. Should't be too big.")
;; don't GC during startup to save time
(setq gc-cons-threshold most-positive-fixnum)

;;** autoloads
;;09-03-2017
;; oremacs init
(load (concat emacs-d "loaddefs.el") nil t)
(load (concat emacs-d "personal/loaddefs.el") t t)
(load (concat emacs-d "elisp/loaddefs.el") t t)

;;* Custom-set-variables (by emacs itself)
; 24.02.2017
(setq custom-file "~/.emacs.d/custom.el")
(load custom-file 'noerror)
;;* Custom-set-faces (by emacs itself)
;;* Editor behaviour
;; 25_11_2015 http://andrewjamesjohnson.com/suppressing-ad-handle-definition-warnings-in-emacs/
(setq ad-redefinition-action 'accept)
;;** Customize
(defmacro csetq (variable value)
 `(funcall (or (get ',variable 'custom-set) 'set-default) ',variable ,value))
;;** decorations
(csetq tool-bar-mode nil)
(csetq menu-bar-mode nil)
(csetq scroll-bar-mode nil)
(csetq inhibit-startup-screen t)
(csetq inhibit-startup-message t)
(csetq initial-scratch-message "")
;; (setq text-quoting-style 'grave)
;;** navigation within buffer
;(csetq next-screen-context-lines 5)
;(csetq recenter-positions '(top middle bottom))
;;** finding files
;(csetq vc-follow-symlinks t)
;(csetq find-file-suppress-same-file-warnings t)
;(csetq read-file-name-completion-ignore-case t)
;(csetq read-buffer-completion-ignore-case t)
(prefer-coding-system 'utf-8)
;;** minibuffer interaction
(csetq enable-recursive-minibuffers t)
;; (csetq read-quoted-char-radix 16)
;; 29-08-2016 Allow to read from minibuffer while in minibuffer.
(setq enable-recursive-minibuffers t)
;; 29-08-2016 Show the minibuffer depth (when larger than 1)
(minibuffer-depth-indicate-mode 1)
;;** editor behavior
;(csetq indent-tabs-mode nil)
;(cstq truncate-lines t)
;(setq ring-bell-function 'ignore)
;(csetq highlight-nonselected-windows t)
;(defalias 'yes-or-no-p 'y-or-n-p)
;(setq kill-buffer-query-functions nil)
;(add-hook 'server-switch-hook 'raise-frame)
;(defadvice set-window-dedicated-p (around no-dedicated-windows activate))
;(remove-hook 'post-self-insert-hook 'blink-paren-post-self-insert-function)
;(csetq eval-expression-print-length nil)
;(csetq eval-expression-print-level nil)
;(setq byte-compile--use-old-handlers nil)
;;; http://debbugs.gnu.org/cgi/bugreport.cgi?bug=16737
;(setq x-selection-timeout 10)
;(csetq lpr-command "gtklp")
;;** internals
;(csetq gc-cons-threshold (* 10 1024 1024))
;(csetq ad-redefinition-action 'accept)

;; allow for hippie-expand in minibuffer for Evil ex-command 29-03-2017
;;http://blog.binchen.org/posts/auto-complete-word-in-emacs-mini-buffer-when-using-evil.html
(defun minibuffer-inactive-mode-hook-setup ()
  ;; make `try-expand-dabbrev' from `hippie-expand' work in mini-buffer
  ;; @see `he-dabbrev-beg', so we need re-define syntax for '/'
  (set-syntax-table (let* ((table (make-syntax-table)))
                      (modify-syntax-entry ?/ "." table)
                      table)))
(add-hook 'minibuffer-inactive-mode-hook 'minibuffer-inactive-mode-hook-setup)

;;* Packaging
;;** 20_07_2015
;; http://doc.rix.si/org/fsem.html#sec-3-3-1
(defconst qdot/emacs-start-time (current-time))
;;** load packages file 12_Sep_14 
;; http://y.tsutsumi.io/emacs-from-scratch-part-2-package-management.html

;; (load  (expand-file-name "my-loadpackages.el" emacs-d))
(require 'cl)
;;** package-archives
(setq package-archives
      '(("melpa" . "http://melpa.org/packages/")
        ;; ("melpa-stable" . "http://melpa-stable.milkbox.net/packages/")
        ("gnu" . "http://elpa.gnu.org/packages/")))
;;** use-package
(eval-when-compile
  (require 'use-package))
(require 'diminish)                ;; if you use :diminish
(require 'bind-key)                ;; if you use any :bind variant
;;* My minor modes
;; sr 06_06_2016
;; https://www.reddit.com/r/emacs/comments/4mer1r/defining_own_keybindings_and_best_practices_when/
;; Enable `modi-mode' unless `disable-pkg-modi-mode' is set to `t' in
;; `setup-var-overrides.el'.
;;- You can also choose to override certain variables in the very beginning of the =init.el= by customizing the variables in a =setup-var-overrides.el= file placed in =user-personal-directory=. You can refer to an example of this file [[https://github.com/kaushalmodi/.emacs.d/blob/master/personal/setup-var-overrides-EXAMPLE.el][here]]. During the first time setup, copy the =setup-var-overrides-EXAMPLE.el= file to =setup-var-overrides.el= in the same directory.
(when (not (bound-and-true-p disable-pkg-rush-mode))
  (require 'rush-mode))
;;* Hooks
;;17-03-2017
(require 'hooks)
;;* Modes
(add-to-list 'auto-mode-alist '("\\.tex\\'" . TeX-latex-mode))
;;** TaskJuggler mode
(require 'taskjuggler-mode)
(add-to-list 'auto-mode-alist '("\\.tjp\\'" . taskjuggler-mode))
;;* Benchmark init.el
;; 18_01_2016
;; use-package did not work
;;(use-package benchmark-init-autoloads
;;  :commands (benchmark-init/activate)
;;  )
(require 'benchmark-init)
(benchmark-init/activate)
;;* Evil
;;  17 Jan 2014 22:36
;(add-to-list 'load-path "~/.emacs.d/evil") ; only without ELPA/el-get
(require 'evil)
; 29 Jan 2014 http://stackoverflow.com/questions/13756125/installed-emacs-evil-how-do-i-start-it
;(package-initialize)
(evil-mode t)
;; 15 Mar 2014 https://github.com/krisajenkins/evil-tabs/blob/master/README.org
;;(global-evil-tabs-mode t) ;; adds :tabedit etc to evil
;;** Evil jumper
;6 Aug 2014
;;    Version: 20140712.1011
;;   Requires: evil-0
;;    Summary: Jump like vimmers do!
;;
;;evil-jumper is an add-on for evil-mode which replaces the
;;implementation of the jump list such that it mimics more closely
;;with Vim's behavior. Specifically, it will jump across buffer
;;boundaries and revive dead buffers if necessary. The jump list can
;;also be persisted to a file and restored between sessions.
;;
;;Install:
;
;(use-package evil-jumper
;  :config
;  (evil-jumper-mode t)
;  (setq evil-jumper-auto-save-interval 30)
;  (setq evil-jumper-file "~/eviljumper"))
;;
;;Usage:
;;
;;Requiring will automatically rebind C-o and C-i.

;;** evil-org https://github.com/edwtjo/evil-org-mode
;;(add-to-list 'load-path "~/.emacs.d/plugins/evil-org-mode")
(use-package evil-org
 ;; :defer 3
 :after org
 :config
 (add-hook 'org-mode-hook 'evil-org-mode)
 (add-hook 'evil-org-mode-hook
           (lambda ()
             (evil-org-set-key-theme '(navigation))))
 ;; (define-key evil-org-mode-map "J" nil)
 ;; :diminish evil-org-mode
;:bind
;(:map evil-org-mode-map
;       ("J" . nil))
)

;;** Evil-surround 15 Aug 2014
(use-package evil-surround
:defer 10)
(global-evil-surround-mode 1)
;;** Evil-space 15 Aug 2014
;(require 'evil-space)
;;** Evil-leader 15 Aug 2014
(use-package evil-leader
:defer 10)
(global-evil-leader-mode)
;;** Evil-nerd commenter ;; 21_Aug_14
(setq evilnc-hotkey-comment-operator "\\") ;; https://github.com/redguardtoo/evil-nerd-commenter/issues/30 19_05_2015
(use-package evil-nerd-commenter
 :defer 10
)
;;** Evil-highlight-search persist
(use-package evil-search-highlight-persist
:defer 10)
(global-evil-search-highlight-persist t)

;;This Emacs extension will make isearch and evil-ex-search-incremental (the
;;"slash search") to highlight the search term (taken as a regexp) in all the
;;buffer and persistently until you make another search or clear the highlights
;;with the search-highlight-persist-remove-all command (default binding to C-x
;;SPC). This is how Vim search works by default when you enable hlsearch. This
;;extension requires the "highlight" extension. To enable: (require 'highlight)
;;(require 'evil-search-highlight-persist) (global-evil-search-highlight-persist t)

;;** Evil change modeline color depending on state 16_Nov_14
; http://stackoverflow.com/questions/16985701/change-the-color-of-the-mode-line-depending-on-buffer-state
;(lexical-let ((default-color (cons (face-background 'mode-line)
;                                   (face-foreground 'mode-line))))
;  (add-hook 'post-command-hook
;    (lambda ()
;      (let ((color (cond ((minibufferp) default-color)
;                         ((evil-insert-state-p) '("#e80000" . "#ffffff"))
;                         ((evil-emacs-state-p)  '("#af00d7" . "#ffffff"))
;                         ((buffer-modified-p)   '("#006fa0" . "#ffffff"))
;                         (t default-color))))
;        (set-face-background 'mode-line (car color))
;        (set-face-foreground 'mode-line (cdr color))))))
;;** Evil mode key translation 16_Nov_14
;; http://www.emacswiki.org/Evil
;; Note: lexical-binding must be t in order for this to work correctly.
;   (defun make-conditional-key-translation (key-from key-to translate-keys-p)
;     "Make a Key Translation such that if the translate-keys-p function returns true,
;   key-from translates to key-to, else key-from translates to itself.  translate-keys-p
;   takes key-from as an argument. "
;     (define-key key-translation-map key-from
;       (lambda (prompt)
;         (if (funcall translate-keys-p key-from) key-to key-from))))
;
;   (defun my-translate-keys-p (key-from)
;     "Returns whether conditional key translations should be active.  See make-conditional-key-translation function. "
;     (and ;; Only allow a non identity translation if we're beginning a Key Sequence.
;       (equal key-from (this-command-keys))
;       (or (evil-motion-state-p) (evil-normal-state-p) (evil-visual-state-p))))
;
;   (define-key evil-normal-state-map "c" nil)
;   (define-key evil-motion-state-map "cu" 'universal-argument)
;   (make-conditional-key-translation (kbd "ch") (kbd "C-h") 'my-translate-keys-p)
;   (make-conditional-key-translation (kbd "g") (kbd "C-x") 'my-translate-keys-p)
;  ; (make-conditional-key-translation (kbd "gg") (kbd "gg") 'my-translate-keys-p)
;;** Evil motion state key translation
;; 16_Nov_14 http://www.emacswiki.org/Evil
   ;; (define-key evil-normal-state-map "c" nil)
   ;; (define-key evil-motion-state-map "cu" 'universal-argument)
;;The second line automatically made c a Prefix Key, and its binding was somewhat arbitrary. Now we define the Key Translations:
   (define-key key-translation-map (kbd "ch") (kbd "C-h"))
   (define-key key-translation-map (kbd "cx") (kbd "C-x"))

;;** Evil visual line j k 11_02_2015
;; http://juanjoalvarez.net/es/detail/2014/sep/19/vim-emacsevil-chaotic-migration-guide/
(define-key evil-normal-state-map (kbd "j") 'evil-next-visual-line)
(define-key evil-normal-state-map (kbd "k") 'evil-previous-visual-line)
;;** Evil c-k c-j page up down  05_03_2015
;; http://juanjoalvarez.net/es/detail/2014/sep/19/vim-emacsevil-chaotic-migration-guide/
;; (define-key evil-normal-state-map (kbd "C-k") (lambda ()
;;                     (interactive)
;;                     (evil-scroll-up nil)))
;; (define-key evil-normal-state-map (kbd "C-j") (lambda ()
;;                         (interactive)
;;                         (evil-scroll-down nil)))
;;** Evil disable backspace in normal mode 06_03_2015
;; (define-key evil-normal-state-map (kbd "DEL") ",")
;;** Evil-TAB related
;;http://stackoverflow.com/questions/22878668/emacs-org-mode-evil-mode-tab-key-not-working
;;Try
;;(setq evil-want-C-i-jump nil)
;;in your ~/.emacs before (require 'evil)
;;Evil has, in evil-maps.el when evil-want-C-i-jump (define-key evil-motion-state-map (kbd "C-i")
;;  'evil-jump-forward))
;;
;;That should give you org-mode Tab functionality back shareeditflag

;18 Jan 2014 11:09
;(tool-bar-mode -1)

;;** evil-commentary 
;; 22_02_2016
(use-package evil-commentary
  :defer 4
  :config (evil-commentary-mode)
  )
 
;;** evil-mutliedit
;; 29_02_2016
;; (use-package evil-multiedit
;;   :config 
  ;; )
;;** evil-vimmish-fold
;; 09_03_2016
;; https://github.com/alexmurray/evil-vimish-fold
(use-package evil-vimish-fold
  :defer 5)

;;** evil-matchit
;;*** chen setup
;;07-09-2016 https://github.com/redguardtoo/evil-matchit/issues/66#issuecomment-244889267
(require 'evil-matchit)
(global-evil-matchit-mode 1)
(defun evilmi-your-get-tag ()
  (if (or (= (following-char) 60) ;<
          (= (following-char) 62)) ;>
      (list (point))))
(defun evilmi-your-jump (rlt num)
  (if (= (following-char) 60) (search-forward ">" nil nil))
  (if (= (following-char) 62) (search-backward "<" nil nil))
  (point))
(plist-put evilmi-plugins 'sgml-mode '((evilmi-template-get-tag evilmi-template-jump)
                                       (evilmi-simple-get-tag evilmi-simple-jump)
                                       (evilmi-your-get-tag evilmi-your-jump)
                                       (evilmi-html-get-tag evilmi-html-jump)))
;;** activate evil
(evil-mode t) ;; activating evil-mode after activating all other evil related mods
;;** load rush-evil.el
(require 'rush-evil)
;;* Org
;;27-02-2017 initialize  org
;; (use-package org 
;;   :defer 4
;;   ;; :diminish W
;;   :config
;;   ; (define-key org-mode-map (kbd "-") nil)
;;   ; :bind (:map org-mode-map 
;;         ; (("J" . nil))) ;; list of cons with key/command  to bind in the key map
;;   )
;;28-11-2017
(use-package rush-org 
  :defer 4
  ;; :diminish W
  :config
  ; (define-key org-mode-map (kbd "-") nil)
  ; :bind (:map org-mode-map 
        ; (("J" . nil))) ;; list of cons with key/command  to bind in the key map
  )
;;** Org Agenda
;;*** Org agenda files
;; 12:41 http://orgmode.org/worg/org-tutorials/orgtutorial_dto.html
;;(setq org-agenda-files (list "~/Dropbox/org/toodledo.org"
;;			     ))
;;*** Org Agenda views
;;(setq org-columns-default-format "%50ITEM %12SCHEDULED %TODO %3PRIORITY %Effort{:} %TAGS")
;;**** Org Agenda priority command
;; 16_01_2015t
;;https://lists.gnu.org/archive/html/emacs-orgmode/2010-04/msg01100.html
;; commented out this so that it does not reset customize variables coming before it
;;(setq org-agenda-custom-commands
;;      '(("c" . "Priority views")
;;        ("ca" "#A" agenda ""
;;         ((org-agenda-entry-types '(:scheduled))
;;          (org-agenda-skip-function '(org-agenda-skip-entry-if 'notregexp
;;"\\[#A\\]"))))
;;        ("cb" "#B" agenda ""
;;         ((org-agenda-entry-types '(:scheduled))
;;          (org-agenda-skip-function '(org-agenda-skip-entry-if 'notregexp
;;"\\[#B\\]"))))
;;        ("cc" "#C" agenda ""
;;         ((org-agenda-entry-types '(:scheduled))
;;          (org-agenda-skip-function '(org-agenda-skip-entry-if 'notregexp
;;"\\[#C\\]"))))
;;        ;; ...other commands here
;;        ))
;;*** Org Agenda keyboard shortcuts
;;(bind-key "Y" 'org-agenda-todo-yesterday org-agenda-mode-map) ; 4 Jul 2014 http://pages.sachachua.com/.emacs.d/Sacha.html#sec-1-4-4
;;(define-key "Y" 'org-agenda-todo-yesterday org-agenda-mode-map) ; 4 Jul 2014 http://pages.sachachua.com/.emacs.d/Sacha.html#sec-1-4-4
;; the above throws error

;;** MobileOrg
;;Set to <your Dropbox root directory>/MobileOrg.
;;16:01 http://mobileorg.ncogni.to/doc/getting-started/using-dropbox/
;;Set to the location of your Org files on your local system
(setq org-directory "~/Dropbox/org")
;; Set to the name of the file where new notes will be stored
(setq org-mobile-inbox-for-pull "~/Dropbox/org/flagged.org")
;; Set to <your Dropbox root directory>/MobileOrg.
(setq org-mobile-directory "~/Dropbox/Apps/MobileOrg")
;;22 Jan 2014 http://www.jontourage.com/2013/07/10/org-mode-mobileorg-setup/
;;(setq org-mobile-files '("~/Dropbox/org/"))
;;*** MobileOrg auto sync
;; 9 Jul 2014 http://stackoverflow.com/questions/8432108/how-to-automatically-do-org-mobile-push-org-mobile-pull-in-emacs
(defvar org-mobile-sync-timer nil)
(defvar org-mobile-sync-idle-secs (* 60 10))
(defun org-mobile-sync ()
  (interactive)
  (org-mobile-pull)
  (org-mobile-push)
;;  (org-toodledo-sync)) 22_01_2015 this did not work, error:Error running timer `org-mobile-sync': (error "Toodledo initialization must be performed on an org-mode file")
  )
(defun org-mobile-sync-enable ()
  "enable mobile org idle sync"
  (interactive)
  (setq org-mobile-sync-timer
        (run-with-idle-timer org-mobile-sync-idle-secs t
                             'org-mobile-sync)));
(defun org-mobile-sync-disable ()
  "disable mobile org idle sync"
  (interactive)
  (cancel-timer org-mobile-sync-timer))
(org-mobile-sync-enable)
;; 9 Jul 2014 http://stackoverflow.com/questions/8432108/how-to-automatically-do-org-mobile-push-org-mobile-pull-in-emacs
;;*** MobileOrg sync on exit or start
;;(add-hook 'after-init-hook 'org-mobile-pull)
;;(add-hook 'kill-emacs-hook 'org-mobile-push)
;;** Org misc
;;*** orgstruct
;;http://puntoblogspot.blogspot.com/2013/05/cool-org-mode-8-features.html
;(setq orgstruct-heading-prefix-regexp  ";; ")
;(setq orgstruct-heading-prefix-regexp  "-- ")
;; 19_05_2015 ;; this did not work
;;(define-key orgstruct-mode (kbd "<tab>") 'orgstruct-hijacker-org-cycle)
;;(eval-after-load 'orgstruct-mode '(define-key orgstruct-mode-map (kbd "TAB") 'orgstruct-hijacker-org-cycle))
;;*** Too many clock entries clutter up a heading. 4 Jul 2014 http://pages.sachachua.com/.emacs.d/Sacha.html#sec-1-4-4
;;(setq org-log-into-drawer "LOGBOOK")
;;(setq org-clock-into-drawer 1)
;;*** Org habits
;; 4 Jul 2014 http://pages.sachachua.com/.emacs.d/Sacha.html#sec-1-4-4
;(setq org-habit-graph-column 80)
;(setq org-habit-show-habits-only-for-today nil)

;;** Org clock-in clock-out http://orgmode.org/org.html#Timestamps 30 Jun 2014
;; To save the clock history across Emacs sessions, use
;;(setq org-clock-persist 'history)
;;(org-clock-persistence-insinuate)

;;** Org capture
;; 2 Jul 2014 http://orgmode.org/org.html#Capture-_002d-Refile-_002d-Archive
(setq org-default-notes-file (concat org-directory "/notes.org"))
(define-key global-map "\C-cc" 'org-capture)
;; 2 Jul 2014 http://orgmode.org/org.html#Capture-_002d-Refile-_002d-Archive
;;(setq org-capture-templates
;;      '(("t" "Todo" entry (file+headline "~/Dropbox/org/gtd.org" "Tasks")
;;;             "* TODO %?\n  %i\n  %a")
;;	"* TODO %?\n%U\n%a\n" :clock-in t :clock-resume t) ;;3 Jul 2014 http://doc.norang.ca/org-mode.html#OrgFiles
;;	("j" "Journal" entry (file+datetree "~/Dropbox/org/journal.org")
;;	"* %?\nEntered on %U\n %i\n  %a" :clock-in t :clock-resume t)))
;;					;"* %?\nEntered on %U\n  %i\n  %a")))
;;*** Org capture tags
;; 12_02_2015 tries to dynamically create tags for capture buffers
;; Org Complete Tags Always Offer All Agenda Tag - in custmize
(add-hook 'org-capture-mode-hook
               (lambda ()
                 (set (make-local-variable
                       'org-complete-tags-always-offer-all-agenda-tags)
                      t)))
;;** Org Tasks
(setq org-enforce-todo-dependencies t)
(setq org-track-ordered-property-with-tag t) ; 4 Jul 2014 http://pages.sachachua.com/.emacs.d/Sacha.html#sec-1-4-4
;;** Org Toodledo
;; 9 Jul 2014 https://github.com/christopherjwhite/org-toodledo
(use-package org-toodledo
  :defer 2		 
  :config
)
;;(setq org-toodledo-sync-on-save "yes")
;;*** Org Toodledo sync timer

;;** Org Autocomplete
;; 10 Jul 2014 https://github.com/aki2o/org-ac
;; You'll be able to use auto-complete as substitute for pcomplete which is bound to M-TAB.
;;(require 'org-ac)

;; Make config suit for you. About the config item, eval the following sexp.
;; (customize-group "org-ac")

;;(org-ac/config-default)
;;** Org gcal
(use-package org-gcal
  :defer 5
)
;;** Org Evernote
;(require 'org-evernote)
;;** Org Pomodoro
(use-package org-pomodoro
 :defer 6
  )

;;Long Break~%
;org-pomodoro-time-format is a variable defined in `org-pomodoro.el'.
;Its value is t
;Original value was "%.2m:%.2s"
;;'(org-pomodoro-time-format "%.2m:%.2s")
;;** Org Tasks
(use-package org-inlinetask
 :defer 5 )
;;** Org journal
;; (require 'org-journal) ; http://www.emacswiki.org/emacs/OrgJournal 25_Sep_14
;;** Appt 13_Nov_14 http://blog.devnode.pl/blog/2012/01/04/get-notified/
;(setq
;  appt-activate 1
;;;  appt-message-warning-time 15
;;;  appt-display-mode-line t
;  appt-display-format 'window)
;;** Org appointments reminder
;; http://orgmode.org/worg/org-hacks.html 13_Nov_14
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; For org appointment reminders
;; Get appointments for today
;(defun my-org-agenda-to-appt ()
;  (interactive)
;  (setq appt-time-msg-list nil)
;  (let ((org-deadline-warning-days 0))    ;; will be automatic in org 5.23
;        (org-agenda-to-appt)))
;
;;; Run once, activate and schedule refresh
;(my-org-agenda-to-appt)
;(appt-activate t)
;(run-at-time "24:01" nil 'my-org-agenda-to-appt)
;
;; 5 minute warnings
;(setq appt-message-warning-time 15)
;(setq appt-display-interval 5)
;
;; Update appt each time agenda opened.
;(add-hook 'org-finalize-agenda-hook 'my-org-agenda-to-appt)

;;** Org babel
;; 14_01_2015
;(org-babel-do-load-languages
;  'org-babel-load-languages (quote ((emacs-lisp . t)
;                                     (sqlite . t)
;                                     (R . t)
;                                     (python . t))))

;;** Org protocol
(use-package org-capture
  :defer 20)
(use-package org-protocol
  :defer 20)

;(setq org-capture-templates
;      (quote (
;              ("x" "org-protocol" entry (file "~/web.org")
;               "* TODO Review %c\n%U\n%i\n" :immediate-finish))))

;;** Org mac-link module
(add-hook 'org-mode-hook (lambda ()
  (define-key org-mode-map (kbd "C-c g") 'org-mac-grab-link)))

;;** Wunderlist
;; 12:25 https://github.com/myuhe/org-wunderlist.el
;; (require 'org-wunderlist)
;;** Org export docx
;; 21_08_2015 http://kitchingroup.cheme.cmu.edu/blog/2015/06/11/ox-pandoc-org-mode-+-org-ref-to-docx-with-bibliographies/
(use-package ox-pandoc
  :defer 7)
;;** Org ellispses
;; 06_11_2015 http://endlessparentheses.com/changing-the-org-mode-ellipsis.html?source=rss
(setq org-ellipsis "…")
;(setq org-ellipsis "⤵")
;;** Org reveal
;; 13_11_2015
(use-package ox-reveal
  :defer 8)
;;** Org hooks
;;*** Org Wrap lines
(add-hook 'org-mode-hook '(lambda ()
;; make the lines in the buffer wrap around the edges of the screen.
;; to press C-c q  or fill-paragraph ever again!
(visual-line-mode)
;(org-indent-mode))
))
;;** Org my functions
;;25_03_2016
;;https://www.reddit.com/r/emacs/comments/4a4a8n/better_system_than_defthelmorgmode_to_manage_many/
(defun my-org-occur-tag-search (tag)
  (interactive
   (list (let ((org-last-tags-completion-table
                (if (derived-mode-p 'org-mode)
                    (org-uniquify
                     (delq nil (append (org-get-buffer-tags)
                                       (org-global-tags-completion-table))))
                  (org-global-tags-completion-table))))
           (org-icompleting-read
            "Tag: " 'org-tags-completion-function nil nil nil
            'org-tags-history))))
  (if tag (org-occur-in-agenda-files
           (concat ":" tag ":"))))
;;** org faces
(setq org-todo-keyword-faces
  (quote (("NEXT" :foreground "green" :weight bold))))
;;* Cyrillic
;;(require jcuken-fix) ;; 13_02_2015 installed this package, but it doesn't seem to work
;; 13_02_2015 http://www.cofault.com/2011/12/cue-key.html ;; this works with Rus layout on Mac
(mapcar*
 (lambda (r e) ; R and E are matching Russian and English keysyms
   ; iterate over modifiers
   (mapc (lambda (mod)
    (define-key input-decode-map
      (vector (list mod r)) (vector (list mod e))))
  '(control meta super hyper))
   ; finally, if Russian key maps nowhere, remap it to the English key without
   ; any modifiers
   (define-key local-function-key-map (vector r) (vector e)))
   "йцукенгшщзхъфывапролджэячсмитьбюЙЦУКЕНГШЩЗХЪФЫВАПРОЛДЖЭЯЧСМИТЬБЮ"
   "qwertyuiop[]asdfghjkl;'zxcvbnm,.QWERTYUIOP[]ASDFGHJKL;'ZXCVBNM,.")
;;* Key bindings
;(define-key global-map [(control ,)] nil)
;(define-key global-map [(control ,)] ctl-x-map)
;;** General
;;27-02-2017
;; (use-package general 
;;   :defer 12
;;   ;; :diminish W
;;   ;; :commands  (which-key-mode)
;;   )
;; (general-define-key
;;  :states '(normal visual insert emacs)
;;  :prefix "-"
;;   ";" '(iterm-focus :which-key "focus iterm")
;;   "-" '(iterm-goto-filedir-or-home :which-key "focus iterm - goto dir")
;; )
;;28-02-2017 https://sam217pa.github.io/2016/08/30/how-to-make-your-own-spacemacs/
(use-package general
  :defer 5
  :ensure t
  :config
  (general-evil-setup t)

  (general-define-key
   :states '(normal insert emacs)
   :prefix "C-SPC"
   :non-normal-prefix "C-SPC"
   "l" '(avy-goto-line)
   "a" 'align-regexp
   )

  ;; (general-define-key
  ;;  :states '(normal motion emacs)
  ;;  :prefix "SPC"
  ;;  "ar" '(ranger :which-key "call ranger")
  ;;  "g"  '(:ignore t :which-key "Git")
  ;;  "gs" '(magit-status :which-key "git status")
   ;; )
;;28-02-2017 srustamo 
  (general-define-key
   :states '(normal visual emacs)
   :prefix "-"
    ";" '(iterm-focus :which-key "focus iterm")
    "-" '(iterm-goto-filedir-or-home :which-key "focus iterm - goto dir")
  )
)
;; 13_02_2015 https://github.com/vvv/dotfiles/blob/master/.emacs
(setq confirm-kill-emacs 'yes-or-no-p) ; say "no" to accidental terminations
;;** Which-key
;; 17_09_2015
(use-package which-key
  :defer 2
  ;; :diminish W
  :config (which-key-mode)
  )
; 21_10_2015 swipter-mc
;; http://oremacs.com/2015/10/14/swiper-mc/
(global-set-key (kbd "C-7") 'swiper-mc)
;;** unbinded keys
(require 'unbound)
;;** Org-mode hook key-bindings 14_Oct_14 did not work
(eval-after-load 'org
 '(progn
    (define-key org-mode-map  (kbd "\C-c s") 'screenshot)
    (define-key org-mode-map  (kbd "\C-c i") 'refresh-iimages)))
;;** Second attempt 14_Oct_14 ; did not work
;(add-hook 'org-mode-hook
;   '(lambda ()
;    (define-key org-mode-map [<C-cs>] 'screenshot)))
;;** Trying the above  with global key : this worked set 15_Oct_14
(global-set-key (kbd "\C-c s") 'screenshot)
;; (global-set-key (kbd "\C-c i") 'refresh-iimages)
;;** Trying to differentiate Tab and C-i
; differentiate tab from C-i 08_Oct_14 http://stackoverflow.com/questions/1792326/how-do-i-bind-a-command-to-c-i-without-changing-tab
;(setq global-function-key-map (delq '(kp-tab . [9]) function-key-map))
;(setq global-function-key-map (delq '(tab . [9]) function-key-map))
;(setq local-function-key-map (delq '(kp-tab . [9]) local-function-key-map))
;(setq local-function-key-map (delq '(tab . [9]) local-function-key-map))
;;** Another try with c-i and tab 10_Oct_14 http://stackoverflow.com/questions/4512075/how-to-use-ctrl-i-for-an-emacs-shortcut-without-breaking-tabs
;; Translate the problematic keys to the function key Hyper,
;; then bind this to the desired ctrl-i behavior
;; (keyboard-translate ?\C-i ?\H-i)
;; (global-set-key [?\H-i] 'evil-jumper/forward)
;;** More trying tab C-i 16_Oct_14 https://groups.google.com/forum/#!topic/gnu.emacs.help/HQRBB1iP2UM
;1. Don't translate tab into C-i.
;(define-key function-key-map [tab] nil)
;(define-key local-function-key-map [tab] nil)
;(define-key local-function-key-map [kp-tab] nil)

;2. Swap the meanings of tab and C-i.
;(define-key key-translation-map [9] [TAB])
;(define-key key-translation-map [TAB] [9])
;(define-key key-translation-map [tab] [9])

;3. Bind tab (which is now actually C-i)
;(global-set-key [tab] 'isearch-forward)
;(global-set-key  (kbd "C-i") 'evil-jumper/forward)
;;** tab vs c-i 19_05_2015
;; 19_05_2015
;; ;; (setq local-function-key-map (delq '(kp-tab . [9]) local-function-key-map))
;; ;; ;; this is C-i
;;  (global-set-key (kbd "C-i") (lambda () (interactive) (message "C-i")))
;; ;; ;; this is <tab> key
;;  (global-set-key (kbd "<tab>") (lambda () (interactive) (message "<tab>")))
;;** Use Tab to Indent or Complete 03_02_2016
;;http://emacsredux.com/blog/2016/01/31/use-tab-to-indent-or-complete/ 
(setq tab-always-indent 'complete)
;;** Key-chord 09_Nov_14
(use-package key-chord
  ;; :defer 5
  :config
  (key-chord-define-global "BB" 'ivy-switch-buffer)
  ;; (key-chord-define-global "FF" 'find-file)
  (key-chord-define-global "FF" 'counsel-find-file)
  ;; (key-chord-define-global "RR" 'recentf-open-files)
  (key-chord-define-global "OO" 'delete-other-windows)
  (key-chord-define-global "CC" 'winner-undo)
 ;(key-chord-define-global "gg" 'winner-undo)
  ;; 16_07_2015 http://timothypratley.blogspot.com/2015/07/seven-specialty-emacs-settings-with-big.html
  ;; (key-chord-define-global "jx" 'smex)
  ;; (key-chord-define-global "jf" 'helm-M-x)
  (key-chord-define-global "jf" 'counsel-M-x)
  ;; (key-chord-define-global "jf" 'smex)
  (key-chord-define-global "##" 'minibuffer-keyboard-quit)
  
  (key-chord-define evil-normal-state-map "bl" 'ido-switch-buffer)
  (key-chord-define evil-normal-state-map "bj" 'evil-prev-buffer)
  (key-chord-define evil-normal-state-map "bk" 'evil-next-buffer)
  (key-chord-define evil-normal-state-map "b;" 'kill-this-buffer)
  (key-chord-define evil-normal-state-map "ff" 'counsel-find-file)
  (key-chord-define evil-normal-state-map "wh" 'evil-window-left)
  (key-chord-define evil-normal-state-map "wj" 'evil-window-down)
  (key-chord-define evil-normal-state-map "wk" 'evil-window-up)
  (key-chord-define evil-normal-state-map "wl" 'evil-window-right)
  (key-chord-define-global "AA" 'avy-goto-char-timer)
  (key-chord-mode t)
  )

;; 24_07_2015

;;** Hydra 23_01_2015
;; (use-package hydra
; :defer 1
  ;; )
(require 'hydra)
;; http://oremacs.com/2015/01/20/introducing-hydra/ 23_01_2015
;(require 'hydra-examples)
;(hydra-create "C-M-o" hydra-example-move-window-splitter)
;(hydra-create "C-M-l" hydra-example-windmove)
;;*** sauron 23_07_2015 more hydra
;;; http://doc.rix.si/org/fsem.html#sec-3-1-1
;;; The showme hydra on C-x z is various things that pop up mini buffers for more information; kill rings, history, and that sort of thing, searching using surfraw.
;;(use-package sauron)
;(defhydra hydra-showme (global-map "C-c u")
;  "
;Emacs Variables ---> Tools ---------------> Informational
;_k_: kill ring         _c_: calculator          _C_: World clock
;_b_: buffer list                                _w_: Weather
;_m_: mark ring         _g_: surf using surfraw  _W_: Weather (Quick)
;_e_: eshell history                           _d_: Calendar
;"
;  ("k" helm-show-kill-ring)
;  ("b" helm-buffers-list)
;  ("m" helm-all-mark-rings)
;  ("c" helm-calcul-expression)
;  ("e" helm-eshell-history)
;;  ("s" sauron-toggle-hide-show)
;  ("g" helm-surfraw)
;  ("C" helm-world-time)
;  ("w" sunshine-forecast)
;  ("W" sunshine-quick-forecast)
;  ("d" calendar))

;;*** window, frame moving etc 23_07_2015 hydra
;;; First, we define, hydra-window, a hydra that allows you to move between frames and windows, using a combination of windmove, ace-window and winner. We bind that to C-x w.
;;; (install-pkgs '(ace-window
;;;                 transpose-frame))
;;; (winner-mode)
;(use-package hydra-examples
;:defer 5)
;(use-package transpose-frame
;:defer 5)
;(defhydra hydra-window (:color pink
;		       :hint nil)
;  "
;^Split^             ^Delete^           ^Move^          ^Frames       ^Misc       ^Switch
;^^^^^^^^--------------------------------------------------------------------------------
;_v_ert          _o_nly                 _s_wap       _f_rame new      _a_ce     _p_revious_
;_x_:horz        _da_ce                 ^ ^          _df_ delete      _u_ndo    _n_ext buffer
;^ ^             _dw_indow              ^ ^          ^ ^              _r_edo    ^ ^
;^ ^             _db_uffer              ^ ^          ^ ^              ^ ^       ^ ^
;^ ^             _df_rame
;"
;  ("h" windmove-left)
;  ("j" windmove-down)
;  ("k" windmove-up)
;  ("l" windmove-right)
;  ("H" hydra-move-splitter-left)
;  ("J" hydra-move-splitter-down)
;  ("K" hydra-move-splitter-up)
;  ("L" hydra-move-splitter-right)
;  ("|" (lambda ()
;         (interactive)
;         (split-window-right)
;         (windmove-right)))
;  ("_" (lambda ()
;         (interactive)
;         (split-window-below)
;         (windmove-down)))
;  ("v" split-window-right)
;  ("x" split-window-below)
;  ("t" transpose-frame "'")
;  ("u" winner-undo)
;  ("r" winner-redo)
;  ("o" delete-other-windows :exit t)
;  ("a" ace-window :exit t)
;  ("f" new-frame :exit t)
;  ("s" ace-swap-window)
;  ("da" ace-delete-window)
;  ("dw" delete-window)
;  ("db" kill-this-buffer)
;  ("df" delete-frame :exit t)
;  ("i" ace-maximize-window "ace-one" :color blue)
;  ("b" ivy-switch-buffer "buffer")
;  ("p" previous-buffer)
;  ("q" quit-window "quit" :color blue)
;  ("n" next-buffer)
;  ("g" hydra-git-gutter/body "Git Gutter" :exit t)
;  ("SPC" nil "quit"))
;(define-key global-map "\C-xw" 'hydra-window/body)
;(define-key evil-normal-state-map " " nil)
;(define-key evil-normal-state-map " " 'hydra-window/body)
;;*** Hydra helpers
;(require 'windmove)
;
;(defun hydra-move-splitter-left (arg)
;  "Move window splitter left."
;  (interactive "p")
;  (if (let ((windmove-wrap-around))
;        (windmove-find-other-window 'right))
;      (shrink-window-horizontally arg)
;    (enlarge-window-horizontally arg)))
;
;(defun hydra-move-splitter-right (arg)
;  "Move window splitter right."
;  (interactive "p")
;  (if (let ((windmove-wrap-around))
;        (windmove-find-other-window 'right))
;      (enlarge-window-horizontally arg)
;    (shrink-window-horizontally arg)))
;
;(defun hydra-move-splitter-up (arg)
;  "Move window splitter up."
;  (interactive "p")
;  (if (let ((windmove-wrap-around))
;        (windmove-find-other-window 'up))
;      (enlarge-window arg)
;    (shrink-window arg)))
;
;(defun hydra-move-splitter-down (arg)
;  "Move window splitter down."
;  (interactive "p")
;  (if (let ((windmove-wrap-around))
;        (windmove-find-other-window 'up))
;      (shrink-window arg)
;    (enlarge-window arg)))
;
;(defvar rectangle-mark-mode)
;(defun hydra-ex-point-mark ()
;  "Exchange point and mark."
;  (interactive)
;  (if rectangle-mark-mode
;      (rectangle-exchange-point-and-mark)
;    (let ((mk (mark)))
;      (rectangle-mark-mode 1)
;(goto-char mk))))

;;*** hydra buffer menu
;; 23_07_2015 https://github.com/abo-abo/hydra
;(defhydra hydra-buffer-menu (:color pink
;                             :hint nil)
;  "
;^Mark^             ^Unmark^           ^Actions^          ^Search
;^^^^^^^^-----------------------------------------------------------------
;_m_: mark          _u_: unmark        _x_: execute       _R_: re-isearch
;_s_: save          _U_: unmark up     _b_: bury          _I_: isearch
;_d_: delete        ^ ^                _g_: refresh       _O_: multi-occur
;_D_: delete up     ^ ^                _T_: files only: % -28`Buffer-menu-files-only
;_~_: modified
;"
;  ("m" Buffer-menu-mark)
;  ("u" Buffer-menu-unmark)
;  ("U" Buffer-menu-backup-unmark)
;  ("d" Buffer-menu-delete)
;  ("D" Buffer-menu-delete-backwards)
;  ("s" Buffer-menu-save)
;  ("~" Buffer-menu-not-modified)
;  ("x" Buffer-menu-execute)
;  ("b" Buffer-menu-bury)
;  ("g" revert-buffer)
;  ("T" Buffer-menu-toggle-files-only)
;  ("O" Buffer-menu-multi-occur :color blue)
;  ("I" Buffer-menu-isearch-buffers :color blue)
;  ("R" Buffer-menu-isearch-buffers-regexp :color blue)
;  ("c" nil "cancel")
;  ("v" Buffer-menu-select "select" :color blue)
;  ("o" Buffer-menu-other-window "other-window" :color blue)
;  ("q" quit-window "quit" :color blue))
;
;(define-key Buffer-menu-mode-map "." 'hydra-buffer-menu/body)

;;*** git-gutter
;(defhydra hydra-git-gutter (:pre (git-gutter-mode 1)
;                            :hint nil)
;  "
;Git gutter:
;  _j_: next hunk        _s_tage hunk     _q_uit
;  _k_: previous hunk    _r_evert hunk    _Q_uit and deactivate git-gutter
;  ^ ^                   _p_opup hunk
;  _h_: first hunk
;  _l_: last hunk        set start _R_evision
;"
;  ("j" git-gutter:next-hunk)
;  ("k" git-gutter:previous-hunk)
;  ("h" (progn (goto-char (point-min))
;              (git-gutter:next-hunk 1)))
;  ("l" (progn (goto-char (point-min))
;              (git-gutter:previous-hunk 1)))
;  ("s" git-gutter:stage-hunk)
;  ("r" git-gutter:revert-hunk)
;  ("p" git-gutter:popup-hunk)
;  ("R" git-gutter:set-start-revision)
;  ("q" nil :color blue)
;  ("Q" (progn (git-gutter-mode -1)
;              ;; git-gutter-fringe doesn't seem to
;              ;; clear the markup right away
;              (sit-for 0.1)
;              (git-gutter:clear))
;       :color blue))


;;** keys.el
;;Thu Mar 16 14:18:59 2017
(require 'keys)

;;** mac-port
;;  03_03_2015 https://github.com/rolandwalker/simpleclip/issues/1
;; Typical Mac bindings
(global-set-key [(meta s)] 'save-buffer)
;(global-set-key [(meta w)]
;                (lambda () (interactive) (kill-buffer)))
;                (lambda () (interactive) (delete-window)))
(global-set-key [(meta z)] 'undo)
(global-set-key [(meta backspace)]
                (lambda nil (interactive) (kill-line 0)))
(global-set-key [(meta v)] 'yank)
;;** evil-leader
;;*** 18_05_2015
;; Emacs key bindings
;; evil-leader in emacs mode
;; (global-set-key (kbd "M-;") 'evilnc-comment-or-uncomment-lines)
;; (global-set-key (kbd "C-c l") 'evilnc-quick-comment-or-uncomment-to-the-line)
;; (global-set-key (kbd "C-c c") 'evilnc-copy-and-comment-lines)
;; (global-set-key (kbd "C-c p") 'evilnc-comment-or-uncomment-paragraphs)

;; Vim key bindings evil-leader
;; the following line was to help unset ",," from evilnc-comment-operator in evil-normal-sate-map 18_05_2015
;;(define-key evil-normal-state-map (kbd ",") 'evil-repeat-find-char-reverse)
;; 19_05_2015 this also creates ", prefix " error on load
;; 19_05_2015 12:34 - was able to fix this by setting evilnc // binding before evilnc loads.

(evil-leader/set-key
  "ci" 'evilnc-comment-or-uncomment-lines
  "cl" 'evilnc-quick-comment-or-uncomment-to-the-line
  "ll" 'evilnc-quick-comment-or-uncomment-to-the-line
  "cc" 'evilnc-copy-and-comment-lines
  "cp" 'evilnc-comment-or-uncomment-paragraphs
  "cr" 'comment-or-uncomment-region
  "cv" 'evilnc-toggle-invert-comment-line-by-line
  "\\" 'evilnc-comment-operator ; if you prefer backslash key
)
;; 23_01_2015
;; this raises error
;(hydra-create "S-z"
;  '(("l" forward-char)
;    ("h" backward-char)
;    ("j" next-line)
;    ("k" previous-line))
;    lispy-mode-map)
;; trying this
;(hydra-create "C-z"
;  '(("l" forward-char)
;    ("h" backward-char)
;    ("j" next-line)
;    ("k" previous-line))
;  (lambda (key command)
;    (define-key lispy-mode-map key command)))
;;*** 19_05_2015
(add-hook 'evil-after-load-hook
		  (lambda ()
			;; config
			(define-key evil-normal-state-map (kbd ",") nil)
			))

;; 02_02_2016 another attempt
;;https://github.com/wasamasa/dotemacs/blob/master/init.org
;;http://emacshorrors.com/posts/yaya.html
(defun my-translate-C-i (_prompt)
  (if (and (= (length (this-command-keys-vector)) 1)
           (= (aref (this-command-keys-vector) 0) ?\C-i)
           (bound-and-true-p evil-mode)
           (eq evil-state 'normal))
      (kbd "<C-i>")
    (kbd "TAB")))

(define-key key-translation-map (kbd "TAB") 'my-translate-C-i)

(with-eval-after-load 'evil-maps
  (define-key evil-motion-state-map (kbd "<C-i>") 'evil-jump-forward))
;;** Escape to escape minibuffer etc
;; https://github.com/davvil/.emacs.d/blob/master/init.el 29_07_2015
(defun minibuffer-keyboard-quit ()
  "Abort recursive edit.
In Delete Selection mode, if the mark is active, just deactivate it;
then it takes a second \\[keyboard-quit] to abort the minibuffer."
  (interactive)
  (if (and delete-selection-mode transient-mark-mode mark-active)
      (setq deactivate-mark  t)
    (when (get-buffer "*Completions*") (delete-windows-on "*Completions*"))
    (abort-recursive-edit)))

;(define-key evil-normal-state-map [escape] 'keyboard-quit)
;(define-key evil-visual-state-map [escape] 'keyboard-quit)
;(define-key minibuffer-local-map [escape] 'minibuffer-keyboard-quit)
;(define-key minibuffer-local-ns-map [escape] 'minibuffer-keyboard-quit)
;(define-key minibuffer-local-completion-map [escape] 'minibuffer-keyboard-quit)
;(define-key minibuffer-local-must-match-map [escape] 'minibuffer-keyboard-quit)
;(define-key minibuffer-local-isearch-map [escape] 'minibuffer-keyboard-quit)
;; (define-key minibuffer-local-swiper-map [escape] 'minibuffer-keyboard-quit)

;;* Editing (tab stops etc)
(defun my-tab-related-stuff ()
   (setq indent-tabs-mode t)
   (setq tab-stop-list (number-sequence 4 200 4))
   (setq tab-width 4)
   (setq indent-line-function 'insert-tab))
(require 'whitespace)
;; (add-hook 'org-mode-hook 'my-tab-related-stuff)
;;** TODO
;; (run-with-idle-timer 6 nil (lambda() ((require 'whitespace))))

;;* Copy paste
;; http://pragmaticemacs.com/emacs/cut-or-copy-current-line-with-easy-kill/ 10_08_2015
(global-set-key [remap kill-ring-save] 'easy-kill)
;; ** Simpleclip
;; 30_11_2015
(use-package simpleclip
  :disabled t
  :ensure t
  :config (simpleclip-mode 1)
  )
;; 29 Jan 2014 http://unix.stackexchange.com/questions/74241/emacs-elpa-load-packages
;; (let ((default-directory "~/.emacs.d/elpa"))
    ;; (normal-top-level-add-subdirs-to-load-path))

;;* Stuff before customize
;;** Smart mode line 28_01_2015
;; 28_01_2015 problem is that emacsclient does not inherit sml light theme, sets it to dark for adwaita. customize theme just
;; does not allow clicking.
;; Normal emacs uses light sml theme. Moved sml up here before customize.
;; (require 'smart-mode-line)
;; 28_01_2015 sml/setup here asks for confirmation of safe theme. trying to move this below customize
;(sml/setup)

;;* Notifications
;;** Todochiku
;; 13_Nov_14 http://blog.devnode.pl/blog/2012/01/04/get-notified/
(use-package todochiku
  :defer 5
  :config
  (setq todochiku-command "growlnotify")

  (setq org-show-notification-handler
  '(lambda (notification)
     (todochiku-message "org-mode notification" notification
                        (todochiku-icon 'emacs)))))

;;** Notify
;; (autoload 'notify "notify" "Notify TITLE, BODY.")
(use-package notify
  :defer 5)
(setq notify-method 'notify-via-message)
;;** Growl
(use-package grr
  :defer 5)
;;* UI
;;** Interface needs to be minimal...
(put 'scroll-left 'disabled nil)
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
;;(if (fboundp 'blink-cursor-mode) (blink-cursor-mode -1))
(if (fboundp 'menu-bar-mode) (menu-bar-mode -1))
(transient-mark-mode t)
;; -------------- [ diminish ]
;; consider this: http://www.emacswiki.org/emacs/DelightedModes
;;** diminish: Makes minor mode names in the modeline shorter.
;;(require 'diminish)
;;(eval-after-load "flyspell" '(diminish 'flyspell-mode))
;;(eval-after-load "abbrev"   '(diminish 'abbrev-mode))
;;(eval-after-load "whitespace" '(diminish 'WS))
;;(eval-after-load "Emacs-Lisp" '(diminish 'EmLi))
(eval-after-load "Undo-Tree" '(diminish 'undo-tree-mode "U-T")) ;; http://emacs-fu.blogspot.com/2010/05/cleaning-up-mode-line.html 1 Jul 2014
;(eval-after-load "Projectile" '(diminish 'projectile-mode "Pj"))
(eval-after-load "Company" '(diminish 'company-mode "co")) 
;;(eval-after-load "Helm" '(diminish 'helm-mode "Hlm"))
;; (eval-after-load "OrgStruct" '(diminish 'orgstruct-mode "OrgS")) 
;; (diminish 'orgstruct-mode "OrgS") 
(diminish 'orgstruct-mode) 
(diminish 'evil-commentary-mode) 
;;(eval-after-load "EvilOrg" '(diminish 'evil-org-mode "EvOrg")) 
;; (eval-after-load "ElDoc" '(diminish 'eldoc-mode "ElD")) 
(diminish 'eldoc-mode) 

;; Major mode dimish 1 Jul 2014 http://emacs-fu.blogspot.com/2010/05/cleaning-up-mode-line.html
(add-hook 'emacs-lisp-mode-hook
  (lambda()
    (setq mode-name "el") (show-paren-mode t)))

;;** Smart mode-line
;(require 'smart-mode-line)
;(sml/setup)

;;** Startup theme
;;** terminal colors
;;07-09-2016
(set-terminal-parameter nil 'background-mode 'light)
(set-frame-parameter nil 'background-mode 'light)
;;*** solarized theme
;15:52 http://superuser.com/questions/320288/how-to-find-out-the-current-color-theme-in-emacs
;(load-theme 'adwaita t); disabled 15 Mar 2014, set adwaita from customize-theme (see custom section)
;;(load-theme 'professional t);
(use-package solarized
  :config
  ;; Don't change size of org-mode headlines (but keep other size-changes)
  (setq solarized-scale-org-headlines nil)

  ;; Avoid all font-size changes
  (setq solarized-height-minus-1 1)
  (setq solarized-height-plus-1 1)
  (setq solarized-height-plus-2 1)
  (setq solarized-height-plus-3 1)
  (setq solarized-height-plus-4 1))
;(load-theme 'professional t)
(load-theme 'solarized-light t)
;;*** Disable all themes  09_Nov_14
;; http://stackoverflow.com/questions/22866733/emacs-disable-theme-after-loading-a-different-one-themes-conflict
(defun disable-all-themes ()
  (interactive)
  "disable all active themes."
  (dolist (i custom-enabled-themes)
    (disable-theme i)))
;;** Transparency
;;22 Jan 2014
;;16:36 http://www.emacswiki.org/emacs/TransparentEmacs
;(set-frame-parameter (selected-frame) 'alpha '(<active> [<inactive>]))
;;(set-frame-parameter (selected-frame) 'alpha '(85 50))
;;(add-to-list 'default-frame-alist '(alpha 85 50))

;;*** Transparance with a key
;; 12 Mar 2014 http://stackoverflow.com/questions/2935520/how-to-set-a-key-binding-to-make-emacs-as-transparent-opaque-as-i-want
(defun set-frame-alpha (arg &optional active)
  (interactive "nEnter alpha value (1-100): \np")
  (let* ((elt (assoc 'alpha default-frame-alist))
	 (old (frame-parameter nil 'alpha))
	 (new (cond ((atom old)     `(,arg ,arg))
		    ((eql 1 active) `(,arg ,(cadr old)))
		    (t              `(,(car old) ,arg)))))
    (if elt (setcdr elt new) (push `(alpha ,@new) default-frame-alist))
    (set-frame-parameter nil 'alpha new)))
(global-set-key (kbd "C-c t") 'set-frame-alpha)


;;** Golden ratio
;; (use-package golden-ratio
;;   :config (golden-ratio-mode 1)
;;   :diminish golden-ratio-mode
;;   )
;;;** Background color
;;(set-background-color "oldlace")
;;** Start window sizes
;;set all windows (emacs's “frames”) to some defaults
;;(setq initial-frame-alist '((width . 80) (height . 40)))
;;(setq default-frame-alist
;;'((menu-bar-lines . 1)
;;  (left-fringe)
;;  (right-fringe)
;;  (tool-bar-lines . 0)
;;  (width . 100)
;;  (height . 52)
;;  ))
;; 12 Mar 2014 http://www.elliotglaysher.org/emacs/
;;his words ;; Previously, I've been trying to control the height of emacs on different
;; platforms. Stop doing that, set 'default-frame-alist with values that work
;; on all platforms.
(setq default-frame-alist
      '((wait-for-wm . nil)
	(top . 0)
	(width . 80)
	(height . 163)
	(tool-bar-lines . 0)
	(menu-bar-lines . 0)))
;;** Hide toolbar
;; 17:10 turn off toolbar http://serverfault.com/questions/132055/how-to-check-if-emacs-is-in-gui-mode-and-execute-tool-bar-mode-only-then
;;(if window-system
;;    (tool-bar-mode 0))
;;
;;** Hide scrollbar
;(scroll-bar-mode -1)
(if window-system
    (scroll-bar-mode -1))
;;** Cursor
;;*** Insert mode cursor
;;17:42 Change the insert mode cursor to a red underline:
;(setq evil-default-cursor t) ;; 3 Jul 2014 http://www.chawdhary.co.uk/2012/06/01/emacs-cursor-color-evil.html

;;(setq evil-normal-state-cursor 'hollow)
;(setq evil-insert-state-cursor '("red" hbar))

;;*** beacon Never lose your cursor again
;; 17_11_2015 https://github.com/Malabarba/beacon/blob/master/Readme.org
;;(beacon-mode 1)
;;** Color cursor
;; 20_07_2015 http://doc.rix.si/org/fsem.html#sec-3-3-1
;;(setq evil-normal-state-cursor '(box "blue"))
;;(setq evil-visual-state-cursor '(box "red"))
;;(setq evil-motion-state-cursor '(box "green"))
;;(setq evil-emacs-state-cursor '(box "orange"))

;;** Airline Color cursor
;airline-cursor-colors Set the cursor color based on the current evil state.
;Valid Values: Enabled, Disabled
;Default: Enabled
;;** Mode-line
;;  30 Jan 2014   http://emacs-fu.blogspot.com/2011/08/customizing-mode-line.html
;; use setq-default to set it for /all/ modes
;;(setq-default mode-line-format
;;  (list
;;    ;; the buffer name; the file name as a tool tip
;;    '(:eval (propertize "%b " 'face 'font-lock-type-face
;;		    'help-echo (buffer-file-name)))
;;
;;    ;; line and column
;;    "(" ;; '%02' to set to 2 chars at least; prevents flickering
;;      (propertize "%02l" 'face 'font-lock-type-face) ","
;;      (propertize "%02c" 'face 'font-lock-type-face)
;;    ") "
;;
;;    ;; relative position, size of file
;;    "["
;;    (propertize "%p" 'face 'font-lock-constant-face) ;; % above top
;;    "/"
;;    (propertize "%I" 'face 'font-lock-constant-face) ;; size
;;    "] "
;;
;;    ;; the current major mode for the buffer.
;;    "["
;;
;;    '(:eval (propertize "%m" 'face 'font-lock-string-face
;;              'help-echo buffer-file-coding-system))
;;    "] "
;;
;;
;;    "[" ;; insert vs overwrite mode, input-method in a tooltip
;;    '(:eval (propertize (if overwrite-mode "Ovr" "Ins")
;;              'face 'font-lock-preprocessor-face
;;              'help-echo (concat "Buffer is in "
;;                           (if overwrite-mode "overwrite" "insert") " mode")))
;;
;;    ;; was this buffer modified since the last save?
;;    '(:eval (when (buffer-modified-p)
;;              (concat ","  (propertize "Mod"
;;                             'face 'font-lock-warning-face
;;                             'help-echo "Buffer has been modified"))))
;;
;;    ;; is this buffer read-only?
;;    '(:eval (when buffer-read-only
;;              (concat ","  (propertize "RO"
;;                             'face 'font-lock-type-face
;;                             'help-echo "Buffer is read-only"))))
;;    "] "
;;
;; ;;   ;; add the time, with the date and the emacs uptime in the tooltip
;; ;;   '(:eval (propertize (format-time-string "%H:%M")
;; ;;             'help-echo
;; ;;             (concat (format-time-string "%c; ")
;; ;;                     (emacs-uptime "Uptime:%hh"))))
;; ;;   " --"
;;    ;; i don't want to see minor-modes; but if you want, uncomment this:
;;     minor-mode-alist  ;; list of minor modes
;;    "%-" ;; fill with '-'
;;    ))

;;** Linum
;; 17 Mar 2014 http://stackoverflow.com/questions/21861491/how-to-add-padding-to-emacs-nw-linum-mode
;; (setq linum-format "%d ")
;;** Font (set face)
;(set-face-attribute 'default nil :height 125)
(when (eq system-type 'darwin)
      ;; default Latin font (e.g. Consolas)
      ;;(set-face-attribute 'default nil :family "Consolas")
      ;; (set-face-attribute 'default nil  :family "Monaco-9:spacing=100")
;;      (set-face-attribute 'default nil  :family "Monaco")
;      (set-face-attribute 'default nil :family "Ubuntu Mono derivative Powerline")
;;      (set-face-attribute 'default nil :family "Inconsolata for Powerline")
      ;;(set-face-attribute 'default nil :family "M+ 1m")
      (set-face-attribute 'default nil  :family "Hack")
;      (set-face-attribute 'default nil  :family "PowerlineSymbols")

      ;; default font size (point * 10)
      ;;
      ;; WARNING!  Depending on the default font,
      ;; if the size is not supported very well, the frame will be clipped
      ;; so that the beginning of the buffer may not be visible correctly.
      ;;(set-face-attribute 'default nil :height 150)
      ;;(set-face-attribute 'default nil :height 140)
      ;; (set-face-attribute 'default nil :height 130)
      (set-face-attribute 'default nil :height 125)


      ;;(set-face-attribute 'default nil :width "ultra-condensed") ;;did not work

      ;; use specific font for Korean charset.
      ;; if you want to use different font size for specific charset,
      ;; add :size POINT-SIZE in the font-spec.
      (set-fontset-font t 'hangul (font-spec :name "NanumGothicCoding"))

      ;; you may want to add different for other charset in this way.
      )

;;** Smooth scrolling
;; (require 'nurumacs)
;;*** Smooth scrooling package
;; (require 'smooth-scrolling)
;;** frame-instead-window Drew
;; (require 'oneonone)
;; (1on1-emacs)
;; (setq pop-up-frames t)
;; (require 'fit-frame)
;;** resize panes Drew doremi
;;(require 'doremi)
;;** resize panes Drew doremi-cmd
;;(require 'doremi-cmd)
;;** Rainbow delimiters
;; 16_07_2015 http://timothypratley.blogspot.com/2015/07/seven-specialty-emacs-settings-with-big.html
(add-hook 'prog-mode-hook 'rainbow-delimiters-mode)
(use-package rainbow-delimiters
 :defer 10
 :config 
(set-face-attribute 'rainbow-delimiters-unmatched-face nil
                    :foreground 'unspecified
                    :inherit 'error))
;;** Org-mode highlight current agenda line
;; Always hilight the current agenda line
;; 20_08_2015  http://doc.norang.ca/org-mode.html#HighlightCurrentAgendaLine
(add-hook 'org-agenda-mode-hook
          '(lambda () (hl-line-mode 1))
          'append)
;;** Powerline
;; 04_08_2015 https://github.com/milkypostman/powerline/issues/58
;(use-package powerline
; :config (powerline-default-theme)
;  )

;(add-hook 'desktop-after-read-hook 'powerline-reset)

(defadvice desktop-kill(before clear-power-line-cache () activate)
  (set-frame-parameter nil 'powerline-cache nil))

;(use-package powerline-evil)
;;** Airline
(use-package airline-themes)

(load-theme 'airline-solarized-gui)

(setq airline-utf-glyph-separator-left      #xe0b0
      airline-utf-glyph-separator-right     #xe0b2
      airline-utf-glyph-subseparator-left   #xe0b1
      airline-utf-glyph-subseparator-right  #xe0b3
      airline-utf-glyph-branch              #xe0a0
      airline-utf-glyph-readonly            #xe0a2
      airline-utf-glyph-linenumber          #xe0a1)
;;** Themes
;(defadvice load-theme (before theme-dont-propagate activate)
; (mapcar #'disable-theme custom-enabled-themes))
;;** custom-theme-load-path 07-09-2016

;;* Windowing
;;;###autoload
;; 30 Jan 2014  http://blog.zenspider.com/blog/2013/06/my-emacs-setup-sanity.html
(winner-mode 1)
(window-numbering-mode 1)
;;** ace-window ;; 23_07_2015 http://emacsredux.com/blog/2015/07/19/ace-jump-mode-is-dead-long-live-avy/
(use-package ace-window
    :defer 5
    :init
    (setq aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l))
    (setq aw-background nil))

(global-set-key (kbd "s-w") 'ace-window) ;; this is super key. see http://stackoverflow.com/questions/1354469/what-does-s-keyname-refer-to-in-emacs-and-how-do-i-tell-emacs-to-ignore-it
;; (global-set-key (kbd "M-p") 'ace-window) ;;set in keys.el
;; (setq aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l))

;;** Transpose frame 10_Nov_14 http://bazaar.launchpad.net/~irie/+junk/transpose-frame.el/files
;; put this file into .emacs.d and byte compiled. magic.
;(use-package transpose-frame)
;;** spaces
;; (use-package spaces)
;;** configure buffer display
;; http://www.lunaryorn.com/2015/04/29/the-power-of-display-buffer-alist.html 17_08_2015
(add-to-list 'display-buffer-alist
             `(,(rx bos "*Flycheck errors*" eos)
               (display-buffer-reuse-window
                display-buffer-in-side-window)
               (reusable-frames . visible)
               (side            . bottom)
               (window-height   . 0.4)))

(defun lunaryorn-quit-bottom-side-windows ()
  "Quit side windows of the current frame."
  (interactive)
  (dolist (window (window-at-side-list))
    (quit-window nil window)))

(global-set-key (kbd "C-c q") #'lunaryorn-quit-bottom-side-windows)

;;** Projectile
(projectile-global-mode)

(setq projectile-switch-project-action
      #'projectile-commander)
(def-projectile-commander-method ?s
  "Open a *shell* buffer for the project."
  ;; This requires a snapshot version of Projectile.
  (projectile-run-shell))
(def-projectile-commander-method ?c
  "Run `compile' in the project."
  (projectile-compile-project nil))
(def-projectile-commander-method ?\C-?
  "Go back to project selection."
  (projectile-switch-project))
(def-projectile-commander-method ?d
  "Open project root in dired."
  (projectile-dired))
(def-projectile-commander-method ?F
  "Git fetch."
  (magit-status)
  (if (fboundp 'magit-fetch-from-upstream)
      (call-interactively #'magit-fetch-from-upstream)
    (call-interactively #'magit-fetch-current)))
(def-projectile-commander-method ?j
  "Jack-in."
  (let* ((opts (projectile-current-project-files))
         (file (ido-completing-read
                "Find file: "
                opts
                nil nil nil nil
                (car (cl-member-if
                      (lambda (f)
                        (string-match "core\\.clj\\'" f))
                      opts)))))
    (find-file (expand-file-name
                file (projectile-project-root)))
    (run-hooks 'projectile-find-file-hook)
    (cider-jack-in)))


;;** perspective
;; (persp-mode)
;;*** save perspective 27-08-2016
(defun antonio/save-perspective-configuration ()
  "Save the current perspective windows configuration"
  (interactive)
  (if persp-curr
      (with-temp-file (format "~/.emacs.d/perspectives/%s" (persp-name persp-curr))
        (insert (prin1-to-string (current-window-configuration-printable))))))

(defun antonio/load-perspective-configuration ()
  "Load the current perspective windows configuration"
  (interactive)
  (let ((perspective-file (format "~/.emacs.d/perspectives/%s" (persp-name persp-curr))))
    (if (f-exists? perspective-file)
        (restore-window-configuration (read (f-read perspective-file))))))

(add-hook 'persp-before-switch-hook 'antonio/save-perspective-configuration)
(add-hook 'persp-created-hook 'antonio/load-perspective-configuration)
;;** persp-projectile 
;; http://batsov.com/projectile/
;; (require 'persp-projectile)
;; (use-package persp-projectile)
;; ;;** persp-mode this if for pers-mode.el package from https://github.com/Bad-ptr/persp-mode.el
;; ;; (with-eval-after-load "persp-mode"
;; ;;   (with-eval-after-load "ivy"
;; ;;     (add-hook 'ivy-ignore-buffers
;; ;;               #'(lambda (b)
;; ;;                   (when persp-mode
;; ;;                     (let ((persp (get-current-persp)))
;; ;;                       (if persp
;; ;;                           (not (persp-contain-buffer-p b persp))
;; ;;                         nil)))))

;; ;;     (setq ivy-sort-functions-alist
;; ;;           (append ivy-sort-functions-alist
;; ;;                   '((persp-kill-buffer   . nil)
;; ;;                     (persp-remove-buffer . nil)
;; ;;                     (persp-add-buffer    . nil)
;; ;;                     (persp-switch        . nil)
;; ;;                     (persp-window-switch . nil)
;; ;; (
;; ;; persp-frame-switch . nil))))))
;; ;;** revive 27-08-2016
;; (autoload 'save-current-configuration "revive" "Save status" t)
;; (autoload 'resume "revive" "Resume Emacs" t)
;; (autoload 'wipe "revive" "Wipe Emacs" t)
;; ;; (with-eval-after-load "persp-mode-autoloads"
;; ;;   (setq wg-morph-on nil) ;; switch off animation
;; ;;   (setq persp-autokill-buffer-on-remove 'kill-weak)
;; ;;   (add-hook 'after-init-hook #'(lambda () (persp-mode 1))))
;; ;;*** persp-ivy suppot ; this if for pers-mode.el package from https://github.com/Bad-ptr/persp-mode.el
;; ;; (with-eval-after-load "persp-mode"
;; ;;   (with-eval-after-load "ivy"
;; ;;     (add-hook 'ivy-ignore-buffers
;; ;;               #'(lambda (b)
;; ;;                   (when persp-mode
;; ;;                     (let ((persp (get-current-persp)))
;; ;;                       (if persp
;; ;;                           (not (persp-contain-buffer-p b persp))
;; ;;                         nil)))))

;; ;;     (setq ivy-sort-functions-alist
;; ;;           (append ivy-sort-functions-alist
;; ;;                   '((persp-kill-buffer   . nil)
;; ;;                     (persp-remove-buffer . nil)
;; ;;                     (persp-add-buffer    . nil)
;; ;;                     (persp-switch        . nil)
;; ;;                     (persp-window-switch . nil)
;; ;; (
;; ;; persp-frame-switch . nil))))))
;; ;;** revide 27-08-2016
;; (autoload 'save-current-configuration "revive" "Save status" t)
;; (autoload 'resume "revive" "Resume Emacs" t)
;; (autoload 'wipe "revive" "Wipe Emacs" t)
;;** Tooltips
;; (require 'pos-tip)
;;* Misc
;;** Visual bell
;; 12 Mar 2014 http://www.emacs.uniyar.ac.ru/doc/em24h/emacs101.htm
(setq visible-bell t)

;17:54 http://stackoverflow.com/questions/383918/emacs-equivalent-of-vims-command-history-for-typed-in-meta-x-commands
;type M-x customise-group RET savehist

;; 12 Mar 2014 http://blog.zenspider.com/blog/2013/06/my-emacs-setup-sanity.html
;; found at http://www.elliotglaysher.org/emacs/

;; -----------------------------------------------------------------------
;; Prevent the bell from ringing all the time.
;; -----------------------------------------------------------------------
;; nice little alternative visual bell; Miles Bader <miles /at/ gnu.org>

;; TODO(erg): Figure out why that note doesn't appear in the mode-line-bar...
(defcustom mode-line-bell-string "" ; "♪"
  "Message displayed in mode-line by `mode-line-bell' function."
  :group 'user)
(defcustom mode-line-bell-delay 0.05
  "Number of seconds `mode-line-bell' displays its message."
  :group 'user)

;; internal variables
(defvar mode-line-bell-cached-string nil)
(defvar mode-line-bell-propertized-string nil)

;;;###autoload
(defun mode-line-bell ()
"Briefly display a highlighted message in the mode-line.

The string displayed is the value of `mode-line-bell-string',
with a red background; the background highlighting extends to the
right margin.  The string is displayed for `mode-line-bell-delay'
seconds.

This function is intended to be used as a value of `ring-bell-function'."

  (unless (equal mode-line-bell-string mode-line-bell-cached-string)
    (setq mode-line-bell-propertized-string
	  (propertize
	   (concat
	    (propertize
	     "x"
	     'display
	     `(space :align-to (- center ,(string-width mode-line-bell-string))))
	    mode-line-bell-string)
	   'face '(:background "black")))
    (setq mode-line-bell-cached-string mode-line-bell-string))
  (message mode-line-bell-propertized-string)
  (sit-for mode-line-bell-delay)
  (message "eRR"))
;;;###autoload
(setq ring-bell-function 'mode-line-bell)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 19 Mar 2014 https://github.com/dacap/keyfreq http://blog.binchen.org/?p=512
(use-package keyfreq
  :defer 2
  :config
  (setq keyfreq-excluded-commands
      '(self-insert-command
        abort-recursive-edit
        forward-char
        backward-char
        previous-line
        next-line))
  (keyfreq-mode 1)
  (keyfreq-autosave-mode 1))
;;** Column number mode
;; 08_Sep_14
(column-number-mode t)
;;** Misc
;17 Jan 2014 https://sites.google.com/site/steveyegge2/effective-emacs"
;;(global-set-key "\C-x\C-m" 'execute-extended-command)
;(global-set-key "\C-;\C-m" 'execute-extended-command)

;; 14 Mar 2014 http://blog.binchen.org/?p=512
;(define-key evil-normal-state-map ",1" 'select-window-1)
;(define-key evil-normal-state-map ",2" 'select-window-2)
;(define-key evil-normal-state-map ",3" 'select-window-3)

;;** Elscreen
;; 14 Mar 2014 http://www.emacswiki.org/emacs/Evil
;;
;;(load "elscreen" "ElScreen" t)
;;(elscreen-start) ;http://stackoverflow.com/questions/17305303/emacs-elscreen-getting-wrong-type-argument-consp-nil-every-time-i-try-to-cre 14 Mar 2014
;;(define-key evil-normal-state-map (kbd "C-w t") 'elscreen-create) ;creat tab
;;(define-key evil-normal-state-map (kbd "C-w x") 'elscreen-kill) ;kill tab
;;
;;(define-key evil-normal-state-map "gT" 'elscreen-previous) ;previous tab
;;(define-key evil-normal-state-map "gt" 'elscreen-next) ;next tab

;;** Org keyboard shortcuts
;; 30 Jun 2014 http://orgmode.org/org.html#Activation
;; <2014-06-30 Mon>
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-cc" 'org-capture)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)

;;** Moving around
;; 12 Mar 2014 http://ergoemacs.org/emacs/effective_emacs.html
;; make cursor movement keys under right hand's home-row.
;;(global-set-key (kbd "M-j") 'backward-char) ; was indent-new-comment-line
;;(global-set-key (kbd "M-l") 'forward-char)  ; was downcase-word
;;(global-set-key (kbd "M-i") 'previous-line) ; was tab-to-tab-stop
;;(global-set-key (kbd "M-k") 'next-line) ; was kill-sentence

;;(global-set-key (kbd "M-SPC") 'set-mark-command) ; was just-one-space
;;(global-set-key (kbd "M-a") 'execute-extended-command) ; was backward-sentence
;;
;;(global-set-key (kbd "M-h") 'backward-char)
;;(global-set-key (kbd "M-l") 'forward-char)
;;(global-set-key (kbd "M-k") 'previous-line)
;;(global-set-key (kbd "M-j") 'next-line)
;;
;;(global-set-key (kbd "M-SPC") 'set-mark-command) ; was just-one-space
;;(global-set-key (kbd "M-a") 'execute-extended-command) ; was backward-sentence

;;** Windows/buffers
;;Winner-mode--------------------------------- http://home.thep.lu.se/~karlf/emacs.html
;; cycle through window layouts/contents
;; winner conflicts with org, use C-c left/right instead
;;(when (require 'winner nil 'noerror)
;;  (setq winner-dont-bind-my-keys t)
;;  (global-set-key (kbd "<C-c left>")  'winner-undo)
(global-set-key (kbd "\C-c 0")  'winner-undo)
;;  (global-set-key (kbd "<C-c right>") 'winner-redo)
(global-set-key (kbd "\C-c 9") 'winner-redo)
;;(global-set-key (kbd "<XF86Back>")    'winner-undo)
;;  (global-set-key (kbd "<XF86Forward>") 'winner-redo)
;;(winner-mode t))
;;--------------------------------------------

;;** Interaction log
;; 09_03_2016
(use-package interaction-log)

;;* My functions
;;** Open file/url at cursor
;; 30 Jan 2014
;; ;; http://ergoemacs.org/emacs/emacs_open_file_path_fast.html
;; 29-03-2017 moved to /elisp
(require 'open-file-at-point)
;; ;;;###autoload
;; (defun open-file-at-cursor ()
;;     "Open the file path under cursor.
;;     If there is text selection, uses the text selection for path.
;;     If the path is starts with “http://”, open the URL in browser.
;;     Input path can be {relative, full path, URL}.
;;     This command is similar to `find-file-at-point' but without prompting for confirmation."
;;   (interactive)
;;   (let ( (path (if (region-active-p)
;; 		   (buffer-substring-no-properties (region-beginning) (region-end))
;; 		 (thing-at-point 'filename) ) ))
;;     (if (string-match-p "\\`https?://" path)
;; 	(browse-url path)
;;       (progn ; not starting “http://”
;; 	(if (file-exists-p path)
;; 	    (find-file path)
;; 	  (if (file-exists-p (concat path ".el"))
;; 	      (find-file (concat path ".el"))
;; 	    (when (y-or-n-p (format "file doesn't exist: 「%s」. Create?" path) )
;; 	      (find-file path )) ) ) ) ) ))

;;** Image in line display
;; 26_Sep_14  http://shallowsky.com/blog/linux/editors/graphics-in-emacs.html
(define-derived-mode SRtext-img-mode org-mode "SR"
;;  (org-mode)
  (local-set-key "\C-cs" 'screenshot)
;  (local-set-key "\C-ci" 'refresh-iimages)
  (auto-fill-mode)
  (org-display-inline-images t t)
;  (turn-on-iimage-mode)
;  (iimage-mode-buffer t)
  )
;(setq auto-mode-alist
;  ; ...
;  ; ...
;      auto-mode-alist))
;;** Capture screenshot
;; 26_Sep_14
(defun screenshot ()
 "Prompt for a filename, then call up scrot to create an interactive screenshot"
  (interactive)
  (let ((imgfile (read-string "Filename? " "scr.jpg" 'my-history)))
;    (insert "\nfile:" imgfile "\n" )
    (insert "\n[[./" imgfile "]]\n" )

    (start-process "screencapture" nil "/usr/sbin/screencapture" "-i" imgfile)
;    (start-process "screencaptureSR2x.sh" imgfile)
    (start-process "screencaptureSR2x" nil "/usr/local/bin/screencaptureSR2x" imgfile)
;; 25_02_2015 trying to reduce the image size by 2x
;http://blog.lanceli.com/2012/08/downscale-screenshot-at-hight-resolution-on-retina-mackbook-pro.html
  ))
;;(local-set-key "\C-c s" 'screenshot)
;;** Refresh screencapture
;;26_Sep_14 http://shallowsky.com/blog/linux/editors/graphics-in-emacs.html
(defun refresh-iimages ()
  "Only way I've found to refresh iimages (without also recentering)"
  (interactive)
  (clear-image-cache nil)
  (iimage-mode nil)
  (iimage-mode t)
  (message "Refreshed images")
 )
;;** Mark org-mode file sction read-only
;; 26_03_2015 http://kitchingroup.cheme.cmu.edu/blog/2014/09/13/Make-some-org-sections-read-only/
(defun org-mark-readonly ()
  (interactive)
  (org-map-entries
   (lambda ()
     (let* ((element (org-element-at-point))
            (begin (org-element-property :begin element))
            (end (org-element-property :end element)))
       (add-text-properties begin (- end 1) '(read-only t))))
   "read_only")
 (message "Made readonly!"))

(defun org-remove-readonly ()
  (interactive)
  (org-map-entries
   (lambda ()
     (let* ((element (org-element-at-point))
            (begin (org-element-property :begin element))
            (end (org-element-property :end element))
            (inhibit-read-only t))
         (remove-text-properties begin (- end 1) '(read-only t))))
     "read_only"))

;; (add-hook 'org-mode-hook 'org-mark-readonly)

;;** Insert date tim31. External SD Card problems (This Folder is NOT Writeable)
;; 2016-08-24 ttp://irreal.org/blog/?p=5457
(defun jcs-datetime (arg)
  "Without argument: insert date as yyyy-mm-dd
With C-u: insert time
With C-u C-u: insert date and time"
  (interactive "P")
  (cond ((equal arg '(4)) (insert (format-time-string "%T")))
        ((equal arg '(16)) (insert (format-time-string "%Y-%m-%d %T")))
        (t (insert (format-time-string "%d-%m-%Y")))))
(global-set-key (kbd "C-c d") 'jcs-datetime)
;;** Open iTerm
;;27-02-2017 https://sam217pa.github.io/2016/09/01/emacs-iterm-integration/
;;29-03-2017 moved to /elisp
(require 'open-iterm)
;;* Testing ground
;; hello
;;* Buffers
;;** buffer-menu mode
;; (global-set-key (kbd "C-x C-b") 'buffer-menu-other-window)
;;** ibuffer
;;*** 13 Mar 2014  http://mytechrants.wordpress.com/2010/03/25/emacs-tip-of-the-day-start-using-ibuffer-asap/
;; (use-package ibuffer
;;  ;; :defer 5
;;   )
;; ----------------------------------------------------------- [ ibuffer ]
;; 12 Mar 2014 http://www.elliotglaysher.org/emacs/
;; (require 'rush-ibuffer)
;;** recentf
;;  15 Mar 2014  recentf http://www.xsteve.at/prg/emacs/power-user-tips.html
(use-package recentf
  ;; :defer 2
  ;; :disabled t
 :config (recentf-mode 1)
 (setq recentf-max-saved-items 100)
 (setq recentf-max-menu-items 100)
 (setq recentf-exclude '("COMMIT_MSG" "COMMIT_EDITMSG" "github.*txt$"
                          ".*png$" ".*cache$"))
 (global-set-key [(meta f6)] 'recentf-open-files))
;;* Completions
;;** ido
;; 13 Mar 2014 http://emacs-fu.blogspot.com/2009/02/switching-buffers.html
;; ido makes competing buffers and finding files easier
;;; http://www.emacswiki.org/cgi-bin/wiki/InteractivelyDoThings
(use-package ido
  :defer 5
  :config  
  ;; (ido-mode 'both) ;; for buffers and files
  (setq
   ;;  ido-save-directory-list-file "~/.emacs.d/cache/ido.last"
   ;;  ido-ignore-buffers ;; ignore these guys
   ;;  '("\\` " "^\*Mess" "^\*Back" ".*Completion" "^\*Ido" "^\*trace"
   ;;     "^\*compilation" "^\*GTAGS" "^session\.*" "^\*")
   ;;  ido-work-directory-list '("~/" "~/Desktop" "~/Documents" "~src")
   ido-case-fold  t                 ; be case-insensitive
   ;;  ido-enable-last-directory-history t ; remember last used dirs
   ;;  ido-max-work-directory-list 30   ; should be enough
   ;;  ido-max-work-file-list      50   ; remember many
   ;;  ido-use-filename-at-point nil    ; don't use filename at point (annoying)
   ;;  ido-use-url-at-point nil         ; don't use url at point (annoying)
   ;;  ido-enable-flex-matching t     ;
   ido-max-prospects 8              ; don't spam my minibuffer
   ;;ido-everywhere t                 ; http://www.masteringemacs.org/articles/2010/10/10/introduction-to-ido-mode/ 3 Jul 2014
   ido-confirm-unique-completion t) ; wait for RET, even with unique completion
)
;; ;; 15 Mar 2014 http://www.xsteve.at/prg/emacs/power-user-tips.html
(defun xsteve-ido-choose-from-recentf ()
  "Use ido to select a recently opened file from the `recentf-list'"
  (interactive)
  (let ((home (expand-file-name (getenv "HOME"))))
    (find-file
     (ido-completing-read "Recentf open: "
			  (mapcar (lambda (path)
				    (replace-regexp-in-string home "~" path))
				  recentf-list)
			  nil t))))
;(global-set-key [(meta f5)] 'xsteve-ido-choose-from-recentf)
;; in keys.el
;; (global-set-key (kbd "<f5>") 'xsteve-ido-choose-from-recentf)
;; when using ido, the confirmation is rather annoying...
;; (setq confirm-nonexistent-file-or-buffer nil)
;;*** ido-ubiquitous
;;(require 'ido-ubiquitous)
;;(ido-ubiquitous-mode 1)
;;*** ido-hacks
;; (require 'ido-hacks)
;;*** smex
;; 13_07_2015 https://github.com/nonsequitur/smex
(global-set-key (kbd "M-x") 'counsel-M-x)
(global-set-key (kbd "M-X") 'smex-major-mode-commands)
;;*** flx-ido
;; 13_07_2015
;;(require 'flx-ido)
;;(ido-everywhere 1)
;;(flx-ido-mode 1)
;; disable ido faces to see flx highlights.
;; (setq ido-enable-flex-matching t)
;; (setq ido-use-faces nil)

;;*** ido-vertical
;; 13_07_2015
;;(require 'ido-vertical-mode)
(ido-vertical-mode 1)
; (setq ido-vertical-define-keys 'C-n-and-C-p-only)
;;** helm
;; 20_07_2015
;; (use-package helm)
;; (use-package helm-config)
;;(helm-mode 1)
;;(global-seT-key (kbd "M-x") 'helm-M-x)
;; (setq helm-M-x-fuzzy-match t) ;; optional fuzzy matching for helm-M-x
;;(global-set-key (kbd "M-x") 'helm-M-x)

;; helm was heard from here 23_07_2015 18:28:10
;; http://doc.rix.si/org/fsem.html#sec-3-3-1

;;** icomplete-mode
;; 20_04_2015 trying to solve Org-agenda bulk action tag assignment (does not offer completions)
;; http://pages.sachachua.com/.emacs.d/Sacha.html#unnumbered-187
;; (icomplete-mode 1)
;;** Autocomplete
;; 12_06_2015
(use-package auto-complete
  :disabled t
  :config
  (require 'auto-complete-config)
  (add-to-list 'ac-dictionary-directories "~/.emacs.d/ac-dict")
 ; (ac-config-default)
  (setq ac-sources '(ac-source-symbols ac-source-words-in-all-buffer))
  (global-auto-complete-mode t)
  (defun ac-text-mode ()
  (interactive)
  (setq ac-sources '(ac-source-symbols ac-source-words-in-all-buffer ac-source-words-in-same-mode-buffers)))
  (add-hook 'text-mode-hook 'ac-text-mode)
  )
;;** company
;;; 23_11_2015 http://www.lunaryorn.com/2015/01/06/my-emacs-configuration-with-use-package.html
(use-package company
 ;; :disabled t
 ;; :ensure t
  :defer 5
  :config
;  :diminish company-mode
  (global-company-mode)
  ;; 01_02_2016  Add yasnippet support for all company backends
  ;; https://github.com/syl20bnr/spacemacs/pull/179
  ;;(defvar company-mode/enable-yas t "Enable yasnippet for all backends.")
  ;;(defun company-mode/backend-with-yas (backend)
  ;;(if (or (not company-mode/enable-yas) (and (listp backend)    (member 'company-yasnippet backend)))
  ;;backend
  ;;(append (if (consp backend) backend (list backend))
  ;;      '(:with company-yasnippet))))
  ;;(setq company-backends (mapcar #'company-mode/backend-with-yas company-backends))
  ;; weight by frequency
; https://www.reddit.com/r/emacs/comments/3r9fic/best_practicestip_for_companymode_andor_yasnippet/
  (setq company-transformers '(company-sort-by-occurrence))
  )
;;09-03-2017
(use-package rush-company
 :defer 2
  )
;;*** company-quickhelp 
(use-package company-quickhelp
  :hook (company-mode . company-quickhelp-mode)
  :config
  (setq company-quickhelp-delay .1)
  (setq pos-tip-use-relative-coordinates t))
;;*** company org-mode completion
;;;https://github.com/company-mode/company-mode/issues/50
;;(defun add-pcomplete-to-capf ()
;;  (add-hook 'completion-at-point-functions 'pcomplete-completions-at-point nil t))
;;
;;(add-hook 'org-mode-hook #'add-pcomplete-to-capf)
;;;;;http://emacs.stackexchange.com/questions/3654/filename-completion-using-company-mode
;;(add-hook 'org-mode-hook
;;          (lambda ()
;;            (setq-local company-backends '((company-capf company-dabbrev company-dabbrev-code company-files :with company-yasnippet)))))
;;(setq company-dabbrev-code-ignore-case 'keep-prefix)

;; 01_02_2016
;;https://github.com/company-mode/company-mode/issues/50
;; (defun add-pcomplete-to-capf ()
;;   (add-hook 'completion-at-point-functions 'pcomplete-completions-at-point nil t))

;; (add-hook 'org-mode-hook #'add-pcomplete-to-capf)
;;*** company-statistics
;; 14_03_2016
(use-package company-statistics
  :config (company-statistics-mode)
  )
;;* Search
;; 20_07_2015
;;(require 'ace-isearch)
;;(global-ace-isearch-mode +1)
;;** avy
(use-package avy
 :defer 5)
(global-set-key (kbd "C-c j") 'avy-goto-word-or-subword-1)
(global-set-key (kbd "s-.") 'avy-goto-word-or-subword-1) ;; super

;;** ivy
;; 30-03-2017
(require 'rush-ivy)
(ivy-mode 1)
;;** swiper
;; (use-package swiper
;;     :defer 3
;;     :commands swiper
;;     :diminish
;;     :config
;;     (ivy-mode 1)
;;     (setq ivy-use-virtual-buffers t)
;; ;(require 'ora-ivy))
;;     )
;; (diminish 'ivy-mode) 
;; (require 'counsel)
;;** swiper fuzzy
;; 17_08_2015 https://github.com/abo-abo/swiper/commit/ebead12e8219cc1c0a9c9feb0e7e6ded992f9fd9
;; (setq ivy-re-builders-alist
      ;; '((t . ivy--regex-fuzzy)))
;; 19_08_2016 https://github.com/abo-abo/swiper/issues/628#issuecomment-240940941
(setq ivy-re-builders-alist
      '((read-file-name-internal . ivy--regex-fuzzy)
	(ivy-switch-buffer . ivy--regex-fuzzy)
        (counsel-M-x . ivy--regex-fuzzy)
        (t . ivy--regex-plus)))
;; ;;** swoop
;; ;; 29_07_2015
;; ;; https://github.com/ShingoFukuyama/emacs-swoop
;; ;;
;; ;(use-package swoop)
;; ;(define-key evil-motion-state-map (kbd "C-o") 'swoop-from-evil-search)
;; ;;** Multiple cursors
;; ;; 21_10_2015
;; (use-package multiple-cursors)
;; 19.08.16 http://oremacs.com/2015/04/16/ivy-mode/
(setq projectile-completion-system 'ivy)
;;** ace link
; (ace-link-setup-default)
;;** Ag
(require 'rush-ag)
;;* Undo Tree
;; this is experimenting for 'diminish package. 1 Jul 2014
;; 1 Jul 2014 experiment results: see diminish section in UI section
;;(use-package undo-tree
;;  :init
;;  (progn
;;    (global-undo-tree-mode)
;;(setq undo-tree-visualizer-timestamps t) ;; 1 Jul 2014
;;(setq undo-tree-visualizer-diff t)

;;* Version Control
;; 2 Jul 2014 http://stackoverflow.com/questions/5748814/how-does-one-disable-vc-git-in-emacs
;; disabling all VC in emacs; use magit. Will avoid symlink edit warnings.
;;(setq vc-handled-backends ())
;;(setq vc-follow-symlinks t)
;;** Git
;;*** Magit
;; 20_07_2015
(use-package magit
  :defer 20
  :config
  ;; 02_04_2015 after package update, an annoying message started popping up
  (setq magit-last-seen-setup-instructions "1.4.0")
  ;; 29-08-2016 http://oremacs.com/2015/04/16/ivy-mode/
  (setq magit-completing-read-function 'ivy-completing-read))
;;* Backup
;;** Backup org directory to git
;; 19_08_2015  http://doc.norang.ca/org-mode.html#GitSync
;;  A cron job runs at the top of the hour to commit any changes just saved by the call to org-save-all-org-buffers above. I use a script to create the commits so that I can run it on demand to easily commit all modified work when moving from one machine to another. crontab details: 0 * * * * ~/Dropbox/dotfiles/org-git-sync.sh >/dev/null

(eval-after-load 'org '(run-at-time "00:59" 3600 'org-save-all-org-buffers))
;;** Backup directory
;; 3 Jul 2014 http://pages.sachachua.com/.emacs.d/Sacha.html#sec-1-4-4
(setq backup-directory-alist '(("." . "~/.emacs.d/backups")))
;; 3 Jul 2014
;(setq delete-old-versions -1)
(setq delete-old-versions t;; 3 Jul 2014 http://stackoverflow.com/questions/151945/how-do-i-control-how-emacs-makes-backup-files
  kept-new-versions 6
  kept-old-versions 2
  version-control t)
;(setq version-control t)
;(setq vc-make-backup-files t)
(setq auto-save-file-name-transforms '((".*" "~/.emacs.d/auto-save-list/" t)))
;;** Backup function - sr http://www.emacswiki.org/emacs/BackupDirectory 18_Sep_14
;; don't know how to call this 18_Sep_14
;
;(defun make-backup-file-name (FILE)
;  (let ((dirname (concat "~/.backups/emacs/"
;                         (format-time-string "%y/%m/%d/"))))
;    (if (not (file-exists-p dirname))
;        (make-directory dirname t))
;    (concat dirname (file-name-nondirectory FILE))))
;;** Backup each save 18_Sep_14
;; from repo
(use-package backup-each-save
  ;; :defer 5
  )
(add-hook 'after-save-hook 'backup-each-save)

;;** Auto-revert (file changed on disk)
;;I used to use =org-revert-all-org-buffers= but have since discovered
;;=global-auto-revert-mode=.  With this setting any files that change on
;;disk where there are no changes in the buffer automatically revert to
;;the on-disk version.
;;
;;This is perfect for synchronizing my org-mode files between systems.
;; 20_08_2015
;;
;; (global-auto-revert-mode t)
;;* History
;; http://pages.sachachua.com/.emacs.d/Sacha.html#sec-1-4-4
;; (setq savehist-file "~/Dropbox/source/site-lisp/init/savehist")
;; (savehist-mode 1)
(setq history-length 200) ;; this variable is set to 100 by M-x set variable above
(setq history-delete-duplicates t)

(setq savehist-save-minibuffer-history 1)
;; (setq savehist-additional-variables
;;      '(kill-ring
;; 	search-ring
;; 	regexp-search-ring))

(put 'minibuffer-history 'history-length 50)
(put 'evil-ex-history 'history-length 50)
(put 'kill-ring 'history-length 25)


;;* Sentences end in single space
;; http://pages.sachachua.com/.emacs.d/Sacha.html#sec-1-4-4
(setq sentence-end-double-space nil)
;;* Lisp programming
;;** Eldoc
;; Eldoc provides minibuffer hints when working with Emacs Lisp.
(autoload 'eldoc-mode "eldoc" t)
;; (add-hook 'emacs-lisp-mode-hook 'eldoc-mode)
;; (add-hook 'lisp-interaction-mode-hook 'eldoc-mode)
;; (add-hook 'ielm-mode-hook 'eldoc-mode)

;;* Lua
(use-package rush-lua
  :defer 2
  ) 
;;* IRC
(use-package erc
  :defer 30)
;; joining && autojoing

;; make sure to use wildcards for e.g. freenode as the actual server
;; name can be be a bit different, which would screw up autoconnect
(erc-autojoin-mode t)
(setq erc-autojoin-channels-alist
  '((".*\\.freenode.net" "#emacs" "#gnu" "#gcc" "#modest" "#maemo")
     (".*\\.gimp.org" "#unix" "#gtk+")))

(defun djcb-erc-start-or-switch ()
  "Connect to ERC, or switch to last active buffer"
  (interactive)
  (if (get-buffer "irc.freenode.net:6667") ;; ERC already active?

    (erc-track-switch-buffer 1) ;; yes: switch to last active
    (when (y-or-n-p "Start ERC? ") ;; no: maybe start ERC
      (erc :server "irc.freenode.net" :port 6667 :nick "chac" :full-name "bar")
      (erc :server "irc.gimp.org" :port 6667 :nick "chac" :full-name "bar"))))
;;* Pomodoro
;;    (require 'pomodoro)
;;    (pomodoro-add-to-mode-line)
;;* BBDB
;; 8 Jul 2014 http://bbdb.sourceforge.net/bbdb.html#SEC4
;(require 'bbdb)
;(bbdb-initialize 'gnus 'message 'sc)
;; 16_06_2015
;; http://emacs-fu.blogspot.com/2009/08/managing-e-mail-addresses-with-bbdb.html
(setq bbdb-file "~/.emacs.d/bbdb")           ;; keep ~/ clean; set before loading
(use-package bbdb
  :defer 20)
(bbdb-initialize)
(setq
    bbdb-offer-save 1                        ;; 1 means save-without-asking

    bbdb-use-pop-up t                        ;; allow popups for addresses
    bbdb-electric-p t                        ;; be disposable with SPC
    bbdb-popup-target-lines  1               ;; very small

    bbdb-dwim-net-address-allow-redundancy t ;; always use full name
    bbdb-quiet-about-name-mismatches 2       ;; show name-mismatches 2 secs

    bbdb-always-add-address t                ;; add new addresses to existing... ;; ...contacts automatically
    bbdb-canonicaLize-redundant-nets-p t     ;; x@foo.bar.cx => x@bar.cx

    bbdb-completion-type nil                 ;; complete on anything
    bbdb-complete-name-allow-cycling t       ;; cycle through matches. this only works partially

    bbbd-message-caching-enabled t           ;; be fast
    bbdb-use-alternate-names t               ;; use AKA

    bbdb-elided-display t                    ;; single-line addresses

    ;; auto-create addresses from mail
    bbdb/mail-auto-create-p 'bbdb-ignore-some-messages-hook
    bbdb-ignore-some-messages-alist ;; don't ask about fake addresses
    ;; NOTE: there can be only one entry per header (such as To, From)
    ;; http://flex.ee.uec.ac.jp/texi/bbdb/bbdb_11.html

    '(( "From" . "no.?reply\\|DAEMON\\|daemon\\|facebookmail\\|twitter")))

;;* Lorem ipsum
;; 10 Jul 2014 https://github.com/maser/emacs.d/blob/master/lorem-ipsum.el
(autoload 'Lorem-ipsum-insert-paragraphs "lorem-ipsum" "" t)
(autoload 'Lorem-ipsum-insert-sentences "lorem-ipsum" "" t)
(autoload 'Lorem-ipsum-insert-list "lorem-ipsum" "" t)
;; testing undo
;;* Local variables
;;Local Variables:
;;eval: (orgstruct-mode 1)
;;orgstruct-heading-prefix-regexp: ";; "
;;End:
;;* Debugging
;; (setq debug-on-error t)
;;* Email
;;** Wanderlust
;; (autoload 'wl "wl" "Wanderlust" t)
;;** Gmail-itsalltext
;(use-package gmail-message-mode)
;;** Edit-sever (google chrome webmail edit)
(use-package edit-server
:defer 5
:config
(edit-server-start)
)
;(when (and (require 'edit-server nil t) (daemonp))
;(edit-server-start))


;; (when (locate-library "edit-server")
;;   (require 'edit-server)
;;   (setq edit-server-new-frame t)
;; (edit-server-start))

;;** Gmail dehtmlize
; 21_Nov_14 http://www.emacswiki.org/emacs/Edit_with_Emacs
;(require 'edit-server-htmlize)
;(autoload 'edit-server-maybe-dehtmlize-buffer "edit-server-htmlize" "edit-server-htmlize" t)
;(autoload 'edit-server-maybe-htmlize-buffer   "edit-server-htmlize" "edit-server-htmlize" t)
;(add-hook 'edit-server-start-hook 'edit-server-maybe-dehtmlize-buffer)
;(add-hook 'edit-server-done-hook  'edit-server-maybe-htmlize-buffer)
;;** mu4e
;(add-to-list 'load-path (expand-file-name "git/org-mode/lisp/" emacs-d))
;;(add-to-list 'load-path "/usr/local/Cellar/mu/HEAD/share/emacs/site-lisp/mu") 
;;(require 'mu4e)
;;(require 'mu4e-maildirs-extension)
;;(mu4e-maildirs-extension)
;;(setq mu4e-get-mail-command "offlineimap")
;;(setq mu4e-maildir "~/.mail/gmail")
;;(setq
;;; mu4e-drafts-folder "/drafts"
;;      mu4e-sent-folder   "/sent"
;;      mu4e-trash-folder  "/trash")
;;
;;(setq mu4e-view-show-images t)
;;(setq mu4e-html2text-command "w3m -dump -T text/html")
;;(setq mu4e-view-prefer-html t)
;;(setq mu4e-use-fancy-chars t)
;;(setq mu4e-headers-skip-duplicates t)
;;;(setq mu4e-get-mail-command "offlineimap -q")
;;(setq mu4e-update-interval 300)
;;;(setq mu4e-update-interval 30)
;;;(setq mu4e-attachment-dir  "~/downloads")
;;;(setq mu4e-sent-messages-behavior 'delete)
;;(setq message-kill-buffer-on-exit t)
;;(setq mu4e-hide-index-messages t)
;;(add-hook 'mu4e-compose-mode-hook 'flyspell-mode)
;;(setq
;; mu4e-compose-signature
;; (concat
;;  "Kind Regards,\n"
;;  "\n"))
;;*** mu4e-alert
;; 09_02_2016 https://github.com/iqbalansari/mu4e-alert
;; Choose the style you prefer for desktop notifications
;; If you are on Linux you can use
;; 1. notifications - Emacs lisp implementation of the Desktop Notifications API
;; 2. libnotify     - Notifications using the `notify-send' program, requires `notify-send' to be in PATH
;;
;; On Mac OSX you can set style to
;; 1. notifier      - Notifications using the `terminal-notifier' program, requires `terminal-notifier' to be in PATH
;; 1. growl         - Notifications using the `growl' program, requires `growlnotify' to be in PATH
;; (mu4e-alert-set-default-style 'growl)
;; (add-hook 'after-init-hook #'mu4e-alert-enable-notifications)
;(add-hook 'after-init-hook #'mu4e-alert-enable-mode-line-display)
;; (mu4e-alert-enable-notifications)
;;* Evernote
;; (require 'epic)
;;** Evenote-mode
;(add-to-list 'exec-path "/System/Library/Frameworks/Ruby.framework/Versions/1.8/usr/bin")
;(setenv "PATH" (concat "/System/Library/Frameworks/Ruby.framework/Versions/1.8/usr/bin:" (getenv "PATH")))
;(add-to-list 'exec-path "/opt/local/bin")
;(setenv "PATH" (concat "/System/Library/Frameworks/Ruby.framework/Versions/1.8/usr/bin:" (getenv "PATH")))
;(setq evernote-ruby-command "/opt/local/bin/ruby")
;(require 'evernote-mode)
;(setq evernote-enml-formatter-command '("w3m" "-dump" "-I" "UTF8" "-O" "UTF8")) ; option
;(global-set-key "\C-cec" 'evernote-create-note)
;(global-set-key "\C-ceo" 'evernote-open-note)
;(global-set-key "\C-ces" 'evernote-search-notes)
;(global-set-key "\C-ceS" 'evernote-do-saved-search)
;(global-set-key "\C-cew" 'evernote-write-note)
;(global-set-key "\C-cep" 'evernote-post-region)
;(global-set-key "\C-ceb" 'evernote-browser)
;;** Orglue (evernote links)
(use-package orglue
  :defer 20)
;;* Latex
;(latex-preview-pane-enable)
;(setenv "PATH" (concat (getenv "PATH") ":/usr/texbin"))
;(setq exec-path (append exec-path '("/usr/texbin")))
;;* Bookmarks
(use-package bookmark
  :defer 2)
;;** Bookmarks+
;; (use-package bookmark+
;;  :defer 2)
;(put 'narrow-to-region 'disabled nil)
;;** crosshairs
;; 14_05_2015
(use-package crosshairs
    :defer 2)
;;** bm
(use-package bm
  :defer 10)
;;** mark-tools
;;(require 'mark-tools)
;;** evil-visual-mark-mode
(use-package evil-visual-mark-mode
  :defer 10)
;;* Info
;; 16_06_2015
;; http://balking3.rssing.com/chan-2523185/all_p233.html#item4650
;(add-hook 'Info-mode-hook		; After Info-mode has started
;        (lambda ()
;    	    (setq Info-additional-directory-list Info-default-directory-list)
;    	))
(use-package info)
(info-initialize)
(push "~/info/" Info-directory-list)

;;* Simple-note
(use-package simplenote2
  :disabled t
  :config
  (simplenote2-setup))

;(require 'simplenote)
;(simplenote-setup)
;;* Epub
(use-package nov 
 ;; :defer 5 
 :config
;; (add-to-list 'auto-mode-alist '("\\.epub\\'" . nov-mode))
(push '("\\.epub\\'" . nov-mode) auto-mode-alist)
)
;;* Emacs daemon
(use-package server
 :defer 5 
 :config
(unless (server-running-p)
  (server-start))
)
;;* Environment
;; 16_07_2015 https://github.com/timothypratley/config/blob/master/emacs.d/lisp/packages.el
(exec-path-from-shell-initialize)
;;(setq insert-directory-program "gls")
;;* Start in full screen
;; 14 Jul 2014 http://www.emacswiki.org/emacs/FullScreen#toc13
(set-frame-parameter nil 'fullscreen 'fullboth) ;; this starts in full screen

;; 14 Jul 2014
; (require 'maxframe)
; (add-hook 'window-setup-hook 'maximize-frame t)
;;** Start in fullscreen 2
;;** 16_05_2015
(setq ns-use-native-fullscreen nil)
; ** 17_05_2015 00:54
; http://www.emacswiki.org/emacs/FullScreen
(defun toggle-fullscreen ()
  "Toggle full screen"
  (interactive)
  (set-frame-parameter
     nil 'fullscreen
     (when (not (frame-parameter nil 'fullscreen)) 'fullboth)))
;;* Spelling and translation
;;** Spelling environment
;; http://stackoverflow.com/questions/17002686/emacs-ispell-error-when-accepting-words-for-local-file-dictionary 28_07_2015
;;(setenv "DICPATH" (concat exec-directory "../hunspell/dict"))
;;** hunspell
;;;;;;;;;;;;;;;;;;;;;
;; ;; use hunspell ;;
;;;;;;;;;;;;;;;;;;;;;
;; (setq-default ispell-program-name "hunspell")
;; (setq ispell-really-hunspell t)
;; ;; tell ispell that apostrophes are part of words
;; ;; and select Bristish dictionary
;; (setq ispell-local-dictionary-alist
;;       `((nil "[[:alpha:]]" "[^[:alpha:]]" "[']" t ("-d" "en_GB") nil utf-8)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;; find aspell and hunspell automatically ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;(cond
;; ((executable-find "aspell")
;;  (setq ispell-program-name "aspell")
;;  (setq ispell-extra-args '("--sug-mode=ultra" "--lang=en_US")))
;; ((executable-find "hunspell")
;;  (setq ispell-program-name "hunspell")
;;  (setq ispell-extra-args '("-d en_US")))
;; )

;;** http://blog.binchen.org/posts/what-s-the-best-spell-check-set-up-in-emacs.html 28_07_2015
;; if (aspell installed) { use aspell}
;; else if (hunspell installed) { use hunspell }
;; whatever spell checker I use, I always use English dictionary
;; I prefer use aspell because:
;; 1. aspell is older
;; 2. looks Kevin Atkinson still get some road map for aspell:
;; @see http://lists.gnu.org/archive/html/aspell-announce/2011-09/msg00000.html
;(defun flyspell-detect-ispell-args (&optional RUN-TOGETHER)
;  "if RUN-TOGETHER is true, spell check the CamelCase words"
;  (let (args)
;    (cond
;     ((string-match  "aspell$" ispell-program-name)
;      ;; force the English dictionary, support Camel Case spelling check (tested with aspell 0.6)
;      (setq args (list "--sug-mode=ultra" "--lang=en_US"))
;      (if RUN-TOGETHER
;          (setq args (append args '("--run-together" "--run-together-limit=5" "--run-together-min=2")))))
;     ((string-match "hunspell$" ispell-program-name)
;      (setq args nil)))
;    args
;    ))
;
;(cond
; ((executable-find "aspell")
;  (setq ispell-program-name "aspell"))
; ((executable-find "hunspell")
;  (setq ispell-program-name "hunspell")
;  ;; just reset dictionary to the safe one "en_US" for hunspell.
;  ;; if we need use different dictionary, we specify it in command line arguments
;  (setq ispell-local-dictionary "en_US")
;  (setq ispell-local-dictionary-alist
;        '(("en_US" "[[:alpha:]]" "[^[:alpha:]]" "[']" nil nil nil utf-8))))
; (t (setq ispell-program-name nil)))
;
;;; ispell-cmd-args is useless, it's the list of *extra* arguments we will append to the ispell process when "ispell-word" is called.
;;; ispell-extra-args is the command arguments which will *always* be used when start ispell process
;(setq ispell-extra-args (flyspell-detect-ispell-args t))
;;; (setq ispell-cmd-args (flyspell-detect-ispell-args))
;(defadvice ispell-word (around my-ispell-word activate)
;  (let ((old-ispell-extra-args ispell-extra-args))
;    (ispell-kill-ispell t)
;    (setq ispell-extra-args (flyspell-detect-ispell-args))
;    ad-do-it
;    (setq ispell-extra-args old-ispell-extra-args)
;    (ispell-kill-ispell t)
;    ))
;
;(defadvice flyspell-auto-correct-word (around my-flyspell-auto-correct-word activate)
;  (let ((old-ispell-extra-args ispell-extra-args))
;    (ispell-kill-ispell t)
;    ;; use emacs original arguments
;    (setq ispell-extra-args (flyspell-detect-ispell-args))
;    ad-do-it
;    ;; restore our own ispell arguments
;    (setq ispell-extra-args old-ispell-extra-args)
;    (ispell-kill-ispell t)
;    ))



;;** http://www.linux.org.ru/forum/development/4457441
;(custom-set-variables
;  '(ispell-local-dictionary-alist (quote (("russian" "[АБВГДЕЖЗИЙКЛМНОПРСТУФХЧШЩЪЬЮЯабвгдежзийклмнопрстуфхцшщюя]" "[^АБВГДЕЖЗИЙКЛМНОПРСТУФХЧШЩЪЬЮЯабвгдежзийклмнопрстуфхцшщюя]" "" nil ("-d" "ru_RU") nil iso-8859-5)))))
;
; '(ispell-extra-args (quote ("" "-a")))
; '(ispell-have-new-look t)
; '(ispell-local-dictionary "russian")
; '(ispell-local-dictionary-alist (quote (("russian" "[\320\220\320\221\320\222\320\223\320\224\320\225\320\201\320\226\320\227\320\230\320\231\320\232\320\233\320\234\320\235\320\236\320\237\320\240\320\241\320\242\320\243\320\244\320\245\320\247\320\250\320\251\320\252\320\253\320\254\320\255\320\256\320\257\320\260\320\261\320\262\320\263\320\264\320\265\321\221\320\266\320\267\320\270\320\271\320\272\320\273\320\274\320\275\320\276\320\277\321\200\321\201\321\202\321\203\321\204\321\205\321\206\321\210\321\211\321\212\321\213\321\214\321\215\321\216\321\217]" "[^\320\220\320\221\320\222\320\223\320\224\320\225\320\201\320\226\320\227\320\230\320\231\320\232\320\233\320\234\320\235\320\236\320\237\320\240\320\241\320\242\320\243\320\244\320\245\320\247\320\250\320\251\320\252\320\253\320\254\320\255\320\256\320\257\320\260\320\261\320\262\320\263\320\264\320\265\321\221\320\266\320\267\320\270\320\271\320\272\320\273\320\274\320\275\320\276\320\277\321\200\321\201\321\202\321\203\321\204\321\205\321\206\321\210\321\211\321\212\321\213\321\214\321\215\321\216\321\217]" "" nil ("-d" "ru") nil koi8-r))))
; '(ispell-message-dictionary-alist (quote (("" . ""))))
; '(ispell-program-name "aspell")


;;** http://filonenko-mikhail.blogspot.com/2012/03/emacs.html 12_08_2015
(use-package flyspell)
(use-package ispell)

(setq
 ispell-program-name "aspell"
; ispell-program-name "hunspell"
 ispell-extra-args '("--sug-mode=ultra"))

(setq ispell-highlight-face (quote flyspell-incorrect))
(setq ispell-have-new-look t)
(setq ispell-enable-tex-parser t)
;(add-hook 'text-mode-hook 'flyspell-mode)
;(add-hook 'latex-mode-hook 'flyspell-mode)
(setq flyspell-delay 1)
;(setq flyspell-always-use-popup t)

(setq flyspell-issue-welcome-flag nil)

;;** Flyspel with Aspell
(setq ispell-list-command "--list")

;;** Popup instead of gui
;; http://www.emacswiki.org/emacs/FlySpell 29_07_2015
(defun flyspell-emacs-popup-textual (event poss word)
      "A textual flyspell popup menu."
      (require 'popup)
      (let* ((corrects (if flyspell-sort-corrections
                           (sort (car (cdr (cdr poss))) 'string<)
                         (car (cdr (cdr poss)))))
             (cor-menu (if (consp corrects)
                           (mapcar (lambda (correct)
                                     (list correct correct))
                                   corrects)
                         '()))
             (affix (car (cdr (cdr (cdr poss)))))
             show-affix-info
             (base-menu  (let ((save (if (and (consp affix) show-affix-info)
                                         (list
                                          (list (concat "Save affix: " (car affix))
                                                'save)
                                          '("Accept (session)" session)
                                          '("Accept (buffer)" buffer))
                                       '(("Save word" save)
                                         ("Accept (session)" session)
                                         ("Accept (buffer)" buffer)))))
                           (if (consp cor-menu)
                               (append cor-menu (cons "" save))
                             save)))
             (menu (mapcar
                    (lambda (arg) (if (consp arg) (car arg) arg))
                    base-menu)))
        (cadr (assoc (popup-menu* menu :scroll-bar t) base-menu))))

(eval-after-load "flyspell" '(progn (fset 'flyspell-emacs-popup 'flyspell-emacs-popup-textual)))
;;** enchant
;; http://reangdblog.blogspot.com/2015/06/emacs.html 13_08_2015
(defvar lcl-var:spelling-ignore nil)

(defun lcl:spelling-add-to-dictionary (marked-text)
  (let* ((word (downcase (aref marked-text 0)))
         (dict (if (string-match "[a-zA-Z]" word)
                   (message "en_US.dic")
                 (message "ru_RU.dic")))
         (file (concat "~/.config/enchant/" dict)))
    (when (and file (file-writable-p file))
      (with-temp-buffer
        (insert word) (newline)
        (append-to-file (point-min) (point-max) file)
        (message "Added word \"%s\" to the \"%s\" dictionary" word dict))
      (wcheck-mode 0)
      (wcheck-mode 1))))

(defun lcl:spelling-add-to-ignore (marked-text)
  (let ((word (aref marked-text 0)))
    (add-to-list 'lcl-var:spelling-ignore word)
    (message "Added word \"%s\" to the ignore list" word)
    (wcheck--hook-outline-view-change)))

(defun lcl:spelling-action-menu (marked-text)
  (append (wcheck-parser-ispell-suggestions)
          (list (cons "[Add to dictionary]" 'lcl:spelling-add-to-dictionary)
                (cons "[Ignore]" 'lcl:spelling-add-to-ignore))))

(defun lcl:delete-list (delete-list list)
  (dolist (el delete-list)
    (setq list (remove el list)))
  list)

(defun lcl:spelling-parser-lines (&rest ignored)
  (lcl:delete-list lcl-var:spelling-ignore
                   (delete-dups
                    (split-string
                     (buffer-substring-no-properties (point-min) (point-max))
                     "\n+" t))))

(defun cfg:spelling ()
  (require 'wcheck-mode)
  (defun wcheck--choose-action-minibuffer (actions)
    (cdr
     (assoc
      ;; (ido-completing-read "Choose " (mapcar #'car actions))
      (ivy-read "spelling:" actions) ;; 26-08-2016 first ivy use 
      actions)))
  (setq-default
   wcheck-language "All"
   wcheck-language-data
   '(("All"
      (program . "~/.config/emacs/bin/spell_check_text.sh")
      (parser . lcl:spelling-parser-lines)
      (action-program . "~/.config/emacs/bin/spell_check_word.sh")
      (action-parser . lcl:spelling-action-menu)
      (read-or-skip-faces
       ((emacs-lisp-mode c-mode c++-mode python-mode)
        read font-lock-comment-face)
       (org-mode
        skip org-block-begin-line org-block-end-line org-meta-line org-link)
       (nil))
      ))))
(cfg:spelling)

;;** ispell org-mode
;; 25_08_2015 Making Ispell work with org-mode in Emacs
;; http://endlessparentheses.com/ispell-and-org-mode.html?source%3Drss
(defun endless/org-ispell ()
  "Configure `ispell-skip-region-alist' for `org-mode'."
  (make-local-variable 'ispell-skip-region-alist)
  (add-to-list 'ispell-skip-region-alist '(org-property-drawer-re))
  (add-to-list 'ispell-skip-region-alist '("~" "~"))
  (add-to-list 'ispell-skip-region-alist '("=" "="))
  (add-to-list 'ispell-skip-region-alist '("^#\\+BEGIN_SRC" . "^#\\+END_SRC")))
(add-hook 'org-mode-hook #'endless/org-ispell)
;;** Translation
;;*** Google translate
;; 24-08-2016
;; https://github.com/atykhonov/google-translate
;; (require 'google-translate)
;; (require 'google-translate-default-ui)
;; (require 'google-translate-smooth-ui)
;;* Dired
;;** DiredX
;; moved to rush-dired.el
;; (use-package dired-x
  ;; :defer 3)
;;** Dired misc
;; (setq dired-listing-switches "-aBhl  --group-directories-first")
(use-package openwith
  :defer 10
  :config
  (setq openwith-associations '(("\\.pdf\\'" "open" (file))))
  (setq openwith-associations '(("\\.html\\'" "open" (file))))
  )
;;** Dired keybindings
;; http://oremacs.com/2015/01/21/dired-shortcuts/
;; (define-key dired-mode-map "j" 'dired-next-line)
;; (define-key dired-mode-map "k" 'dired-previous-line)
;;** Dired garbage hide
;; moved to rush-dired.el 03-04-2017
;; http://oremacs.com/2015/01/21/dired-shortcuts/
;; (setq dired-garbage-files-regexp "\\.idx\\|\\.run\\.xml$\\|\\.bbl$\\|\\.bcf$\\|.blg$\\|-blx.bib$\\|.nav$\\|.snm$\\|.out$\\|.synctex.gz$\\|\\(?:\\.\\(?:aux\\|bak\\|dvi\\|log\\|orig\\|rej\\|toc\\|pyg\\)\\)\\'") 
;;** Ignore unimportant files
;; (setq-default dired-omit-files-p nil) ; Buffer-local variable
;; (define-key dired-mode-map (kbd "M-o") 'dired-omit-mode)

;; this line below messes with ranger dotfiles show/hide 
;; (setq dired-omit-files (concat dired-omit-files "\\|^\\..+$"))

;; (setq dired-omit-files "\\(?:.*\\.\\(?:aux\\|log\\|synctex\\.gz\\|run\\.xml\\|bcf\\|am\\|in\\)\\'\\)\\|^\\.\\|-blx\\.bib")
;;** Move to the parent directory
;; (define-key dired-mode-map "a"
;;     (lambda ()
;;       (interactive)
      ;; (find-alternate-file "..")))
;;** Emacs' adaptation of find
;; (define-key dired-mode-map "F" 'find-name-dired)

;;** swiper-mc
;; this is already a part of swiper
;; http://oremacs.com/2015/10/14/swiper-mc/ see Disqus jemin comment
;; (defun swiper-mc ()
;;   (interactive)
;;   (unless (require 'multiple-cursors nil t)
;;     (error "multiple-cursors isn't installed"))
;;   (let ((cands (nreverse ivy--old-cands)))
;;     (unless (string= ivy-text "")
;;       (ivy-set-action
;;        (lambda (_)
;;          (let (cand)
;;            (while (setq cand (pop cands))
;;              (swiper--action cand)
;;              (when cands
;;                (mc/create-fake-cursor-at-point))))
;;          (mc/maybe-multiple-cursors-mode)))
;;       (setq ivy-exit 'done)
;;       (exit-minibuffer))))

;;** Open files by system app
;; http://ergoemacs.org/emacs/emacs_dired_open_file_in_ext_apps.html 30_07_2015
(defun xah-open-in-external-app ()
  "Open the current file or dired marked files in external app.
The app is chosen from your OS's preference.

URL `http://ergoemacs.org/emacs/emacs_dired_open_file_in_ext_apps.html'
Version 2015-01-26"
  (interactive)
  (let* (
         (ξfile-list
          (if (string-equal major-mode "dired-mode")
              (dired-get-marked-files)
            (list (buffer-file-name))))
         (ξdo-it-p (if (<= (length ξfile-list) 5)
                       t
                     (y-or-n-p "Open more than 5 files? "))))

    (when ξdo-it-p
      (cond
       ((string-equal system-type "windows-nt")
        (mapc
         (lambda (fPath)
           (w32-shell-execute "open" (replace-regexp-in-string "/" "\\" fPath t t))) ξfile-list))
       ((string-equal system-type "darwin")
        (mapc
         (lambda (fPath) (shell-command (format "open \"%s\"" fPath)))  ξfile-list))
       ((string-equal system-type "gnu/linux")
        (mapc
         (lambda (fPath) (let ((process-connection-type nil)) (start-process "" nil "xdg-open" fPath))) ξfile-list))))))
;;** Open in Finder
;; http://ergoemacs.org/emacs/emacs_dired_open_file_in_ext_apps.html 30_07_2015
(defun xah-open-in-desktop ()
  "Show current file in desktop (OS's file manager).
URL `http://ergoemacs.org/emacs/emacs_dired_open_file_in_ext_apps.html'
Version 2015-06-12"
  (interactive)
  (cond
   ((string-equal system-type "windows-nt")
    (w32-shell-execute "explore" (replace-regexp-in-string "/" "\\" default-directory t t)))
   ((string-equal system-type "darwin") (shell-command "open ."))
   ((string-equal system-type "gnu/linux")
    (let ((process-connection-type nil)) (start-process "" nil "xdg-open" "."))
    ;; (shell-command "xdg-open .") ;; 2013-02-10 this sometimes froze emacs till the folder is closed. ⁖ with nautilus
    )))

;; 11_01_2016
;; http://jblevins.org/log/dired-open
;; Open files in dired mode using 'open'
(eval-after-load "dired"
  '(progn
     (define-key dired-mode-map (kbd "z")
       (lambda () (interactive)
         (let ((fn (dired-get-file-for-visit)))
           (start-process "default-app" nil "open" fn))))))


;;** dired-rainbow
;; 11_01_2016 https://github.com/Fuco1/dired-hacks

(use-package dired-rainbow)
(defconst my-dired-media-files-extensions
  '("mp3" "mp4" "MP3" "MP4" "avi" "mpg" "flv" "ogg")
  "Media files.")

(dired-rainbow-define html "#4e9a06" ("htm" "html" "xhtml"))
(dired-rainbow-define media "#ce5c00" my-dired-media-files-extensions)

; boring regexp due to lack of imagination
(dired-rainbow-define log (:inherit default
			    :italic t
			    :bold t) ".*\\.log")

; highlight executable files, but not directories
(dired-rainbow-define-chmod executable-unix "Green" "-.*x.*")
;;** dired-avfs
(use-package dired-avfs)

;;** recent directories
;;*** 25-08-2016 http://pragmaticemacs.com/emacs/open-a-recent-directory-in-dired-revisited/
(defun bjm/ivy-dired-recent-dirs ()
  "Present a list of recently used directories and open the selected one in dired"
  (interactive)
  (let ((recent-dirs
         (delete-dups
          (mapcar (lambda (file)
                    (if (file-directory-p file) file (file-name-directory file)))
                  recentf-list))))

    (let ((dir (ivy-read "Directory: "
                         recent-dirs
                         :re-builder #'ivy--regex
                         :sort nil
                         :initial-input nil)))
      (dired dir))))


;;*** 25-08-2016 http://blog.binchen.org/posts/use-ivy-to-open-recent-directories.html
(defun counsel-goto-recent-directory ()
  "Open recent directory with dired"
  (interactive)
  (unless recentf-mode (recentf-mode 1))
  (let ((collection
         (delete-dups
          (append (mapcar 'file-name-directory recentf-list)
                  ;; fasd history
                  (if (executable-find "fasd")
                      (split-string (shell-command-to-string "fasd -ld") "\n" t))))))
    (ivy-read "directories:" collection :action 'dired)))

(global-set-key (kbd "C-x C-d") 'counsel-goto-recent-directory)
;;** dired ls switches
(setq dired-listing-switches "-laGh1v --group-directories-first")

;;** ranger
;;28-02-2017 https://sam217pa.github.io/2016/08/30/how-to-make-your-own-spacemacs/
(use-package ranger
  :ensure t
  ;; :commands (ranger)
  :bind (("C-x d" . deer))
  :config
  (setq ranger-cleanup-eagerly t)
  (setq ranger-show-hidden t)
  ;; :bind (:map ranger-mode-map 
        ;; (("C-h" . nil))) ;; list of cons with key/command  to bind in the key map
  (with-eval-after-load "ranger" (bind-key "C-h" nil ranger-mode-map))
  ;; (setq ranger-hidden-regexp "^\\.?#\\|^\\.$\\|^\\.\\.$")
)
  ;;* Syntax checking
(use-package flycheck
  :defer 20
  :config (flycheck-define-checker sql-sqlint
  "A SQL syntax checker using the sqlint tool.
   See URL `https://github.com/purcell/sqlint'."
  :command ("sqlint" source)
  :error-patterns
  ((warning line-start (file-name) ":" line ":" column ":WARNING "
            (message (one-or-more not-newline)
                     (zero-or-more "\n"
                                   (one-or-more "  ")
                                   (one-or-more not-newline)))
            line-end)
   (error line-start (file-name) ":" line ":" column ":ERROR "
          (message (one-or-more not-newline)
                   (zero-or-more "\n"
                                 (one-or-more "  ")
                                 (one-or-more not-newline)))
          line-end))

  :modes (sql-mode)))
;; (add-hook 'after-init-hook #'global-flycheck-mode)

;; this was added after research of flycheck sqlint
;; https://raw.githubusercontent.com/flycheck/flycheck/master/flycheck.el ;; 14_08_2015 ;;
;; for some reason this code is not present in the loaded from elpa version
;; it allows to have sqlint check sql syntax on the fly
;;* Text expansion, snippet
;; 12_10_2015
;(add-to-list 'load-path
;              "~/.emacs.d/plugins/yasnippet")
;;(require 'yasnippet)
;;(yas-global-mode 1)
;; 24_11_2015 oremacs 
(use-package tiny
    :defer 10
    :commands tiny-expand
    :ensure t)
(use-package yasnippet
    :defer 10
    ;; :diminish yas-minor-mode
    :config
    (progn
      (setq yas-fallback-behavior 'return-nil)
      (setq yas-triggers-in-field t)
      (setq yas-verbosity 0)
      ;; (setq yas-snippet-dirs (list (concat emacs-d "snippets/")))
      (setq yas-snippet-dirs (list (concat emacs-d "snippets/") yas-installed-snippets-dir))
      ;; (define-key yas-minor-mode-map [(tab)] nil)
      ;; (define-key yas-minor-mode-map (kbd "TAB") nil)
      (yas-global-mode)))

; 02_02_2016
;key binding for yasnippet
;I highly recommend to bind yas/expand to C-o, so it
;doesn't conflict with auto-complete-mode. The default binding for this shortcut
;is near-useless, but it's in a great position:

;(global-set-key "\C-o" 'aya-open-line)
;
;(defun aya-open-line ()
;  (interactive)
;  (cond ((expand-abbrev))
;
;        ((yas/snippets-at-point)
;         (yas/next-field-or-maybe-expand-1))
;
;        (((yas/expand)))))
;This way, the shortcut for expanding
;and moving to the next field is the same, which makes you very
;quick. Also note that expand-abbrev takes precedence: you can
;fill an abbrev table for c++-mode for the stuff that you use.
;Abbrevs don't take an argument, but they all live in one table,
;instead of each yasnippet living in its own file, so it's very
;easy to edit abbrevs.

;;* PDF
(use-package org-pdfview
  :defer 30
;  :config (
;	   (add-to-list 'org-file-apps '("\\.pdf\\'" . org-pdfview-open))
;	   (add-to-list 'org-file-apps '("\\.pdf::\\([[:digit:]]+\\)\\'" . org-pdfview-open))
;	   )
)
(use-package pdf-tools
  :disabled
  :defer 19
  :config (pdf-tools-install)
)

;;** 13_11_2015  http://matt.hackinghistory.ca/2015/11/11/note-taking-with-pdf-tools/
;; modified from https://github.com/politza/pdf-tools/pull/133

;;;(defun mwp/pdf-multi-extract (sources)
;;;  "Helper function to print highlighted text from a list of pdf's, with one org header per pdf,
;;;and links back to page of highlight."
;;;  (let (
;;;        (output ""))
;;;    (dolist (thispdf sources)
;;;      (setq output (concat output (pdf-annot-markups-as-org-text thispdf nil level ))))
;;;    (princ output))
;;;  )
;;;
;;;(defun pdf-annot-markups-as-org-text (pdfpath &optional title level)
;;;  "Acquire highlight annotations as text, and return as org heading"
;;;
;;;  (interactive "fPath to PDF: ")
;;;  (let* ((outputstring "") ;; the text to be return
;;;         (title (or title (replace-regexp-in-string "-" " " (file-name-base pdfpath ))))
;;;         (level (or level (1+ (org-current-level)))) ;; I guess if we're not in an org-buffer this will fail
;;;         (levelstring (make-string level ?*))
;;;        )
;;;    (with-temp-buffer ;; use temp buffer to avoid opening zillions of pdf buffers
;;;      (insert-file-contents pdfpath)
;;;      (pdf-view-mode)
;;;      (pdf-annot-minor-mode t)
;;;      (let* ((annots (sort (pdf-annot-getannots nil (list 'highlight)  nil) ;; only get highlights
;;;                           'pdf-annot-compare-annotations)))
;;;        (setq outputstring (concat levelstring " Quotes From " title "\n\n")) ;; create heading
;;;
;;;        ;; extract text
;;;        (mapc
;;;         (lambda (annot) ;; traverse all annotations
;;;           (message "%s" annot)
;;;           (let* ((page (assoc-default 'page annot))
;;;                  (text (assoc-default 'subject annot))
;;;                  (height (nth 1 (assoc-default 'edges annot)))
;;;                  ;; use pdfview link directly to page number
;;;                 (linktext (concat "[[pdfview:" pdfpath "::" (number-to-string page)
;;;                                   "++" (number-to-string height) "][" title  "]]" ))
;;;                 )
;;;             (setq outputstring (concat outputstring text " ("
;;;                                        linktext ", " (number-to-string page) ")\n\n"))
;;;             ))
;;;         annots)
;;;        ))
;;;    outputstring ;; return the header
;;;    )) 13_11_2015 second version
(eval-after-load 'org  '(org-add-link-type "pdfquote" 'org-pdfquote-open 'org-pdfquote-export))
;; (org-add-link-type "pdfquote" 'org-pdfquote-open 'org-pdfquote-export)

(defun org-pdfquote-open (link)
  "Open a new buffer with all markup annotations in an org headline."
  (interactive)
  (pop-to-buffer
   (format "*Quotes from %s*"
           (file-name-base link)))
  (org-mode)
  (erase-buffer)
  (insert (pdf-annot-markups-as-org-text link nil 1))
  (goto-char 0)
  )

(defun org-pdfquote-export (link description format)
  "Export the pdfview LINK with DESCRIPTION for FORMAT from Org files."
  (let* ((path (when (string-match "\\(.+\\)::.+" link)
                 (match-string 1 link)))
         (desc (or description link)))
    (when (stringp path)
      (setq path (org-link-escape (expand-file-name path)))
      (cond
       ((eq format 'html) (format "<a href=\"%s\">%s</a>" path desc))
       ((eq format 'latex) (format "\href{%s}{%s}" path desc))
       ((eq format 'ascii) (format "%s (%s)" desc path))
       (t path)))))

(defun org-pdfquote-complete-link ()
  "Use the existing file name completion for file.
Links to get the file name, then ask the user for the page number
and append it."

  (replace-regexp-in-string "^file:" "pdfquote:" (org-file-complete-link)))
;;** PdfView org-link
;(use-package org-pdfview
;;  :diminish org-pdfview-mode
;  )

;;* Find file in project
(autoload 'find-file-in-project "find-file-in-project" nil t)
(autoload 'find-file-in-project-by-selected "find-file-in-project" nil t)
(autoload 'find-directory-in-project-by-selected "find-file-in-project" nil t)
(autoload 'ffip-show-diff "find-file-in-project" nil t)
(autoload 'ffip-save-ivy-last "find-file-in-project" nil t)
(autoload 'ffip-ivy-resume "find-file-in-project" nil t)
;;* Encryption
;; 03_12_2015
(use-package epa-file
  :defer 10
  ;; :config (epa-file-enable)
  )
(use-package org-crypt
  :defer 10
;  :ensure t
  :config (org-crypt-use-before-save-magic)
  (setq org-tags-exclude-from-inheritance (quote ("crypt"))))
; GPG key to use for encryption
; Either the Key ID or set to nil to use symmetric encryption.
(setq org-crypt-key nil)
;;* ctags gtags etc
;; 08_01_2016
;; (run-with-idle-timer
;;  6 nil
;;  (lambda () (load-file (expand-file-name "elisp/setup-tags/setup-tags.el" emacs-d))))
;;** dumb-jump
(use-package dumb-jump
  ;; :bind (("M-g o" . dumb-jump-go-other-window)
  ;;        ("M-g j" . dumb-jump-go)
  ;;        ("M-g x" . dumb-jump-go-prefer-external)
  ;;        ("M-g z" . dumb-jump-go-prefer-external-other-window))
  :config (setq dumb-jump-selector 'ivy) ;; (setq dumb-jump-selector 'helm)
  :ensure)
;;* Diff
;;** diff-hl
;; 25_01_2016
(use-package diff-hl
  :defer 10

)
;;* Line numbers
;; moved to hook.el
;; (require 'nlinum)
;; (add-hook 'emacs-lisp-mode-hook 'nlinum-mode)
;;* Anybar
;; (require 'anybar)
;; (anybar-start)
;; (anybar-set "green")
;; (anybar-quit)
;;* Narrowing
(put 'narrow-to-page 'disabled nil)

(defun narrow-or-widen-dwim (p)
  "Widen if buffer is narrowed, narrow-dwim otherwise.
Dwim means: region, org-src-block, org-subtree, or
defun, whichever applies first. Narrowing to
org-src-block actually calls `org-edit-src-code'.

With prefix P, don't widen, just narrow even if buffer
is already narrowed."
  (interactive "P")
  (declare (interactive-only))
  (cond ((and (buffer-narrowed-p) (not p)) (widen))
        ((region-active-p)
         (narrow-to-region (region-beginning)
                           (region-end)))
        ((derived-mode-p 'org-mode)
         ;; `org-edit-src-code' is not a real narrowing
         ;; command. Remove this first conditional if
         ;; you don't want it.
         (cond ((ignore-errors (org-edit-src-code) t)
                (delete-other-windows))
               ((ignore-errors (org-narrow-to-block) t))
               (t (org-narrow-to-subtree))))
        ((derived-mode-p 'latex-mode)
         (LaTeX-narrow-to-environment))
        (t (narrow-to-defun))))
;; (define-prefix-command 'endless/toggle-map)
;; (define-key ctl-x-map "t" 'endless/toggle-map)
;; (define-key endless/toggle-map "n"
  ;; #'narrow-or-widen-dwim)
;; This line actually replaces Emacs' entire narrowing
;; keymap, that's how much I like this command. Only
;; copy it if that's what you want.
;; (define-key ctl-x-map "n" #'narrow-or-widen-dwim)
(add-hook 'LaTeX-mode-hook
          (lambda ()
            (define-key LaTeX-mode-map "\C-xn"
              nil)))
;;* Calendars
;;** Calfw
;;22-02-2017 11:08:13
;; (require 'calfw)
;; (require 'calfw-org)

;;* Wiki
(use-package plain-org-wiki
  ;; :defer t
  )
;;* Python
;;** Jedi.el
(setq jedi:complete-on-dot t) 
;;** Anaconda.el
;;* Thing at the end : testing
;;** Sml problem - see above
;; (sml/setup)
;;** Keyboard remaps
;; 22_04_2015 trying to reclaim M-w kill-ring-save
;; the same is Keyboard shortcuts section, but gets redefined in mac emacs, works here
(global-set-key (kbd "M-w") 'kill-ring-save)
;; 08_10_2015 start org-agenda when emacs starts
;Automatically open your agenda whenever you start Emacs
;You can get Emacs to automatically open your agenda whenever you start it. Add the following lines to your ~/.emacs.d/init.el file:

;;** Load timing
;;  http://doc.rix.si/org/fsem.html#sec-3-3-1
(let ((elapsed (float-time (time-subtract (current-time) qdot/emacs-start-time))))
(message "Loading %s...done (%.3fs)" load-file-name elapsed))

(add-hook 'after-init-hook
          `(lambda ()
             (let ((elapsed (float-time (time-subtract (current-time)
                                                        qdot/emacs-start-time))))
               (message "Loading %s...done (%.3fs) [after-init]"
                        ,load-file-name elapsed)))
          t)

;(org-agenda nil "a")
(exec-path-from-shell-initialize)

;;** garbage collection threshold
;;28-02-2017 https://github.com/redguardtoo/emacs.d
(setq gc-cons-threshold best-gc-cons-threshold)
;;** load personal settings
;;06-03-2017
(require 'rush-init nil)

;;* Local variables 
;; 02_12_2015 https://mail.google.com/mail/u/0/#inbox/150e79fd7086d534
;; [O] Using orgstruct-mode (or just org-cycle) in emacs-lisp-mode - org-mode list 
;; Local Variables:
;; outline-regexp: ";;\\*+\\|\\`"
;; orgstruct-heading-prefix-regexp: ";;\\*+\\|\\`"
;; eval: (when after-init-time (orgstruct-mode) (org-global-cycle 3))
;; End:
