(defparameter curly-brackets '(#\{ #\}))
(defparameter squared-brackets '(#\[ #\]))
(defparameter spaces '(#\Space #\Newline #\Tab))
;;; NOTE ! #\{carattere_a_piacere} <- è la notazione per i caratteri in lisp


;;;; Given a string returns an array of characters
(defun string-to-list (json-string)
    (coerce 
     json-string 
     'list))

;;;; Given a list of strings returns a list with istances of "strings-to-filter" only
(defun filter-string-list (string-list strings-to-filter)
  (remove-if
   (lambda (char)
     (not 
      (member 
       char 
       strings-to-filter))) 
   string-list))

;;;; Given json string list checks if every bracket matches.
(defun brackets-checker (string-list)
  (and
   (evenp 
    (list-length 
     (filter-string-list 
      string-list
      curly-brackets)))
   (evenp 
    (list-length 
     (filter-string-list 
      string-list 
      squared-brackets))
)))

;;;; Removing every white spaces
(defun remove-white-spaces (char-list) 
  (remove-if
   (lambda (char)
     (member char spaces))
   char-list))

;;;; Given a JSON STRING returns an object
(defun json-parse (json-string) 
  (let ((json-string-list 
         (string-to-list json-string))) 
    (if (not (brackets-checker 
              json-string-list))
        (error "Syntax error! Unbalanced braces")
      ()
      )
    ))


;;;; Given a json-string list determine the initial structure

(defun parse-json-list (json-string-list) 
  (if (eql 
       (first json-string-list) 
       #\{)
      (list 
       'jsonobj)
    (list
     'jsonarray)))


