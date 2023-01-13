(defparameter j '("OPENCURLY"
                 ("string-token" "nome") "COLON" ("string-token" "Arthur") "COMMA"
                 ("string-token" "cognome") "COLON" ("string-token" "Dent") "COMMA"
                 ("string-token" "eta") "COLON" ("number-token" 19) "CLOSEDCURLY" ))

(defparameter compound-tokens '("string-token" "number-token"))
(defparameter simple-tokens '("OPENCURLY" "CLOSEDCURLY" "OPENBRACKET" "CLOSEDBRACKET" "COMMA" "COLON"))
;; do one thing and do it well
;;
(defparameter emptytok '("OPENCURLY" "CLOSEDCURLY"))
;; (parser(tokens) -> ( ( rest-of-tokens ) ( parsedvalue )) )
;;
(defparameter val '(("string-token" ciao) "CLOSEDBRACKET"))

;; first parse object, the rest must be [] at the end
(defun parse-main-obj (tokens) ;; refactor with get-token-type
           (cond
            ((null tokens)
             (error "eof before parsing main object"))
            ((string-equal (first tokens) "OPENCURLY")
             (and (write "parsed mainobj -> obj")
                  (cons 'jsonobj (parse-members (cdr tokens)))))
            ((string-equal (first tokens) "OPENBRACKET")
             (and (write "parsed mainobj -> arr")
                  (cons 'jsonarray (parse-members (cdr tokens)))))
            (T (error "error in parsing main Jsonobj"))))


;; parse value
(defun parse-members (tokens) ;; TIP use a let to bind first-token
;; at least 2 values, cause i need to close the parenthesis later,
;; and it also gives me error on get-token-type
  (if (>= (length tokens) 1)
      (let*  ((token (first tokens))
              (t-type (get-token-type token)))
        (cond
          ((string-equal t-type "CLOSEDCURLY" )
           (and (write "end of obj"))
           ())
          ((not (string-equal (get-token-type (second tokens)) "COLON" ))
           (error "unexpected separator during member parsing"))
          ((string-equal (get-token-type (second tokens)) "COLON")
           (and
            (string-equal t-type "string-token" )
            (write "members -> value") ;; check for null? here on in value?
            (list 'pair (second token) 'parsefrom (cdddr tokens))))
          (T
           (error "error while parsing object"))))
      (error "eol reached while parsing value")))



;;
  ;; parse value
(defun parse-value (tokens) ;; TIP use a let to bind first-token
;; at least 2 values, cause i need to close the parenthesis later,
;; and it also gives me error on get-token-type
  (if (>= (length tokens) 1)
      (let* ((token (first tokens))
              (t-type (get-token-type token)))
         (cond
           ((string-equal t-type "OPENCURLY" )
            (write "chiamata parse-obj"))
           ((string-equal t-type "OPENBRACE" )
            (write "chiamata parse-array"))
           ((string-equal t-type "string-token") ;; TODO same outcome : unify onto same case
            (and (write "mi esce") (second token)))
           ((string-equal t-type "number-token")
            (and (write "mi esce") (second token)))
           (T (error "error while parsing value"))))
      (error "eol reached while parsing value")))


;;parse elements
(defun parse-elements (tokens)
(let (first-token (first tokens))
  (cond
    ((null first-token)
     (error "reached eof while parsing a jsonarray"))
    ((string-equal first-token "CLOSEDBRACKET")
     ()); return empty list
    (()()) ;; parse-element in case of {
    (()()) ;; parse-value in case of value
    ((T)(error "unexpected object while parsing an array")) ;; parse-error
    ))


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
