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

To implement a recursive descent parser in Common Lisp,
you can use a combination of functions and recursion to 
parse the list of tokens. You can define a separate 
function for each non-terminal symbol in your grammar, 
and use recursion to handle the production rules. Since 
you cannot use loops or assignments, you will need to 
use recursion to iterate through the list of tokens, and 
use pattern matching to identify the current token and 
determine which production rule to apply. To parse a 
simplified version of JSON, you will need to define 
functions for handling the JSON object and array 
structures, as well as functions for handling the 
various types of JSON values (strings, numbers, etc.).
