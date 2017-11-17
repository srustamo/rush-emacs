;;* 
(defun sort-symbols (reverse beg end)
      "Sort symbols in region alphabetically, in REVERSE if negative.
    See `sort-words'."
      (interactive "*P\nr")
      (sort-regexp-fields reverse "\\(\\sw\\|\\s_\\)+" "\\&" beg end))
