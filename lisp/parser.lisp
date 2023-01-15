(defparameter k '(
                 ("string-token" "nome") "COLON"
                  ("string-token" "Arthur") "CLOSEDCURLY"))

(defparameter j '("OPENCURLY"
                 ("string-token" "nome") "COLON" ("string-token" "Arthur") "COMMA"
                 ("string-token" "cognome") "COLON" ("string-token" "Dent") "COMMA"
                 ("string-token" "eta") "COLON" ("number-token" 19) "CLOSEDCURLY"))

(defparameter c '("OPENCURLY"
                 ("string-token" "nome") "COLON" ("string-token" "JOE") "COMMA"  ("string-token" "cognome") "COLON" ("string-token" "Dent") "CLOSEDCURLY" ))                 


(defparameter pino '("OPENCURLY"
                 ("string-token" "nome") "COLON" ("string-token" "Arthur") "COMMA"
                 ("string-token" "cognome") "COLON" ("string-token" "Dent") "COMMA"
                 ("string-token" "eta") "COLON" ("number-token" 19) "COMMA" 
                 ("string-token" "nested") "COLON" "OPENCURLY" ("string-token" "nome") "COLON" ("string-token" "Arthur") "CLOSEDCURLY" "CLOSEDCURLY"))
(defparameter pino-2 '("OPENCURLY"
                 ("string-token" "nome") "COLON" ("string-token" "Arthur") "COMMA"
                 ("string-token" "cognome") "COLON" ("string-token" "Dent") "COMMA"
                 ("string-token" "eta") "COLON" ("number-token" 19) "COMMA" 
                 ("string-token" "nested") "COLON" "OPENBRACKET" ("string-token" "vino") "CLOSEDBRACKET" "CLOSEDCURLY"))

