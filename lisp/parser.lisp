(defparameter k '(
                 ("string-token" "nome") "COLON" ("string-token" "Arthur") "CLOSEDCURLY" ))

(defparameter j '("OPENCURLY"
                 ("string-token" "nome") "COLON" ("string-token" "Arthur") "COMMA"
                 ("string-token" "cognome") "COLON" ("string-token" "Dent") "COMMA"
                 ("string-token" "eta") "COLON" ("number-token" 19) "CLOSEDCURLY" ))

(defparameter compound-tokens '("string-token" "number-token"))
(defparameter simple-tokens '("OPENCURLY" "CLOSEDCURLY" "OPENBRACKET" "CLOSEDBRACKET" "COMMA" "COLON"))
;;
(defparameter emptytok '("OPENCURLY" "CLOSEDCURLY"))
;; (parser(tokens) -> ( ( rest-of-tokens ) ( parsedvalue )) )
;;
(defparameter val '(("string-token" ciao) "CLOSEDBRACKET"))

;; KET:
;; do one thing and do it well
;;
;;one function for each grammar rule
;;
;;main obj =| (jsonobj Members)
;;          | (jsonarray Elements)
;;
;;object =  | (jsonobj Members)
;;
;;
;;members=  | ()
;;          | (Pair | MoreMembers)
;;
;;Pair=     | (Id value)
;;
;;Att=      |(second token) ;; che sarebbe la stringa
;;
;;value=    |string
;;          |number
;;          |object


;; first parse object, the rest must be [] at the end
(defun parse-main-obj (tokens) ;; refactor with get-token-type
           (cond
            ((null tokens)
             (error "eof before parsing main object"))
            ((string-equal (first tokens) "OPENCURLY")
             (and (write "parsed mainobj -> obj")
                  (list 'jsonobj (parse-members (cdr tokens)))))
            ((string-equal (first tokens) "OPENBRACKET")
             (and (write "parsed mainobj -> arr")
                  (list 'jsonarray (parse-members (cdr tokens)))))
            (T (error "error in parsing main Jsonobj"))))

(defun parse-obj (tokens)

  )

(defun parse-members (tokens)
  (if (>= (length tokens) 1)
      (let*  ((token (first tokens))
              (t-type (get-token-type token)))
        (cond
          ((string-equal t-type "CLOSEDCURLY" )
           (and (write "end of obj"))
           ())
          ((not (string-equal (get-token-type (second tokens)) "COLON" ))
           (error "unexpected separator during member parsing"))
          ((and
            (string-equal (get-token-type (second tokens)) "COLON")
            (string-equal t-type "string-token" ))
           (and
            (write "members -> value") ;; check for null? here on in value?
            ;(list (list 'pair (second token) (list 'parsefrom (cddr tokens))))
            (let* (
                   (result (parse-value (cddr tokens)))
                   (tail (second result))
                   (first-pair  (list
                                 'pair
                                 (second token)
                                 (first result)))
                   )
              (let* next (
                          (cond
                            ((is-comma-t (first tail))())
                            ((is-closedb-t)(first tail)())
                            )

                          )
               if (is-comma-t (first tail )) ;; in case I have a comma
               (list
                first-pair
                (parse-members (cdr tail)) ;; skip a comma and try to parse new member
               )
               (list
                first-pair
            ))
          (T
           (error "error while parsing object"))))
      (error "eol reached while parsing value"))))))



(defun parse-pair()



  )

(defun parse-key ()



  )


(defun parse-value2(tk1) ; -> (value rest)
  tk1)

(defun parse-value (tokens) ;; TIP use a let to bind first-token

;; at least 2 values, cause i need to close the parenthesis later,
;; and it also gives me error on get-token-type
;;
;; try to return rest or implement a 2 cases switch in case
;; of values in an array, or in a member
  (if (>= (length tokens) 1)
      (let* ((token (first tokens))
              (t-type (get-token-type token)))
         (cond
           ((string-equal t-type "OPENCURLY" )
            (write "chiamata parse-obj"))
           ((string-equal t-type "OPENBRACE" )
            (write "chiamata parse-array"))
           ((or(string-equal t-type "string-token")
               (string-equal t-type "number-token"))
            (and (write "mi esce") (list (second token) (rest tokens))))
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
