# threeJsome

La specifica dell'idea di implementazione è definita nel readme di Lisp

in breve è stato deciso di 
usare prima un tokenizer per avere una lista di:

<TOKENTYPE "TOKENCONTENT">

Per i tokens che hanno un contenuto: stringhe, numeri.

Oppure

<TOKENTYPE> 

per token semplici, come le parentesi. 

creando poi un predicato base per ogni regola grammaticale con diversi pattern matching per le diverse opzioni per le derivazioni.

Dalla lista di token usare una funzione parse che genera l'albero a parire dalla lista.


I file sono stati divisi, per rendere privati i predicati   

tokenizer esporta
%string_tokens/2 (just for debug here)

%% from parser
%jsonparse/2
%jsonaccess/3

%% from file_io
%jsondump/2
%jsonread/2

NOTE:

I numeri in prolog sono stati implementati a mano: Legge solo interi.

 è stato scelto di non usare un parsenumber, ma poteva essere stata anche fatta allo stesso modo del predicato string: raggruppare i caratteri a partire dai segni e poi chiamare un parsenumber(S N)

un predicato tab(I, String)
è stato creato per tabulare l'output, però è stato rimosso in quanto, su ricerche sulla giusta tabulazione di una stringa json, è venuto fuori che è stata ideata per essere più compatta possibile. 

Il jsonaccess non ha ! per provare a trovare più di un match.
