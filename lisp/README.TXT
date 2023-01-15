----jsonparse.lisp---- 

Membri del Gruppo
	856095 Manzi Luca 
	851849 Montoli Matteo
	859246 Zhou Chengjie 

Sviluppo del codice:
Per sviluppare il codice abbiamo preso come riferimento il libro "Compilers: Principles, Techniques, and Tools by Alfred Aho (Author), Jeffrey Ullman (Author), Ravi Sethi (Author), Monica Lam (Author)", quindi l'approccio utilizzato è top down.
Per questo recursive descent parser siamo partiti identificando i membri più esterni e successivamente abbiamo analizzato quelli più interni.  
Abbiamo defintio una funzione per ogni simbolo non terminale e abbiamo utilizzato la ricorsione per iterare sulla lista di token.

--------------------------------------
Funzioni definite nel file di consegna:

jsonparse: accetta in ingresso una stringa e  risulta vero se JSONString (una stringa Lisp) può venire
scorporata come stringa, numero, o nei termini composti:

Object = ’(’ jsonobj members ’)’
Object = ’(’ jsonarray elements ’)’

e ricorsivamente:
members = pair*
pair = ’(’ attribute value ’)’
attribute = <stringa Common Lisp>
number = <numero Common Lisp>
value = string | number | Object
elements = value*

jsonaccess: (jsonaccess obj &rest fields). Accetta un oggetto JSON (in particolare un jsonobj e un jsonarray) e una serie di
“campi” (denominati fields) che recupera l’oggetto corrispondente. Un campo rappresentato da N (con N un numero
maggiore o uguale a 0) rappresenta un indice di un array JSON.

jsonread: (jsonread filename).  Apre il file filename e ritorna un oggetto JSON (o genera un errore).

jsondump: (jsondump JSON filename). Scrive l’oggetto JSON sul file filename in sintassi JSON. Se filename
non esiste, viene creato e se esiste viene sovrascritto.

----------------------------
Funzioni definite da noi:

(defun parse-obj-members (token-list &optional acc)): funzione per il parser di obj e members con input la lista di token e l'accumulatore.

(defun parse-key-value (token-list)): funzione per il parser della coppia chiave-valore con input la lista di token.

(defun pair-return-structure (key value list-to-analyze)): funzione che ritorno la struttura della coppia chiave-valore.

(defun is-valid-triplet (first-el second-el third-el)): funzione per verificare la correttezza della struttura

(defun parse-array-2 (token-list &optional acc)):
  
(defun parse-array-value (value)):

(defun clean-list-to-parse (token-list)): rimuove l'ultima parentesi per lavorare solo su members 

(defun remove-last (l)): rimuove ultima parentesi

(defun trailing-comma (element next)): rimuove ultima virgola

(defun extract-value (value)): estrae valore

----------------------------

Funzioni per la gestione dei token:

(defun get-token-type (token))

(defun is-comma-t (token))
  
(defun is-closedb-t (token))

(defun is-openb-t (token))

(defun is-openc-t (token))

(defun is-closedc-t (token))

(defun is-colon-t (token))

(defun is-string-t (token))

(defun is-number-t (token))

----------------------------------------
Parameter definiti per testare le funzioni:

(defparameter empty-json-object "{}")
(defparameter empty-array-object "[]")

OGGETTI:
(defparameter json-object "{\"nome\" : \"Arthur\",\"cognome\" : \"Dent\"}")
(defparameter json-object-number "{\"nome\" : \"Arthur\",\"cognome\" : \"Dent\", \"eta\" : 19 }")
(defparameter json-object-number-neg "{\"nome\" : \"Arthur\",\"cognome\" : \"Dent\", \"eta\" : -19 }")
(defparameter json-object-number-float "{\"nome\" : \"Arthur\",\"cognome\" : \"Dent\", \"eta\" : 19.5 }")
(defparameter json-object-nested "{\"nome\" : \"Arthur\",\"cognome\" : \"Dent\", \"nestato\" : 
                                    {\"nome\" : \"pino\" \"cognome:\" \"joe\"} }")

(defparameter json-object-array "{\"nome\" : \"Arthur\",\"cognome\" : \"Dent\", \"eta\" : [1,2,3] }")

ARRAY:
(defparameter json-arr "[1, 2, 3]")
(defparameter json-arr-mixed "[1,\"Ciao\" 3]")
(defparameter json-arr-nested "[1, 2, [1, 2, 3]]")
(defparameter json-arr-obj "[1, 2, {\"ciao\" : \"123\"} ]")
(defparameter json-arr-nested-obj "[1, 2, {\"ciao\" : \"123\",\"vino\":{\"cc\":2}}]")


SINTASSI ERRATA:

(defparameter missin-closing "[1, 2, 3")

(defparameter missing-comma "[1, 2 3]")
(defparameter trailing-comma "[1, 2,3,]")
(defparameter wrong-key "{1:2}")
(defparameter missing-column "{\"test\" 2}")


ACCESS:

senza il parser:
;String
(defparameter x '(jsonobj ("nome" "arthur") ("cognome" "dent")))
;String e Array 
(defparameter z '(jsonobj ("name" "zaphod") ("heads" (jsonarray (jsonarray "head1") (jsonarray "head2")))))

con parser:
(defparameter x (jsonparse "{\"nome\" : \"Arthur\", \"cognome\" : \"Dent\"}"))
(defparameter z (jsonparse "{\"name\" : \"Zaphod\", \"heads\" : [[\"Head1\"], [\"Head2\"]]}"))
