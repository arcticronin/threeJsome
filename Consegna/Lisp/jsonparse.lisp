;;; Membri del Gruppo
;;; 856095 Manzi Luca 
;;; 851849 Montoli Matteo
;;; 859246 Zhou Chengjie

;;; -*- Mode: Lisp -*-

;;; begin-of-file jsonparsing.lisp


(defparameter curly-brackets '(#\{ #\}))
(defparameter squared-brackets '(#\[ #\]))
(defparameter brackets (append curly-brackets squared-brackets))
(defparameter spaces '(#\Space #\Newline #\Tab))
(defparameter apix '(#\" #\'))
(defparameter token-column (list "COLON"))
(defparameter token-comma (list "COMMA"))
(defparameter token-white-space (list "WHITESPACE"))
(defparameter digits '(#\1 #\2 #\3 #\4 #\5 #\6 #\7 #\8 #\9 #\0))

(defparameter symbols '(#\-))
(defparameter full-number-symbols (append digits symbols))


;;;BEGIN TOKENIZER

(defun tokenize (string)
  (remove-white-spaces-token 
   (tokenize-char-list 
    (string-to-list string))) 
)
 
;;;; Given a string returns an array of characters
(defun string-to-list (json-string)
    (coerce 
     json-string 
     'list))

(defun char-list-to-string (char-list) 
  (coerce char-list 'string))



(defun string-to-number (string)
   (if (null (find #\. string))
      (parse-integer string)

     (cond ((null 
             (float-integrity string)) 
             (error "MALFORMED FLOAT"))     
           (T (parse-float string)))))     

(defun float-integrity (string-number) 
(eql (count #\. string-number) 1))



(defun remove-white-spaces-token (char-list) 
  (remove-if
   (lambda (char)
     (member char token-white-space))
   char-list))

(defun parse-string (char-list &optional acc) 
  (let ((curr-char (first char-list))
        (list-rest (rest char-list)))
    (if (eql curr-char #\") 
        (list 
         (char-list-to-string 
          (append acc  nil)) 
         list-rest)
      (parse-string list-rest 
                    (append acc
                            (list curr-char)))
      )
))

(defun parse-number (char-list &optional acc ) 
  (let ((curr-char 
         (first char-list))
        (rest-list 
         (rest char-list)))

    (if (or (member curr-char digits) 
      (eql curr-char #\.)) 
        (parse-number rest-list 
          (append acc (list curr-char))) 
          (list (char-list-to-string 
            (append acc nil)) 
               char-list)) 
    ))

(defun tokenize-char-list (char-list &optional acc) 
  (let ((head-list 
         (first char-list)) 
        (tail-list 
         (rest char-list)))
 
    (if (null char-list)
        ;;;base case 
        (append acc char-list)
      ;;;tokenize brackets
      (cond ((member head-list brackets) 
             (tokenize-char-list tail-list 
                        (append acc 
                                (tokenize-brackets
                                 head-list))))
            ;;;TOKENIZE COMMA
            ((eql head-list #\:) 
             (tokenize-char-list tail-list 
                        (append acc 
                                token-column )))
            ;;TOKENIZE COMMA
            ((eql head-list #\,) 
             (tokenize-char-list tail-list 
                        (append acc 
                                token-comma)))
            ;;;TOKENIZE STRING
            ((eql head-list #\") 
             (let ((parsed-string-data 
                    (parse-string tail-list)))
          (tokenize-char-list (cadr
                      parsed-string-data)             
          (append acc 
                  (list 
                   (tokenize-string (car parsed-string-data)))))
          )
             )

          ;;;TOKENIZE-NUMBER
          ((member head-list 
                   full-number-symbols) 
           (let ((parsed-number-data
                  (if (eql head-list #\-) 
                      (parse-number tail-list 
                                    (list #\-)) 
                    (parse-number char-list))))
             (tokenize-char-list 
              (cadr parsed-number-data) 
              (append acc 
                      (list 
                       (tokenize-number 
                        (string-to-number (car parsed-number-data)))))
              )))
          ((member head-list 
                   spaces) 
           (tokenize-char-list tail-list
                      (append acc
                              token-white-space)))     
          (T (error "MALFORMED JSON"))))))


(defun tokenize-brackets (char) 
  (cond ((eql char #\{) 
         (list "OPENCURLY"))
        ((eql char #\}) 
         (list "CLOSEDCURLY"))
        ((eql char #\[) 
         (list "OPENBRACKET"))
        ((eql char #\]) 
         (list "CLOSEDBRACKET"))
 ))

(defun tokenize-string (string-to-tokenize) 
  (list "string-token"
        string-to-tokenize))
(defun tokenize-number (number-to-tokenize) 
  (list "number-token"
        number-to-tokenize))


;;; END TOKENIZER

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
