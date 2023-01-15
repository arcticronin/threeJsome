----jsonparse.pl---- 

Membri del Gruppo
	[] Manzi Luca 
	851849 Montoli Matteo
	[] Zhou Chengjie 


Sviluppo del codice:
Per sviluppare il codice abbiamo preso come riferimento il libro "Compilers: Principles, Techniques, and Tools by Alfred Aho (Author), Jeffrey Ullman (Author), Ravi Sethi (Author), Monica Lam (Author)", quindi l'approccio utilizzato è top down.
Per questo recursive descent parser siamo partiti identificando i membri più esterni e successivamente abbiamo analizzato quelli più interni.

La struttura utilizzata è quella di creare innanzitutto dei tokens, identificabili: <TOKENTYPE "TOKENCONTENT"> oppure per token semplici, s, ad esempio le parentesi (si vedano le funzioni _____TODO____).
Questa struttura viene chiamata dal parser (jsonparse/2) che che genera l'albero a parire dalla lista. 


Funzioni definite nel file di consegna:

jsonparse/2: jsonparse(JSONString, Object). Risulta vero se JSONString (una stringa SWI Prolog o un atomo Prolog) può venire
scorporata come stringa, numero, o nei termini composti:

Object = jsonobj(Members)
Object = jsonarray(Elements)

e ricorsivamente:
Members = [] or
Members = [Pair | MoreMembers]
Pair = (Attribute, Value)
Attribute = <string SWI Prolog>
Number = <numero Prolog>
Value = <string SWI Prolog> | Number | Object
Elements = [] or
Elements = [Value | MoreElements]

jsonaccess/3: jsonaccess(Jsonobj, Fields, Result). Risulta vero quando Result è recuperabile seguendo la catena di campi presenti in Fields
(una lista) a partire da Jsonobj. Un campo rappresentato da N (con N un numero maggiore o uguale a 0) corrisponde a un indice di un array JSON.

jsonread/2: jsonread(FileName, JSON). Apre il file FileName e ha successo se riesce a costruire un oggetto JSON. Se FileName non esiste il predicato fallisce.

jsondump/2: jsondump(JSON, FileName). Scrive l’oggetto JSON sul file FileName in sintassi JSON. Se FileName non esiste, viene creato e se esiste viene sovrascritto. 


Funzioni definite da noi per la realizzazione del progetto:





