;; json-load
(defun json-read (filename)
  (with-open-file (in filename
		      :if-does-not-exist :error
		      :direction :input)
  (json-parse (load-char in))))