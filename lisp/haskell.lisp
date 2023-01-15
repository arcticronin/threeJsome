
(defparameter compound-tokens '("string-token" "number-token"))
(defparameter simple-tokens '("OPENCURLY" "CLOSEDCURLY" "OPENBRACKET" "CLOSEDBRACKET" "COMMA" "COLON"))
;;
(defparameter emptytok '("OPENCURLY" "CLOSEDCURLY"))
;; (parser(tokens) -> ( ( rest-of-tokens ) ( parsedvalue )) )
;;
(defparameter val '(("string-token" ciao) "CLOSEDBRACKET"))

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

;; (defun parse (tokens)
;;   (if (or
;;        (is-openc-t (first tokens))
;;        (is-openb-t (first tokens)))
;;       (parse-json tokens)
;;       (error "not a valid start")))


;; (defun parse-json (tokens)
;;   (let ((token (pop tokens)))
;;     (cond ((is-openc-t token)
;;            (parse-object tokens))
;;           ((is-openb-t token)
;;            (parse-array tokens))
;;           (t (parse-value token)))))

;; (defun parse-object (tokens)
;;   (let ((token (pop tokens)) object)
;;     (cond ((is-closedc-t  token)
;;            (list 'jsonobj (reverse object)))
;;           (t (let ((key (parse-string token))
;;                    (colon (pop tokens))
;;                    (value (parse-json tokens)))
;;                (push (cons key value) object)
;;                (parse-object tokens))))))

;; (defun parse-array (tokens)
;;   (let ((token (pop tokens)) array)
;;     (cond ((is-closedb-t token) (list 'jsonarray (reverse array)))
;;           (t (push (parse-json token) array)
;;               (parse-array tokens)))))

;; (defun parse-value (token)
;;   (cond ((is-string-t token)
;;          (parse-string token))
;;         ((is-number-t token)
;;          (parse-number token))
;;         ;((eq token 'true) t)
;;         ;((eq token 'false) nil)
;;         ;((eq token 'null) nil)
;;         (t (error "unable to parse value"))))

;; (defun parse-string (token)
;;   (second token))

;; (defun parse-number (token)
;;   (second token))



(defun parse-json (tokens)
  (cond
    ((is-openc-t (car tokens))
     (cons 'jsonobj (parse-object (cdr tokens))))
    ((is-openb-t (car tokens))
     (let* ((arrayparsed (parse-array (cdr tokens))))
       (list (cons 'jsonarray (reverse (rest (reverse arrayparsed))))
             (last arrayparsed)
             )))
;;     (list 'jsonarray (parse-array (cdr tokens))))
    (t (error "Invalid JSON format"))))

(defun parse-object (tokens)
  (cond ((null tokens) (error "Missing closing '}'"))
        ((is-closedc-t (car tokens)) '())
        (t (let ((key-value (parse-key-value (car tokens))))
             (cons key-value (parse-object (cdr tokens)))))))


(defun parse-array (tokens)
  (cond ((or (null tokens)
             (and (stringp tokens)
                  (not (is-closedb-t tokens))))
          (error "Missing closing ']'"))    ;; last element, tokens not a list anymore:
        ((and (stringp tokens)
              (is-closedb-t tokens))
         ()) ;; '() -> first nil here an below
        ((is-closedb-t (first tokens))
         (list (cdr tokens))) ;; pop
        (t
         (let*
             ((value-next (parse-value tokens))
              (value (first value-next))
              (next (second value-next)))
           (cond
            ((is-comma-t (first next)) ;  \, case
             (cons value (parse-array (cdr next)))) ;; pop
             ;; check if it's giving problem if it's the last one,
             ;; first is ("string-token")
            ((is-closedb-t (first next))
             (cons value (parse-array next)))
             ;;(cons value (parse-array next))) ;; check for }
            (t
             (error "array not well formed")))))))
           ;; case }
           ;; cae ,





(defun format-tokens (tokens)
  (cond
    ((stringp tokens)
     (list tokens))
    (t
     tokens)))



(defun parse-value (tokens)
  (if (eq (length tokens) 1)
      (list tokens) ;; ake some checks
      ;; ELSE
      (let ((token (first tokens)))
        (cond ((is-string-t token) (parse-string tokens)) ;; pop
              ((is-number-t token) (parse-number tokens)) ;; pop
              ;;((eq token 'true) t)
              ((is-openc-t token) (parse-object token));(parse-object (cdr tokens)))
              ((is-openb-t token) (parse-array token));(parse-array (cdr tokens)))
              ;;((eq token 'false) nil)
              ;;((eq token 'null) nil)
              (t (error "Invalid JSON value")))))) ;; also for nil


(defun parse-string (tokens) ;; check here?
  (list (second (first tokens)) (cdr tokens)))

(defun parse-number (tokens)
  (list (second (first tokens)) (cdr tokens)))


(defun parse-key-value (tokens)
  (let ((key (parse-string (first tokens)))
        (colon (second tokens)) ;; check
        (value (parse-value (cdddr tokens))))
    (list (cons key (first value)) (second value))))






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
     (and (write token)
          (error "cannot infer token type"))
     )))

(defun is-comma-t (token)
  (string-equal
   (get-token-type token)
   "COMMA")
  ) ;; comma token predicate
(defun is-closedb-t (token)
  (string-equal
   (get-token-type token)
   "CLOSEDBRACKET")
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
  (string-equal
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
                 ("string-token" "nome") "COLON" ("string-token" "JOE") "COMMA"  ("string-token" "cognome") "COLON" ("string-token" "Dent") "CLOSEDCURLY" ))


(defparameter pino '("OPENCURLY"
                 ("string-token" "nome") "COLON" ("string-token" "Arthur") "COMMA"
                 ("string-token" "cognome") "COLON" ("string-token" "Dent") "COMMA"
                 ("string-token" "eta") "COLON" ("number-token" 19) "COMMA" ("string-token" "nested") "COLON" "OPENCURLY" ("string-token" "nome") "COLON" ("string-token" "Arthur") "CLOSEDCURLY" "CLOSEDCURLY"))

(defparameter arr '("OPENBRACKET" ("number-token" 1) "COMMA"
                                  ("number-token" 2) "COMMA"
                                  ("string-token" "TREEEEE")
                          "COMMA" ("number-token" 4) "CLOSEDBRACKET" "COLON"))

(defparameter ne '("OPENBRACKET" "OPENCURLY" "CLOSEDCURLY" "CLOSEDBRACKET"))
