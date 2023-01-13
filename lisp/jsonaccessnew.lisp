(defun jsonaccess (obj fields)
  (if (null fields) ()
    (error "stringa nulla"))
  (let* (f(if (listp fields ) fields
           (list fields)))
    (jsonaccess-from-list (obj f))))
          

(defun jsonaccess-from-list (obj fields)
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
      (jsonaccess-from-list current (rest fields))))) 