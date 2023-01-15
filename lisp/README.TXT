----jsonparse.lisp---- 

Membri del Gruppo
	[] Manzi Luca 
	851849 Montoli Matteo
	[] Zhou Chengjie 

Sviluppo del codice:
Per sviluppare il codice abbiamo preso come riferimento il libro "Compilers: Principles, Techniques, and Tools by Alfred Aho (Author), Jeffrey Ullman (Author), Ravi Sethi (Author), Monica Lam (Author)", quindi l'approccio utilizzato è top down.
Per questo recursive descent parser siamo partiti identificando i membri più esterni e successivamente abbiamo analizzato quelli più interni.  


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

jsonaccess: che accetta un oggetto JSON (in particolare un jsonobj e un jsonarray) e una serie di
“campi” (denominati fields) che recupera l’oggetto corrispondente. Un campo rappresentato da N (con N un numero
maggiore o uguale a 0) rappresenta un indice di un array JSON.

jsonread: apre il file filename e ritorna un oggetto JSON (o genera un errore).

jsondump: scrive l’oggetto JSON sul file filename in sintassi JSON. Se filename
non esiste, viene creato e se esiste viene sovrascritto.


Funzioni definite da noi per la realizzazione del progetto:


