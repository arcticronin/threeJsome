(defparameter curly-brackets '(#\{ #\}))
(defparameter squared-brackets '(#\[ #\]))

(defparameter test-json-string "{\"nome\" : \"Arthur\",\"cognome\" : \"Dent\"}")

;;;; Given a string returns an array of characters
(defun string-to-list (json-string)
    (coerce json-string 'list))

;;;; Given a list of strings returns a list with istances of "strings-to-filter" only
(defun filter-string-list (string-list strings-to-filter) 
    (remove-if (lambda (char) 
                        (not (member char strings-to-filter))) 
    string-list))

;;;; Input : Json string as list - Checks the number of { == }
(defun brackets-checker (string-list) 
    (and 
    (evenp (list-length (filter-string-list string-list curly-brackets)))
    (evenp (list-length (filter-string-list string-list squared-brackets)))
    ))


