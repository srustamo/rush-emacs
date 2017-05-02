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
  '(ac-cider
    ace-link
    ace-window
    ace-popup-menu
    alert
    auto-compile
    auto-yasnippet
    auctex
    cmake-mode
    company
    counsel
    define-word
    eclipse-theme
    elfeed
    function-args
    geiser
    google-c-style
    which-key
    headlong
    helm-make
    hideshowvis
    j-mode
    jedi
    lispy
    magit
    make-it-so
    markdown-mode
    netherlands-holidays
    org-bullets
    org-download
    powerline
    projectile
    find-file-in-project
    rainbow-mode
    request
    slime
    smex
    swiper
    ukrainian-holidays
    use-package
    vimish-fold
    wgrep
    worf
    yaml-mode
    evil
    benchmark-init
    cl
    general
    unbound
    evil-leader
    evil-surround
    key-chord
    evil-search-highlight-persist
    evil-matchit
    solarized-theme
    rainbow-delimiters
    nlinum
    window-numbering
    ido-vertical-mode
    ivy-hydra
    bbdb
    exec-path-from-shell
    wcheck-mode
    dired-rainbow
    ranger
    backup-each-save
    ibuffer-git
    ibuffer-vc
    ibuffer-projectile
	http-post-simple
	ag
	company-statistics
	ggtags
    etags-select
	etags-table
	ctags-update
	terminal-here
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
