(defparameter curly-brackets '(#\{ #\}))
(defparameter squared-brackets '(#\[ #\]))
(defparameter brackets (append curly-brackets squared-brackets))
(defparameter spaces '(#\Space #\Newline #\Tab))
(defparameter apix '(#\" #\'))
(defparameter token-column (list "COLON"))
(defparameter token-comma (list "COMMA"))
(defparameter token-white-space (list "WHITESPACE"))
(defparameter digits '(#\1 #\2 #\3 #\4 #\5 #\6 #\7 #\8 #\9 #\0))
;;;TODO FIXARE IL PARSER DEL NUMERO QUANDO HO UN MENO DENTRO!!
(defparameter symbols '(#\+ #\-))
(defparameter full-number-symbols (append digits symbols))

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


;;;(#\" #\Space #\Space #\Space #\n #\o #\m #\e #\" #\: #\" #\A #\r #\t #\h #\u #\r #\" )

;; Lo chiamo quando incontro il carattere \"
;;; Caso base : \" <- Se ritrovo i doppi apici so che sono alla fine di una stringa
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


;;; Dato una lista di caratteri in input restituisce una numero in forma stringa
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





;;;(#\" #\Space #\Space #\Space #\n #\o #\m #\e #\" #\: #\" #\A #\r #\t #\h #\u #\r #\" )

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

 
