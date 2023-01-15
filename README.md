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

%% try to follow a TOP DOWN tecnique
%% using a tokenizer first, 
%% then a recursive descent on top of that.


%% imported predicates for short:

%% from tokenizer, everything is private except
%string_tokens/2 (just for debug here)

%% from parser
%jsonparse/2
%jsonaccess/3
%jsonread/2

Prolog:

I numeri in prolog sono stati implementati a mano, senza una funzione parsenumber: