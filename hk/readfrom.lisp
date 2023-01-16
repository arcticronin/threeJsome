

(defun parse-json (tokens)
  (cond ((eq (car tokens) '{) (parse-object (cdr tokens)))
        ((eq (car tokens) '[) (parse-array (cdr tokens)))
        (t (error "Invalid JSON"))))

(defun parse-object (tokens)
  (cond ((null tokens) (error "Missing closing '}'"))
        ((eq (car tokens) '}) '())
        (t (let ((key-value (parse-key-value (car tokens))))
             (cons key-value (parse-object (cdr tokens)))))))

(defun parse-key-value (token)
  (let ((key (parse-string (car token)))
        (value (parse-value (cadr token))))
    (cons key value)))

(defun parse-array (tokens)
  (cond ((null tokens) (error "Missing closing ']'"))
        ((eq (car tokens) ']) '())
        (t (cons (parse-value (car tokens)) (parse-array (cdr tokens))))))

(defun parse-string (token)
  (subseq token 1 (1- (length token))))

(defun parse-value (token)
  (cond ((stringp token) (parse-string token))
        ((numberp token) (parse-number token))
        ((eq token 'true) t)
        ((eq token 'false) nil)
        ((eq token 'null) nil)))

(defun parse-number (token)
  (if (find #\e token)
      (parse-float token)
    (parse-integer token)))






;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun parse-json (tokens)
  (cond
    ((is-openc-t (car tokens)) (parse-object (cdr tokens)))
    ((is-openb-t (car tokens)) (parse-array (cdr tokens)))
    (t (error "Invalid JSON format"))
  ))

(defun parse-object (tokens)
  (if (is-closedc-t (car tokens))
    '()
    (let ((key (car tokens))
          (value (parse-value (cdr (cdr tokens))))
          (rest (parse-object (cddr (cdr tokens)))))
      (cons (cons (second key) value) rest)
    )
  ))

(defun parse-array (tokens)
  (if (is-closedb-t (car tokens))
    '()
    (let ((value (parse-value (car tokens)))
          (rest (parse-array (cdr tokens))))
      (cons value rest)
    )
  ))

(defun parse-value (tokens)
  (let ((token (car tokens)))
    (cond
      ((is-string-t token) (second tokens))
      ((is-number-t token) (second tokens));(cadr tokens)))
      ;; ((eq token 't) t)
      ;; ((eq token 'f) nil)
      ((is-openc-t token) (parse-object (cdr tokens)))
      ((is-openb-t token) (parse-array (cdr tokens)))
      (t (error "Invalid JSON value"))
    )
  )
)



