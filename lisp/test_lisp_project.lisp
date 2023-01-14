(defparameter empty-json-object "{}")
(defparameter empty-array-object "[]")
;;;OGGETTI
(defparameter json-object "{\"nome\" : \"Arthur\",\"cognome\" : \"Dent\"}")
(defparameter json-object-number "{\"nome\" : \"Arthur\",\"cognome\" : \"Dent\", \"eta\" : 19 }")
(defparameter json-object-number-neg "{\"nome\" : \"Arthur\",\"cognome\" : \"Dent\", \"eta\" : -19 }")
(defparameter json-object-number-float "{\"nome\" : \"Arthur\",\"cognome\" : \"Dent\", \"eta\" : 19.5 }")
(defparameter json-object-nested "{\"nome\" : \"Arthur\",\"cognome\" : \"Dent\", \"nestato\" : 
                                    {\"nome\" : \"pino\" \"cognome:\" \"joe\"}")

(defparameter json-object-array "{\"nome\" : \"Arthur\",\"cognome\" : \"Dent\", \"eta\" : [1,2,3] }")

;;;ARRAY
(defparameter json-arr "[1, 2, 3]")
(defparameter json-arr-mixed "[1,\"Ciao\" 3]")
(defparameter json-arr-nested "[1, 2, [1, 2, 3]]")
(defparameter json-arr-obj "[1, 2, {\"ciao\" : \"123\"} ]")
(defparameter json-arr-nested-obj "[1, 2, {\"ciao\" : \"123\",\"vino\":{\"cc\":2}}]")


;;; SINTASSI ERRATA

(defparameter missin-closing "[1, 2, 3")

(defparameter missing-comma "[1, 2 3]")
(defparameter trailing-comma "[1, 2,3,]")
(defparameter wrong-key "{1:2}")
(defparameter missing-column "{\"test\" 2}")



;;; test per jsonaccess (senza il parser)
;stringa
(defparameter x '(jsonobj ("nome" "arthur") ("cognome" "dent")))
;stringa e array 
(defparameter z '(jsonobj ("name" "zaphod") ("heads" (jsonarray (jsonarray "head1") (jsonarray "head2")))))