(defparameter empty-arr '("OPENBRACKET" "CLOSEDBRACKET"))

(defparameter arr-simple '("OPENBRACKET" ("number-token" 10) "COMMA" ("string-token" "Arthur") ("string-token" "JOE") "CLOSEDBRACKET"))

(defparameter arr-nested-obj '("OPENBRACKET" ("number-token" 10) "COMMA" ("string-token" "Arthur") "OPENCURLY"("string-token" "neste nest") "COLON" ("string-token" "Arthur") "COMMA" 
  ("string-token" "eta") "COLON" ("number-token" 10) "CLOSEDCURLY" "CLOSEDBRACKET"))

(defparameter arr-nested-arr '("OPENBRACKET" "OPENBRACKET" ("number-token" 1) "COMMA" ("string-token" "gino") "CLOSEDBRACKET" "CLOSEDBRACKET"))


(defparameter valid-value-brackets '("OPENCURLY" "OPENBRACKET"))
;;
(defparameter emptytok '("OPENCURLY" "CLOSEDCURLY"))
;; (parser(tokens) -> ( ( rest-of-tokens ) ( parsedvalue )) )
;;
(defparameter val '(("string-token" ciao) "CLOSEDBRACKET"))

(defparameter json-object-type 'jsonobj)
(defparameter json-array-type 'jsonarray)

(defparameter compound-tokens '("string-token" "number-token"))
(defparameter simple-tokens '("OPENCURLY" "CLOSEDCURLY" "OPENBRACKET" "CLOSEDBRACKET" "COMMA" "COLON"))


(defparameter v '("OPENCURLY"
                 ("string-token" "nome") "COLON" ("string-token" "Arthur") "CLOSEDCURLY" ))   

(defun json-parse (tokens) 
  (let ((head (first tokens)) 
        (tail (rest tokens))
        (last-element (car 
                       (last tokens)))) 
 
    (cond ((and (is-openc-t head) 
                (is-closedc-t last-element))
           (append (list json-object-type) 
                   (parse-obj-members 
                    (clean-list-to-parse tail))))
 
          ((and (is-openb-t head) 
                (is-closedb-t last-element))
           (append (list json-array-type) 
                 (parse-array
                  (clean-list-to-parse tail)))) 
          (T (error "MALFORMED OBJEECT -1")))))

(defun parse-obj-members (token-list &optional acc) 
  (let ((head (first token-list)) 
        (tail (rest token-list)))
    (if (null token-list) 
        (append acc 
                token-list)
     ;;;ELSE
      (cond 
       ((and (is-string-t head)
             (null acc)) 
        (let ((parsed-key-val 
               (parse-key-value token-list)))
          (parse-obj-members 
           (cadr parsed-key-val) 
           (append acc 
                   (list (car parsed-key-val))))))
       ;;;FIRST CASE -> ",A"
       ((and (is-comma-t head) 
             (null acc)) 
        (error "MALFORMED OBJECT -2"))
       ;;SECOND CASE -> "A:B,"
       ((trailing-comma head tail) 
        (error "TRAILING COMMA"))
              
       (T 
        ;;; PARSED-KEY-VAL È di questo tipo -> (CIAO MOTO) (REST TO ANALYZE)
        (let ((parsed-key-val 
               (parse-key-value tail)))
          (parse-obj-members 
           (cadr parsed-key-val) 
           (append acc
                   (list (car parsed-key-val))))))
       )
      ) 
))

 ;;; TODO provare a mterre cddr e non subseq
(defun parse-key-value (token-list) 
  (let ((key (first token-list)) 
        (colon (second token-list))
        (value (third token-list))
        (tail-list (cdddr token-list)))

    (cond ((not (is-valid-triplet key 
                                  colon
                                  value)) 
           (error "MALFORMED OBJECT"))

          ((is-simple-value value) 
           (pair-return-structure (extract-value key)
                                  (extract-value value) 
                                  tail-list)
           )
          (T (let ((complex-value (parse-complex-value
                                   tail-list value))) 
               (pair-return-structure (extract-value key) 
                                      (first complex-value) 
                                      (cadr complex-value))
               )
             )
          )
  )
)


(defun pair-return-structure (key value list-to-analyze) 
  (list (list key value) 
        list-to-analyze))


(defun is-valid-triplet (first-el second-el third-el) 
  (and (is-string-t first-el) 
       (is-colon-t second-el) 
       (or (is-string-t third-el) 
           (is-number-t third-el)
           (is-openc-t  third-el)
           (is-openb-t third-el)
           )))



;;; CHECKS IF VALUE IS A STRING OR NUMBER
(defun is-simple-value (value) 
  (or (is-string-t value) 
      (is-number-t value)))

;;; GIVEN THE TOKEN LIST AND GIVEN THE PARENTHESIS
;; RETURNS A LIST (STRINGIFIED VALUE , LIST TO WORK ON)
(defun parse-complex-value (token-list parenthesis) 
  (if (is-openc-t parenthesis) 
      (parse-object-value token-list)
    (parse-array-value token-list))
  )

;;;"  ("string-token" "nome") "COLON" ("string-token" "Arthur") "
(defun parse-object-value (tokens &optional acc) 
  (let ((head (first tokens)) 
        (tail (rest tokens))) 
    (if (is-closedc-t head)
        ;;Base case 
        (list (append (list json-object-type) 
                      (parse-obj-members (append acc
                                                 nil)))
              tail
              )
      ;;;RECURSIVE
      (parse-object-value tail 
                          (append acc 
                                  (list head)))))
)

(defun parse-array-value (tokens &optional acc) 
  (let ((head (first tokens)) 
        (tail (rest tokens))) 
    (if (is-closedb-t head)
        ;;Base case 
        (list (append (list json-array-type) 
                      (parse-array (append acc
                                             nil)))
              tail)
      ;;;RECURSIVE
      (parse-array-value tail 
                          (append acc 
                                  (list head)))))
)


(defun parse-array (token-list &optional acc) 
  (let ((head (first token-list)) 
        (tail (rest token-list)))
    (if (null token-list) 
        (append acc token-list)
  (cond        
   ((and (is-comma-t head) 
         (null acc)) 
    (error "MALFORMED OBJECT -2"))
   ((trailing-comma head 
                    tail) 
    (error "TRAILING COMMA"))
   ((is-comma-t head) (parse-array tail
                                     acc))

   ((or (is-openb-t head) 
        (is-openc-t head)) 
    (let ((complex-value (parse-complex-value
                          tail
                          head))) 
      (parse-array (cadr complex-value) 
                     (append acc
                             (list (first
                                    complex-value))))
      ) 
    )
   (T (parse-array tail 
                     (append acc
                             (list (parse-array-simple-value head)))))))
                             ))
  
  
(defun parse-array-simple-value (value)
  (cond ((is-simple-value value) (extract-value value))
        (T (error "MALFORMED ARRAY"))
        ))


;;; Given a token list removes the last bracke in order to work only on members
(defun clean-list-to-parse (token-list) 
  (remove-last token-list))

(defun remove-last (l)
  (reverse (rest (reverse l))))


(defun trailing-comma (element next) 
  (and (is-comma-t element)
       (null next)))

(defun extract-value (value) 
  (cadr value))

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


