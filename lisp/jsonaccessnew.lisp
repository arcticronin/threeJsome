

(defun jsonaccess obj &rest key
  (jsonaccess_ obj key)
)




; (defun jsonaccess (obj fields)
;   (if (stringp fields)
;       (jsonaccess_ obj (list fields))
;     (jsonaccess_ obj fields)))

; (defun string-to-list (x)
;   (if (stringp x)
;       (list x)
;     x))
          

(defun jsonaccess_ (obj fields)
  (if (null fields)
      obj
    (let* ((cur-key (first fields))
           (current (cond ((and (integerp cur-key) 
                                (eq (first obj) 'jsonarray))
                           (nth (+ cur-key 1) obj)) 
                          ((and (stringp cur-key) 
                                (eq (first obj) 'jsonobj))
                           (second (assoc cur-key (rest obj) :test #'string=)))
                          (t (error "not a JSON object or array or not appropriate key" obj cur-key)))))
      (jsonaccess_ current (rest fields))))) 

;chiamata corretta
(defun j (obj &rest fields)
  (jsonaccess_ obj fields)
)

