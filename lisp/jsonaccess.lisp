;;; is-digit
;;; carattere char-list e' una cifra
(defun is-digit (char-list) 
  (or (eq char-list #\0) 
          (eq char-list #\1)
          (eq char-list #\2)
          (eq char-list #\3)
          (eq char-list #\4)
          (eq char-list #\5)
          (eq char-list #\6) 
          (eq char-list #\7)
          (eq char-list #\8)
          (eq char-list #\9)))


;;; definisco la funzione jsonaccess
(defun jsonaccess (chars &optional (number))
  (cond

;;; controllo i caratteri  
   ((or (is-digit (first chars))
      (eql (first chars) #\-)
      (eql (first chars) #\+))
    (jsonaccess (rest chars) (extend-number (first chars) number)))

;;; no punto
   ((and (not (null number))
              (eql (first chars) #\.)
              (not (contains-dot number)))
    (jsonaccess (rest chars) (extend-number (first chars) number)))

;;; number non nullo e ultimo carattere non punto             
    ((and (not (null number))                      
          (not (eql #\. (first (reverse chars)))))

     (cons (list-to-number number) chars))
           
;;; stampa errore altrimenti        
   (t 
    (error "ERROR: Not a correct number."))))