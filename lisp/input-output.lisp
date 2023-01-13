(defun json-dump (lisp-json file-name) 
  ;;; TARGET-VARIABLE IS WHERE THE DATA IS WRITTEN IN
  (with-open-file (target-variable file-name 
                                   :direction :output
                                   :if-exists :supersede
                                   :if-does-not-exist :create)
    (format target-variable 
            "aaa")))





(defun json-read (filename) 
  (with-open-file (input-stream filename 
                                :if-does-not-exist :error
                                :direction :input) 
                                  
    (stream-to-string input-stream)
    ))




;;; GIVEN A STREAM RETURNS A STRING
(defun stream-to-string (inputstream)
  (let ((json (read-char inputstream 
                         nil 
                         'eof)))

    (unless (eql json 'eof)
      (string-append json 
                     (load-char inputstream)))
      ))