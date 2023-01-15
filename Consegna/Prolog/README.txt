----jsonparse.pl---- 

Membri del Gruppo
	856095 Manzi Luca 
	851849 Montoli Matteo
	859246 Zhou Chengjie 


Sviluppo del codice:
Per sviluppare il codice abbiamo preso come riferimento il libro "Compilers: Principles, Techniques, and Tools by Alfred Aho (Author), Jeffrey Ullman (Author), Ravi Sethi (Author), Monica Lam (Author)", quindi l'approccio utilizzato è top down.
Per questo recursive descent parser siamo partiti identificando i membri più esterni e successivamente abbiamo analizzato quelli più interni.
Per sviluppare il codice abbiamo preso come riferimento il libro "Compilers: Principles, Techniques, and Tools by Alfred Aho (Author), Jeffrey Ullman (Author), Ravi Sethi (Author), Monica Lam (Author)", quindi l'approccio utilizzato è top down.
Per questo recursive descent parser siamo partiti identificando i membri più esterni e successivamente abbiamo analizzato quelli più interni.  
La struttura utilizzata è quella di creare innanzitutto dei tokens, identificabili:

<TOKENTYPE TOKENCONTENT>

Per i tokens che hanno un contenuto: stringhe, numeri.

Oppure

<TOKENTYPE> per token semplici, come le parentesi. 

Dalla lista di token usare una funzione parse che genera l'albero corrispondente a parire dalla
lista.

NOTE:

I numeri in prolog sono stati implementati a mano: Legge solo interi.

 è stato scelto di non usare un parsenumber, ma poteva essere stata anche fatta allo stesso modo del predicato string: raggruppare i caratteri a partire dai segni e poi chiamare un parsenumber(S N)

un predicato tab(I, String)
è stato creato per tabulare l'output, però è stato rimosso in quanto, su ricerche sulla giusta tabulazione di una stringa json, è venuto fuori che è stata ideata per essere più compatta possibile. 

Il jsonaccess non ha ! per provare a trovare più di un match.

--------------------------------------
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

-------------------------------
Funzioni definite da noi per la realizzazione del progetto:

tokens_jsonobj/2

tokens_members_rest/3

tokens_pair_rest/3

tokens_value_res/3

tokens_elements_rest/3,

string_tokens/2

codes_tokens/2: funzione base per trasformare da codice a token

codes_number_/3

collapse_whitespaces/2: rimuove tutti gli spazi bianchi

write_members/2

-----------------------------------------------
Definizione di predicati:

tokenizefile/1

is_string_delimiter/1

codes_stringtoken/1

is_whitespace/1

write_elements/2

tab/2
-------------------------------------
Test utilizzati:

test1(O, R):-
    jsonparse('{"nome" : "Arthur", "cognome" : "Dent"}', O),
    jsonaccess(O, ["nome"], R).

test2(O, R):-
    jsonparse('{"nome": "Arthur", "cognome": "Dent"}', O),
    jsonaccess(O, "nome", R).

test3(Z,R):-
    jsonparse('{"nome" : "Zaphod",
    "heads" : ["Head1", "Head2"]}', Z),
    jsonaccess(Z, ["heads", 1], R).

test4(R):-
    jsonparse('{"nome" : "Arthur", "cognome" : "Dent"}', JSObj),
    jsonaccess(JSObj, ["cognome"], R).
