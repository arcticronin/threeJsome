# threeJsome


Struttura generale:

La struttura scelta per implementare i progetti è presa dal libro:
compilers - principles techniques and tools.

Segue una struttura top down, nota come un recursive descent parser.

la struttura utilizzata è quella di creare innanzitutto dei tokens, identificabili:

<TOKENTYPE TOKENCONTENT>

Per i tokens che hanno un contenuto: stringhe, numeri.

Oppure

<TOKENTYPE> per token semplici, come le parentesi. 

Dalla lista di token usare una funzione parse che genera l'albero corrispondente a parire dalla
lista.


Struttura particolare Lisp

In lisp abbiamo scelto di implementare
lavoriamo come se avessimo una macchina a stati finiti
con stack.

Non potendo usare un proprio stack o iteratore ne' la funzione pop()
perche usano una set nella loro implementazione,
usiamo una combinazione di funzione e ricrsione sulla lista di tokens

ogni regola della grammatica in una funzione, 
e usare la ricorsione er seguire le regole di produzione

facendo un peak in avanti (sbirciando) per
scoprire che regola applicare.

per poi andare sul giusto parser, che fa una sola
cosa: parsare quella particolare sequenza per cui è programmato, e ritornare il
resto dei tokens non parsati.

Do one thing, but do it well.

note:

usando la funzione 

parse-object(tokens)

si ha in ritorno ->'(Jsonobj Rest)
si potrebbe andare a vedere il JSON obj che viene parsato
correttamente, e poi il rest.

La nostra macchina a stati finiti lavora quindi su pila vuota e non su uno stato
finito.

Gli stati sono i vari parser su cui la macchina si setta per cercare diversi patterns.
