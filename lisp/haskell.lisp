
(defparameter compound-tokens '("string-token" "number-token"))
(defparameter simple-tokens '("OPENCURLY" "CLOSEDCURLY" "OPENBRACKET" "CLOSEDBRACKET" "COMMA" "COLON"))
;;
(defparameter emptytok '("OPENCURLY" "CLOSEDCURLY"))
;; (parser(tokens) -> ( ( rest-of-tokens ) ( parsedvalue )) )
;;
(defparameter val '(("string-token" "ciao") "CLOSEDBRACKET"))

(defparameter emptytok2 '("OPENBRACKET" ("string-token" "uno") ("number-token" 2) "CLOSEDBRACKET"))

;; To implement a recursive descent parser in Common Lisp,
;; you can use a combination of functions and recursion to parse the list of tokens.
;; You can define a separate function for each non-terminal symbol in your grammar,
;; and use recursion to handle the production rules.
;; Since you cannot use loops or assignments, you will need to use recursion
;; to iterate through the list of tokens,
;; and use pattern matching to identify the current token
;; and determine which production rule to apply.
;; To parse a simplified version of JSON,
;; you will need to define functions for handling the
;; JSON object and
;; array structures, as well
;; as functions for handling the various types of JSON values (strings, numbers, etc.).

(defun parse-json (tokens)
  (cond
    ((is-openc-t (car tokens))
     ;(cons 'jsonobj (parse-object (cdr tokens))))
     (parse-object(cdr tokens)))
    ((is-openb-t (car tokens))
     (parse-array(cdr tokens)))
    (t (error "Invalid JSON format"))))


(defun parse-object (tokens)
  (let*
      ((objectparsed (parse-object_ tokens)))
    (list (cons 'jsonobj (reverse (rest (reverse objectparsed))))
          (last objectparsed)))
  )


(defun parse-object_ (tokens)
  (cond ((or (null tokens)
             (and (stringp tokens)
                  (not (is-closedc-t tokens))))
          (error "Missing closing '}'"))    ;; last element, tokens not a list anymore:
        ((and (stringp tokens)
              (is-closedc-t tokens))
         ()) ;; '() -> first nil here an belo(parse-key-value kv1)w
        ((is-closedc-t (first tokens))
         (list (cdr tokens))) ;; pop
        (t
         (let*
             ((pair-next (parse-key-value tokens))
              (pair (first pair-next))
              (next (second pair-next)))
           (cond
            ((is-comma-t (first next)) ;  \, case
             (cons pair (parse-object_ (cdr next)))) ;; pop
             ;; check if it's giving problem if it's the last one,
             ;; first is ("string-token")
            ((is-closedc-t (first next))
             (cons pair (parse-object_ next)))
             ;;(cons value (parse-array next))) ;; check for }
            (t
             (error "object not well formed")))))))
           ;; case }
           ;; cae ,

(defun parse-array (tokens)
  (let*
      ((arrayparsed (parse-array_ tokens)))
    (list (cons 'jsonarray (reverse (rest (reverse arrayparsed))))
          (last arrayparsed)))
  )

(defun parse-array_ (tokens)
  (cond ((or (null tokens)
             (and (stringp tokens)
                  (not (is-closedb-t tokens))))
          (error "Missing closing ']'"))    ;; last element, tokens not a list anymore:
        ((and (stringp tokens)
              (is-closedb-t tokens))
         ()) ;; '() -> first nil here an belo(parse-key-value kv1)w
        ((is-closedb-t (first tokens))
         (list (cdr tokens))) ;; pop
        (t
         (let*
             ((value-next (parse-value tokens))
              (value (first value-next))
              (next (second value-next)))
           (cond
            ((is-comma-t (first next)) ;  \, case
             (cons value (parse-array_ (cdr next)))) ;; pop
             ;; check if it's giving problem if it's the last one,
             ;; first is ("string-token")
            ((is-closedb-t (first next))
             (cons value (parse-array_ next)))
             ;;(cons value (parse-array next))) ;; check for }
            (t
             (error "array not well formed")))))))
           ;; case }
           ;; cae ,


(defun parse-value (tokens)
  (let* (
         (token (first tokens))
         )
    (cond
      ((and
        (stringp (first tokens))
        (or (string-equal token "string-token")
            (string-equal token "number-token")))
       (list (second tokens) nil)) ;; ake some checks
      ;; ELSE
      ((is-openc-t token) (parse-object (cdr tokens)));(parse-object (cdr tokens)))
      ((is-openb-t token) (parse-array (cdr tokens)));(parse-array (cdr tokens)))
      (t (let ((token (first tokens)))
           (cond ((is-string-t token) (parse-string tokens)) ;; pop
                 ((is-number-t token) (parse-number tokens)) ;; pop
                 ;;((eq token 'true) t)
                                        ;((eq token 'false) nil)
                                        ; ;((eq token 'null) nil)
                 (t (error "Invalid JSON value")))))))) ;; also for nil


(defun parse-string (tokens) ;; check here?
  (if (and
       (eq (length tokens) 2)
       (stringp (first tokens))
       (string-equal (first tokens) "string-token"))
      (list (second tokens) ())
      ;;ELSE
      (list (second (first tokens)) (cdr tokens))))

(defun parse-number (tokens) ;; check here?
  (if (and
       (eq (length tokens) 2)
       (stringp (first tokens))
       (string-equal (first tokens) "number-token"))
      (list (second tokens) ())
      ;;ELSE
      (list (second (first tokens)) (cdr tokens))))


(defun parse-key-value (tokens)
  (let ((key (parse-string (first tokens)))
        (colon (second tokens)) ;; check
        (value (parse-value (cddr tokens))))
    (if (is-colon-t colon)
        (list (list (first key) (first value)) (second value))
        ;; ELSE
        (error "pair separator not found")
        )))

;; UTILS
(defun get-token-type (token)
  (cond
    ((null token)
     nil)
    ((and
      (not (listp token))
      (find token simple-tokens :test #'string=))
     token)
    ((and
      (eq (length token) 2)
      (find (first token) compound-tokens :test #'string=))
     (first token))
    ( T
      (first token)
     ;(and (write token)
      ;    (error "cannot infer token type"))
     )))

(defun is-comma-t (token)
  (string-equal
   (get-token-type token)
   "COMMA")
  ) ;; comma token predicate

(defun is-openb-t (token)
  (string-equal
   (get-token-type token)
   "OPENBRACKET")
  ) ;; comma token predicate

(defun is-closedb-t (token)
  (string-equal
   (get-token-type token)
   "CLOSEDBRACKET")
  )
(defun is-openc-t (token)
  (string-equal
   (get-token-type token)
   "OPENCURLY")
  ) ;; comma token predicate
(defun is-closedc-t (token)
  (string-equal
   (get-token-type token)
   "CLOSEDCURLY")
  )

(defun is-colon-t (token)
  (string-equal:q
   (get-token-type token)
   "COLON")
  )

(defun is-string-t (token)
  (string-equal
   (get-token-type token)
   "string-token")
  )
(defun is-number-t (token)
  (string-equal
   (get-token-type token)
   "number-token")
  )


(defparameter y '(
                 ("string-token" "nome") "COLON"
                  ("string-token" "Arthur") "CLOSEDCURLY"))

(defparameter k '("OPENCURLY"
                 ("string-token" "nome") "COLON" ("string-token" "Arthur") "COMMA"
                 ("string-token" "cognome") "COLON" ("string-token" "Dent") "COMMA"
                 ("string-token" "eta") "COLON" ("number-token" 19) "CLOSEDCURLY"))

(defparameter c '("OPENCURLY"
                 ("string-token" "nome") "COLON" ("string-token" "JOE")
                  "COMMA"  ("string-token" "cognome") "COLON"
                  ("string-token" "Dent") "CLOSEDCURLY" ))


(defparameter pino '("OPENCURLY"
                 ("string-token" "nome") "COLON" ("string-token" "Arthur") "COMMA"
                 ("string-token" "cognome") "COLON" ("string-token" "Dent") "COMMA"
                 ("string-token" "eta") "COLON" ("number-token" 19) "COMMA" ("string-token" "nested") "COLON" "OPENCURLY" ("string-token" "nome") "COLON" ("string-token" "Arthur") "CLOSEDCURLY" "CLOSEDCURLY"))

(defparameter arr '("OPENBRACKET" ("number-token" 1) "COMMA"
                                  ("number-token" 2) "COMMA"
                                  ("string-token" "TREEEEE")
                          "COMMA" ("number-token" 4) "CLOSEDBRACKET"))

(defparameter arr2 '( "OPENBRACKET" ("number-token" 1) "COMMA"
                     "OPENBRACKET"("number-token" 2) "COMMA"
                                  ("string-token" "TREEEEE") "CLOSEDBRACKET"
                          "COMMA" ("number-token" 4) "CLOSEDBRACKET"))


(defparameter ne '("OPENBRACKET" "OPENCURLY" "CLOSEDCURLY" "CLOSEDBRACKET"))


(defparameter kv1 '(("string-token" "name") "COLON" ("number-token" 1) "CLOSEDBRACKET"))
(defparameter kv2 '("OPENBRACKET" "OPENCURLY" "CLOSEDCURLY" "CLOSEDBRACKET"))

(defparameter pino3 '(
                       "OPENCURLY"
                       ("string-token" "Nest 1") "COLON"
                       "OPENCURLY"
                       ("string-token" "Nest 2") "COLON"
                       "OPENCURLY"
                       ("string-token" "eta") "COLON" ("number-token" 19)
                       "COMMA"
                       ("string-token" "Nest 3")  "COLON"
                       "OPENCURLY"
                       ("string-token" "eta") "COLON" ("number-token" 19)
                       "COMMA"
                       ("string-token" "cognome") "COLON" ("string-token" "Dent")
                       "CLOSEDCURLY"
                       "CLOSEDCURLY"
                       "CLOSEDCURLY"
                       "CLOSEDCURLY"))
