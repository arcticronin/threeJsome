(defparameter compound-tokens '("string-token" "number-token"))
(defparameter simple-tokens '("OPENCURLY" "CLOSEDCURLY" "OPENBRACKET" "CLOSEDBRACKET" "COMMA" "COLON"))
(defparameter emptytok '("OPENCURLY" "CLOSEDCURLY"))
(defparameter val '(("string-token" "ciao") "CLOSEDBRACKET"))
(defparameter emptytok2 '("OPENBRACKET" ("string-token" "uno") ("number-token" 2) "CLOSEDBRACKET"))

;;
;;     PARSER
;;

(defun jsonparse-tokens (tokens)
  (let
      ((result (parse-json tokens)))
    (if (null (second result))
       (first result)
       ;; ELSE
       (error "cannot parse that string"))))

(defun parse-json (tokens)
  (cond
    ((is-openc-t (car tokens))
     (parse-object(cdr tokens)))
    ((is-openb-t (car tokens))
     (parse-array(cdr tokens)))
    (t (error "Invalid JSON format"))))


(defun parse-object (tokens)
  (let*
      ((objectparsed (parse-object_ tokens))
       (obj (reverse (rest (reverse objectparsed))))
       (rest-tokens (first (reverse objectparsed))))
    (list (cons 'jsonobj obj) rest-tokens)))


(defun parse-object_ (tokens)
  (cond ((or (null tokens)
             (and (stringp tokens)
                  (not (is-closedc-t tokens))))
          (error "Missing closing '}'"))    ;; last element, tokens not a list anymore:
        ((and (stringp tokens)
              (is-closedc-t tokens))
         '()) ;; '() -> first nil here
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
            ((is-closedc-t (first next))
             (cons pair (parse-object_ next)))
            (t
             (error "object not well formed")))))))


(defun parse-array (tokens)
  (let*
      ((arrayparsed (parse-array_ tokens))
       (array (reverse (rest (reverse arrayparsed))))
       (rest-tokens (first (reverse arrayparsed))))
    (list (cons 'jsonarray array) rest-tokens)))

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
            ((is-closedb-t (first next))
             (cons value (parse-array_ next)))
            (t
             (error "array not well formed")))))))


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
      ((is-openc-t token) (parse-object (cdr tokens)))
      ((is-openb-t token) (parse-array (cdr tokens)))
      (t (let ((token (first tokens)))
           (cond ((is-string-t token) (parse-string tokens)) ;; pop
                 ((is-number-t token) (parse-number tokens)) ;; pop
                 (t (error "Invalid JSON value"))))))))


(defun parse-string (tokens)
  (if (and
       (eq (length tokens) 2)
       (stringp (first tokens))
       (string-equal (first tokens) "string-token"))
      (list (second tokens) ())
      ;;ELSE
      (list (second (first tokens)) (cdr tokens))))

(defun parse-number (tokens)
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
  ) ;; token predicate

(defun is-closedb-t (token)
  (string-equal
   (get-token-type token)
   "CLOSEDBRACKET")
  )
(defun is-openc-t (token)
  (string-equal
   (get-token-type token)
   "OPENCURLY")
  )
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

;;;;;;
