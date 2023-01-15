# threeJsome


la struttura scelta per implementare i progetti è presa dal libro:
compilers TODO,
quindi segue una struttura top down, che parte identificando i membri più esterni per andare poi a finire su quelli più interni.
è un recursive descent parser.

la struttura utilizzata è quella di creare innanzitutto dei tokens, identificabili:

<TOKENTYPE "TOKENCONTENT">

oppure
<TOKENTYPE> per token semplici, s, ad esempio le parentesi 

Poi dalla lista di token usare una funzione parse che genera l'albero a parire dalla lista.



Prolog:

I numeri in prolog sono stati implementati a mano, senza una funzione parsenumber: