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


(defun remove-white-spaces (char-list is-in-string) 
  (if (null char-list) char-list
    (let ((list-head (first char-list))
          (list-body (rest char-list)))
      (if (null is-in-string)
          (cond ((eql list-head #\")
                 (append (list list-head) 
                         (remove-white-spaces list-body T)))
                ((member list-head spaces) 
                 (remove-white-spaces list-body nil))
                (T (append (list list-head) 
                           (remove-white-spaces
                            list-body nil)))
       )
       (if (eql list-head #\") 
           (append (list list-head) 
                   (remove-white-spaces 
                    list-body 
                    nil)) 
         (append (list list-head) 
                 (remove-white-spaces 
                  list-body 
                  T)))
       ))))






