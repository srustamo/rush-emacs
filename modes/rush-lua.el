
(autoload 'lua-mode "lua-mode" "Lua editing mode." t)
(add-to-list 'auto-mode-alist '("\\.lua$" . lua-mode))
(add-to-list 'interpreter-mode-alist '("lua" . lua-mode))

;;;###autoload
(defun rush-lua-mode-company-init ()
  (setq-local company-backends '((company-lua
                                  company-etags
                                  company-dabbrev-code
                                  company-yasnippet))))

;; (add-hook 'lua-mode-hook #'rush-lua-mode-company-init) moved to hooks.el 05-12-2017

(provide 'rush-lua)
