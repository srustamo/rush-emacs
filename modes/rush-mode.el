;; Time-stamp: <2016-06-06 12:26:17 srmba3>

;; 6-06-2016 sr 
;; https://www.reddit.com/r/emacs/comments/4mer1r/defining_own_keybindings_and_best_practices_when/
;; [–]kaushalmodi 3 points 2 days ago* 
;; Here is the priority of key bindings: emulation-mode-map > minor-mode-map > major-mode-map > global-map
;; You were probably setting some C-x .. binding in global-map that was then overridden by some major mode?
;; Otherwise, emacs never ignores any binding you set.
;; Here is how to bind something that will always work.

;; My minor mode
;; Main use is to have my key bindings have the highest priority

(defvar rush-special-keymap-prefix (kbd "C-x m")
  "`rush-mode' keymap prefix.
Overrides the default binding for `compose-mail'.")

(defvar rush-mode-special-map (make-sparse-keymap)
  "Special keymap for `rush-mode' whose bindings begin with
`rush-special-keymap-prefix'.")
(fset 'rush-mode-special-map rush-mode-special-map)

(defvar rush-mode-map (let ((map (make-sparse-keymap)))
                        (define-key map rush-special-keymap-prefix 'rush-mode-special-map)
                        map)
  "Keymap for `rush-mode'.")

;;;###autoload
(define-minor-mode rush-mode
  "A minor mode so that my key settings override annoying major modes."
  ;; If init-value is not set to t, this mode does not get enabled in
  ;; `fundamental-mode' buffers even after doing \"(global-rush-mode 1)\".
  ;; More info: http://emacs.stackexchange.com/q/16693/115
  :init-value t
  :lighter    " μ"
  :keymap     rush-mode-map)

;;;###autoload
(define-globalized-minor-mode global-rush-mode rush-mode rush-mode)

;; https://github.com/jwiegley/use-package/blob/master/bind-key.el
;; The keymaps in `emulation-mode-map-alists' take precedence over
;; `minor-mode-map-alist'
(add-to-list 'emulation-mode-map-alists `((rush-mode . ,rush-mode-map)))

;; Turn off the minor mode in the minibuffer
(defun turn-off-rush-mode ()
  "Turn off rush-mode."
  (rush-mode -1))
(add-hook 'minibuffer-setup-hook #'turn-off-rush-mode)

(defmacro bind-to-rush-map (key fn)
  "Bind a function to the `rush-mode-special-map'.
USAGE: (bind-to-rush-map \"f\" #'full-screen-center)."
  `(define-key rush-mode-special-map (kbd ,key) ,fn))

;; http://emacs.stackexchange.com/a/12906/115
(defun unbind-from-rush-map (key)
  "Unbind a function from the `rush-mode-map'
USAGE: (unbind-from-rush-map \"C-x m f\")
"
  (interactive "kUnset key from rush-mode-map: ")
  (define-key rush-mode-map (kbd (key-description key)) nil)
  (message "%s" (format "Unbound %s key from the %s."
                        (propertize (key-description key)
                                    'face 'font-lock-function-name-face)
                        (propertize "rush-mode-map"
                                    'face 'font-lock-function-name-face))))


(provide 'rush-mode)

;; Minor mode tutorial: http://nullprogram.com/blog/2013/02/06/
