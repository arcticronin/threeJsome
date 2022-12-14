(defparameter curly-brackets '(#\{ #\}))
(defparameter squared-brackets '(#\[ #\]))
(defparameter spaces '(#\Space #\Newline #\Tab))
(defparameter apix '(#\" #\'))
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
        (list (append acc  nil) list-rest)
      (parse-string list-rest 
                    (append acc
                           (list curr-char) ))
     )
))

;;;(#\" #\Space #\Space #\Space #\n #\o #\m #\e #\" #\: #\" #\A #\r #\t #\h #\u #\r #\" )

(defun tokenize (char-list acc) 
  (let ((head-list (first char-list)) 
        (tail-list (rest char-list))) 
    (if (null char-list) nil 
      (cond ((eql head-list #\{ ) (append acc (list "OPEN-CURLY") )) )
    )
  
  )


  )

;;; ((OPEN CURLY) )
