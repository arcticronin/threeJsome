(defparameter k '(
                 ("string-token" "nome") "COLON"
                  ("string-token" "Arthur") "CLOSEDCURLY"))

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
;;jsonarray =  | (jsonarray elements)
;;
;;elements =    | (Value | values)
;;              | ()
;;
;;members=  | ()
;;          | (Pair | MoreMembers)
;;
;;Pair=     | (Id value)
;;
;;
;;value=    |string
;;          |number
;;          |object



;; funzione che viene chiamata per prima. prende il risultato di tutto
;; poi dovrò controllare che rest sia vuoto e così l'oggetto è ben formato
(defun json-parse (tokens)
  (let*   ((o-r (parse-obj tokens))
          (obj (first o-r))  ;; 2 casi --> array, obj --->> tutto / oppuper rimuover il primo ..> tokens
           ;;                                                                                 ..> (cdr tokens)
          (rest-tokens (second o-r)))
     (list obj rest-tokens))
  )


;; > sposta check su, solo obj
(defun parse-obj (tokens) ;; --> object rest
  ;;                                        |--> (list (jsonarray roba) rest-tokens) NOOOOO
  ;;                                        |--> (list (jsonobj roba) rest-tokens)
        (cond
            ((null tokens)
             (error "eof before parsing object"))
            ((is-openc-t (first tokens))
             (let* ((m-r (parse-members (rest tokens) ))
                    (members (first m-r))
                    (rest (second m-r)))
               (and (write "parsed obj -> jsonobj")
                    (list
                     (list 'jsonobj members)
                     rest))))
            ((is-openb-t (first tokens))
             (let* ((e-r (parse-array )) ;; dai un occhio
                    (array (first e-r))
                    (rest (second e-r)))
               (and (write "parsed array -> jsonarray")
                    (list
                     (list 'jsonarray array)
                     rest)))
            (T (error "error in parsing object"))))


(defun parse-members (tokens) ;; --> (members rest-of-tokens)
  (if (>= (length tokens) 1)
      (let*  ((token (first tokens)))
        (cond
          ((is-closedc-t token)
           (and (write "end of obj"))
           (list () (cdr tokens))) ;; return emtpy members and tokens except first
          (T
           (parse-pairs tokens))))));; parse pair starting with an empty pair

(defun parse-pairs (tokens) ;; --> (pairs rest-of-tokens)
  (parse-pairs-2 () tokens))) ;; giusto per non chimaare titte le olte
;; (parse-pairs  ()  tokens  )

(defun parse-pairs-2 (pairs tokens)
  ;; it creates the pair list, checkes rest of the tokens
  ;; from the parse-pair fn
  (let* ((p-r (parse-pair-rest tokens))
         (pair (first p-r))
         (rest-tokens (second p-r)))
    (cond
      ((is-closedc-t (first rest-tokens)) ; --> base case, returning list of pairs, tokens
       (list pairs tokens)) ;; -> ((list of pairs) (rest of the tokens))
       ;;remove or not the }, let's see
      ((is-comma-t (first rest-tokens))
       (parse-pairs-2
        (append pairs (list 'pair pair)) ;; to debug, later can be removed
        (cdr rest-tokens) ;; remove comma and go on, trying to reach the base case (})
        ))
      (T
       (error "im here in the parse pair 2, i have to check some things"))
      )))

;;;; non la uso
;;;;
;pair = (id value)
(defun parse-pair-rest(tokens) ;; --> ( (id value) rest-of-tokens)
  (if (and
       (is-string-t (first tokens))
       (is-colon-t (second tokens)))
      (let*
          ((id (second (first tokens)))
           (v-r (parse-value-rest (cddr tokens)))
           (value (first v-r))
           (rest-tokens (second v-r)))
        (list (list id value) rest-tokens))
      (error "parse-pair-rest error, not in format (id : value)")))





;; at least 2 values, cause i need to close the parenthesis later,
;; and it also gives me error on get-token-type
;;
;; try to return rest or implement a 2 cases switch in case
;; of values in an array, or in a member
;;
;;remove t-type from left, and use a (is-openb token) etc, but later

(defun parse-value-rest (tokens) ;; TIP use a let to bind first-token
  (if (>= (length tokens) 1)
      (let* ((token (first tokens)))
         (cond
           ((is-openc-t token)
            (write "chiamata parse-obj"))
           ((is-openb-t token)
            (write "chiamata parse-array"))
           ((or
             (is-string-t token)
             (is-number-t token))
            (and (write "mi esce il value base")
                 (list (second token) (rest tokens))))
           (T (error "error while parsing value"))))
      (error "eol reached while parsing value")))


(defun parse-elements (tokens)
  (parse-elements_2 () tokens))
;;parse elements
;;
;;--> ((element-list), rest)
(defun parse-elements_2 (elements tokens) ; farla come la parsemembers
  (let ((first-token (first tokens)))
    (cond
      ((null first-token)
       (error "reached eof while parsing a jsonarray"))
      ((string-equal first-token "CLOSEDBRACKET")
       (list elements tokens)); return elements and rest of tokens
                             ; TODO manage ], yes or no?
      (let* ((v-r (parse-value-rest))
             (value (first v-r))
             (rest (second v-r)))
        (cond
          ((is-closedb-t (first rest))
           (list elements tokens)) ;; manage ]
          (parse-elements_2
           (append elements element)
           rest)
          )
        )
      (T
       (error "unexpected object while parsing an array")) ;; parse-error
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

;;



(defun jsonaccess (json &rest args)
      (jsonaccess_ json args))

(defun jsonaccess (json x)
  (if (stringp x)
      (jsonaccess_ json (list x))
      (jsonaccess_ json x)))

(defun string-to-list (x)
  (if (stringp x)
      (list x)
      x)
  )

(defun xx (&rest y)
  y)
