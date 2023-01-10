(defparameter curly-brackets '(#\{ #\}))
(defparameter squared-brackets '(#\[ #\]))
(defparameter brackets (append curly-brackets squared-brackets))
(defparameter spaces '(#\Space #\Newline #\Tab))
(defparameter apix '(#\" #\'))
(defparameter token-column (list "COLON"))
(defparameter token-comma (list "COMMA"))
;;; NOTE ! #\{carattere_a_piacere} <- è la notazione per i caratteri in lisp


;;;; Given a string returns an array of characters
(defun string-to-list (json-string)
    (coerce 
     json-string 
     'list))

(defun char-list-to-string (char-list) 
  (coerce char-list 'string))

(defun remove-white-spaces (char-list) 
  (remove-if
   (lambda (char)
     (member char spaces))
   char-list))

; (defun remove-white-spaces (char-list &optional is-in-string) 
;   (if (null char-list) char-list
;     (let ((list-head (first char-list))
;           (list-body (rest char-list)))
;       (if (null is-in-string)
;           (cond ((eql list-head #\")
;                  (append (list list-head) 
;                          (remove-white-spaces list-body T)))
;                 ((member list-head spaces) 
;                  (remove-white-spaces list-body nil))
;                 (T (append (list list-head) 
;                            (remove-white-spaces
;                             list-body nil)))
;                 )
;        (if (eql list-head #\") 
;            (append (list list-head) 
;                    (remove-white-spaces 
;                     list-body 
;                     nil)) 
;          (append (list list-head) 
;                  (remove-white-spaces 
;                   list-body 
;                   T)))
;        ))))

;;; (nil)
;;; "pippo" <- OK 


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

;;;(#\" #\Space #\Space #\Space #\n #\o #\m #\e #\" #\: #\" #\A #\r #\t #\h #\u #\r #\" )

(defun tokenizer (char-list acc) 
  (let ((head-list 
         (first char-list)) 
        (tail-list 
         (rest char-list)))
 
    (if (null char-list)
        ;;;base case 
        (append acc char-list)
      ;;;tokenize brackets
      (cond ((member head-list brackets) 
             (tokenizer tail-list 
                        (append acc 
                                (tokenize-brackets
                                 head-list))))
            ;;;TOKENIZE COMMA
            ((eql head-list #\:) 
             (tokenizer tail-list 
                        (append acc 
                                token-column )))
            ;;TOKENIZE COMMA
            ((eql head-list #\,) 
             (tokenizer tail-list 
                        (append acc 
                                token-comma)))
            ;;;TOEKNIZE STRING
            ((eql head-list #\") 
             (let ((parsed-string-data 
                    (parse-string tail-list)))
 
          (tokenizer (cadr
                      parsed-string-data)
                     
          (append acc 
                  (list 
                   (tokenize-string (car parsed-string-data)))))))

      ;;;ELSE CASE      
	    (T (tokenizer tail-list 
          (append acc 
            (list head-list))))  
       )
    )
  
  )
  

  )


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
  (list "string-token" string-to-tokenize))

 

;;; ((OPEN CURLY) )
