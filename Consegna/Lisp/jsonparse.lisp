;;; Membri del Gruppo
;;; 856095 Manzi Luca 
;;; 851849 Montoli Matteo
;;; 859246 Zhou Chengjie

;;; -*- Mode: Lisp -*-

;;; begin-of-file jsonparsing.lisp


	
	 







;;;BEGIN INPUT OUTPUT
(defun jsondump (lisp-json file-name) 
  ;;; TARGET-VARIABLE IS WHERE THE DATA IS WRITTEN IN AND SET ON FILE NAME
  (with-open-file (target-variable file-name 
                                   :direction :output
                                   :if-exists :supersede
                                   :if-does-not-exist :create)
    (format target-variable 
            (lisp-json-to-json lisp-json))))


;; Transform JSON into a string

(defun lisp-json-to-json (lisp-json)
  (let ((head (first lisp-json))
        (tail (rest lisp-json)) ) 
    (cond ((eql head 
                'jsonobj) 
           (concatenate 'string 
                        "{"
                        (parse-lisp-obj tail)
                        "}"))
          ((eql head 
                'jsonarray) 
           (concatenate 'string 
                        "["
                        (parse-lisp-arr tail)
                        "]"))
          (T (error "MALFORMED OBJECT")))))

(defun parse-lisp-obj (json-lisp) 
  (let ((head (first json-lisp))
        (tail (rest json-lisp))) 
    (if (null json-lisp) "" 
      (concatenate 'string 
                   (stringify-key-value-lisp-json head)
                   (if (last-pair tail) "" ",")
                   (parse-lisp-obj tail))
        )))

(defun parse-lisp-arr (json-lisp) 
  (let 
      ((head (first json-lisp))
       (tail (rest json-lisp))) 
    
    (if (null json-lisp) "" 
      (concatenate 'string 
                   (stringify-value-lisp-json head)
                   (if (null tail) "" ",")
                   (parse-lisp-arr tail)
                       ))))
;; key-value ->  (x y)
(defun stringify-key-value-lisp-json (key-value) 
  (let ((key (first key-value))
        (value (cadr key-value)))
    (concatenate 'string 
                  (stringify-lisp-value key)
                  ":"
                  (stringify-value-lisp-json value))
  ))

;;; {"KEY" : VALUE }
(defun stringify-value-lisp-json (value)
  (cond ((numberp value) 
          (prin1-to-string value))
        ((stringp value) 
          (stringify-lisp-value value))
        (T (lisp-json-to-json value))
          ))

(defun last-pair (json-object-lisp) 
  (eql (length json-object-lisp) 0)
  )
;;; take a lisp valeu and converts it in a string with apix 
(defun stringify-lisp-value (value) 
  (concatenate 'string "\"" value "\""))



;;;begin json read
(defun jsonread (filename) 
  (with-open-file (input-stream filename 
                                :if-does-not-exist :error
                                :direction :input) 
    ;;;TODO LUCA METTERE METODO 
    ;;; PL               
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
;;; END OF INPUT OUTPUT







;;; end-of-file jsonparsing.lisp
