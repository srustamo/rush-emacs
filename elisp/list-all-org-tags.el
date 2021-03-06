;;https://c25l.gitlab.io/2017/04/finding-all-org-mode-tags/
(defun rush-org-tags ()                                                                                                                              
(interactive)
  (get-buffer-create "*org-tags*")                                                                                                                   
  (set-buffer "*org-tags*")                                                                                                                          
  (org-mode)                                                                                                                                         
  (let ((tags (sort (delete-dups (apply 'append (delete-dups (org-map-entries (lambda () org-scanner-tags) t 'agenda)))) 'string<)))                 
    (dolist (tag tags)                                                                                                                               
      (insert (concat "[[elisp:(org-tags-view nil \"" tag "\")][" tag  "]]\n"))))                                                                    
  (beginning-of-buffer)                                                                                                                              
  (switch-to-buffer "*org-tags*"))
