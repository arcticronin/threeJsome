(defparameter j '("OPENCURLY"
                 ("string-token" "nome") "COLON" ("string-token" "Arthur") "COMMA"
                 ("string-token" "cognome") "COLON" ("string-token" "Dent") "COMMA"
                 ("string-token" "eta") "COLON" ("number-token" 19) "CLOSEDCURLY"))





(defun parse-obj (obj)
           (cond ((string-equal (first obj) "OPENCURLY")
                  (and
                   (write "trueeee")
                   (cons 'jsonobj (parse-members (cdr obj))))
                  )
                 ((string-equal (first obj) "OPENBRACKET")
                  (write "false"))
                 (T (error "error in parsing object"))))

(defun parse-members (tokens)
  (cond
    ((not (string-equal (first (first tokens)) "string-token"))
    (error "unexpected identifier in member"))
    ((not (string-equal (second  tokens) "COLON"))
    (error "unexpected separator in member"))
    (T
    (list
     (list
      'pair
      (second (first tokens))
      (cddr tokens)
      )
     () ;; empty string
     ))))

(defun parse-value tokens
  (cond
    (or (string-equal
         (first (first tokens) "string-token")
         (first (first tokens) "number-token"))
        (second (first tokens)))
    (T (write "sono qui"))))
