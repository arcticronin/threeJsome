(defparameter k '(
                 ("string-token" "nome") "COLON" ("string-token" "Arthur") "CLOSEDCURLY" ))

(defparameter j '("OPENCURLY"
                 ("string-token" "nome") "COLON" ("string-token" "Arthur") "COMMA"
                 ("string-token" "cognome") "COLON" ("string-token" "Dent") "COMMA"
                 ("string-token" "eta") "COLON" ("number-token" 19) "CLOSEDCURLY" ))
(defparameter v '("OPENCURLY"
                 ("string-token" "nome") "COLON" ("string-token" "Arthur") "CLOSEDCURLY" ))                 


(defparameter compound-tokens '("string-token" "number-token"))
(defparameter simple-tokens '("OPENCURLY" "CLOSEDCURLY" "OPENBRACKET" "CLOSEDBRACKET" "COMMA" "COLON"))
;;
(defparameter emptytok '("OPENCURLY" "CLOSEDCURLY"))
;; (parser(tokens) -> ( ( rest-of-tokens ) ( parsedvalue )) )
;;
(defparameter val '(("string-token" ciao) "CLOSEDBRACKET"))

;; KEY:
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
             (and (write "parsed mainobj -> it's an obj")
                  (list 'jsonobj (parse-members (cdr tokens)))))
            ((string-equal (first tokens) "OPENBRACKET")
             (and (write "parsed mainobj -> it's an array")
                  (list 'jsonarray (parse-members (cdr tokens)))))
            (T (error "error in parsing main Jsonobj"))))

(defun parse-obj (tokens)
        (cond
            ((null tokens)
             (error "eof before parsing object"))
            ((string-equal (first tokens) "OPENCURLY")
             (and (write "parsed obj -> jsonobj")
                  (list 'jsonobj
                        (parse-members (cdr tokens))
                        )))
            (T (error "error in parsing Jsonobj"))))


(defun parse-members (tokens)
  (if (>= (length tokens) 1)
      (let*  ((token (first tokens)))
        (cond
          ((is-closedc-t token)
           (and (write "end of obj"))
           (list () (cdr tokens))) ;; return emtpy members and tokens except first
          (T
           (parse-pairs tokens))))));; parse pair starting with an empty pair

(defun parse-pairs (tokens)
  (parse-pairs-2 ( () tokens ))) ;; giusto per non chimaare titte le olte
;; (parse-pairs  ()  tokens  )

(defun parse-pairs-2 (pairs tokens)
  ;; it creates the pair list, checkes rest of the tokens
  ;; from the parse-pair fn
  (let* ((p-r (parse-pair-rest tokens))
         (pair (first p-r))
         (rest (second p-r)))
    (cond
      ((is-closedc-t (first rest)) ; --> base case, returning list of pairs, tokens
       (pairs tokens) ;; -> ((list of pairs) (rest of the tokens))
       ;;remove or not the }, let's see
       ((is-comma-t (first rest)))
       (parse-pairs-2
        (append pairs pair)
        (cdr rest) ;; remove comma and go on, trying to reach the base case (})
        )
       (T
        (error "im here in the parse pair 2, i have to check some things"))
      ))))



(defun parse-pair-rest(tokens) ;; --> ( (id value) rest-of-tokens)
  (if (and
       (is-string-t (first token))
       (is-colon-t (second tokens)))
      (let*
          ((id (second (first-token)))
           (v-r (parse-value-rest))
           (value (first v-r))
           (rest (second v-r)))
        ((list
          (list id value)
          rest)))
      (error "parse-pair-rest error, not in format (id : value)")
      ))



(defun parse-value2(tk1) ; -> (value rest)
  tk1)

(defun parse-value (tokens) ;; TIP use a let to bind first-token

;; at least 2 values, cause i need to close the parenthesis later,
;; and it also gives me error on get-token-type
;;
;; try to return rest or implement a 2 cases switch in case
;; of values in an array, or in a member
;;
;;remove t-type from left, and use a (is-openb token) etc, but later
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
    )))


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
