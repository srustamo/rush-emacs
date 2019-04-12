(defconst emacs-d
  (file-name-directory
   (file-chase-links load-file-name))
  "The giant turtle on which the world rests.")

(setq package-user-dir
      (expand-file-name "elpa" emacs-d))
(package-initialize)
(setq package-archives
      '(("melpa" . "http://melpa.org/packages/")
        ("gnu" . "http://elpa.gnu.org/packages/")))
(package-refresh-contents)

(defconst rush-packages
  '(
	ac-cider
	ace-link
	ace-popup-menu
	ace-window
	ag
	airline-themes
	alert
	auctex
	auto-compile
	auto-complete
	auto-yasnippet
	avy
	backup-each-save
	bbdb
	benchmark-init
	benchmark-init-autoloads
	bm
	bookmark
	bind-key
	cl
	cmake-mode
	company
	company-statistics
	counsel
	counsel-osx-app
	crosshairs
	ctags-update
	define-word
	diff-hl
	dired-avfs
	dired-rainbow
	dired-x
	dumb-jump
	diminish
	eclipse-theme
	edit-server
	elfeed
	epa-file
	etags-select
	etags-table
	evil
	evil-commentary
	evil-leader
	evil-matchit
	evil-multiedit
	evil-nerd-commenter
	evil-org
	evil-search-highlight-persist
	evil-surround
	evil-vimish-fold
	evil-visual-mark-mode 
	exec-path-from-shell
	find-file-in-project
	flycheck
	function-args
	geiser
	general
	ggtags
	gmail-message-mode
	golden-ratio
	google-c-style
	grr
	grab-mac-link
	headlong
	helm
	helm-config
	helm-make
	hideshowvis
	http-post-simple
	hydra
	hydra-examples
	ibuffer
	ibuffer-git
	ibuffer-projectile
	ibuffer-vc
	ido
	ido-vertical-mode
	interaction-log
	ispell
	ivy-hydra
	ivy-rich
	j-mode
	jedi
	key-chord
	keyfreq
	keys
	lispy
	magit
	make-it-so
	markdown-mode
	multiple-cursors
	nlinum
	notify
	nov
	org-bullets
	org-capture
	org-crypt
	org-download
	org-gcal
	org-inlinetask
	org-pdfview
	org-pomodoro
	org-protocol
	orglue
	ox-pandoc
	ox-reveal
	; open-file-at-point
	paradox
	pdf-tools
	persp-projectile
	powerline
	powerline-evil
	projectile
	popup
	rainbow-delimiters
	rainbow-mode
	ranger
	recentf 
	request
	rush-company
	seeing-is-believing
	simpleclip
	simplenote2
	slime
	smex
	solarized
	solarized-theme
	spaces
	swiper
	terminal-here
	tiny
	todochiku
	transpose-frame
	unbound
	undo-tree
	use-package
	vimish-fold
	vlf
	wcheck-mode
	wgrep
	wgrep-ag
	which-key
	window-numbering
	worf
	whitespace
	yaml-mode
	yasnippet
	)
  
  "List of packages that I like.")

;; install required
(dolist (package rush-packages)
  (unless (package-installed-p package)
    (ignore-errors
      (package-install package))))

;; upgrade installed
(save-window-excursion
  (package-list-packages t)
  (package-menu-mark-upgrades)
  (condition-case nil
      (package-menu-execute t)
    (error
     (package-menu-execute))))
