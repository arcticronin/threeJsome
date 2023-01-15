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

%% imported predicates for short:

%% from tokenizer, everything is private except
%string_tokens/2 (just for debug here)

%% from parser
%jsonparse/2
%jsonaccess/3
%jsonread/2

Prolog:

I numeri in prolog sono stati implementati a mano, senza una funzione parsenumber:

(defparameter y '(
                 ("string-token" "nome") "COLON"
                  ("string-token" "Arthur") "CLOSEDCURLY"))

(defparameter k '("OPENCURLY"
                 ("string-token" "nome") "COLON" ("string-token" "Arthur") "COMMA"
                 ("string-token" "cognome") "COLON" ("string-token" "Dent") "COMMA"
                 ("string-token" "eta") "COLON" ("number-token" 19) "CLOSEDCURLY"))

(defparameter c '("OPENCURLY"
                 ("string-token" "nome") "COLON" ("string-token" "JOE")
                  "COMMA"  ("string-token" "cognome") "COLON"
                  ("string-token" "Dent") "CLOSEDCURLY" ))


(defparameter pino '("OPENCURLY"
                 ("string-token" "nome") "COLON" ("string-token" "Arthur") "COMMA"
                 ("string-token" "cognome") "COLON" ("string-token" "Dent") "COMMA"
                 ("string-token" "eta") "COLON" ("number-token" 19) "COMMA" ("string-token" "nested") "COLON" "OPENCURLY" ("string-token" "nome") "COLON" ("string-token" "Arthur") "CLOSEDCURLY" "CLOSEDCURLY"))

(defparameter arr1 '("OPENBRACKET" ("number-token" 1) "COMMA"
                                  ("number-token" 2) "COMMA"
                                  ("string-token" "TREEEEE")
                          "COMMA" ("number-token" 4) "CLOSEDBRACKET"))


(defparameter arr '(            ("number-token" 1) "COMMA"
                                  ("number-token" 2) "COMMA"
                                  ("string-token" "TREEEEE")
                          "COMMA" ("number-token" 4) "CLOSEDBRACKET"
                    "COMMA" ("number-token" 5)))


(defparameter arr2 '( "OPENBRACKET" ("number-token" 1) "COMMA"
                     "OPENBRACKET"("number-token" 2) "COMMA"
                                  ("string-token" "TREEEEE") "CLOSEDBRACKET"
                          "COMMA" ("number-token" 4) "CLOSEDBRACKET"))


(defparameter ne '("OPENBRACKET" "OPENCURLY" "CLOSEDCURLY" "CLOSEDBRACKET"))

(defparameter nnn '("OPENBRACKET" "OPENBRACKET" "CLOSEDBRACKET" "COMMA" ("name") "CLOSEDBRACKET"))

(defparameter kv1 '(("string-token" "name") "COLON" ("number-token" 1) "CLOSEDBRACKET"))
(defparameter kv2 '("OPENBRACKET" "OPENCURLY" "CLOSEDCURLY" "CLOSEDBRACKET"))
(defparameter kv3 '("OPENBRACKET" ("number-token" 1) "COMMA" "OPENBRACKET"  "CLOSEDBRACKET" "COMMA" ("number-token" 2)  "CLOSEDBRACKET"))
;"OPENCURLY" "CLOSEDCURLY"
(defparameter pino3 '(
                       "OPENCURLY"
                       ("string-token" "Nest 1") "COLON"
                       "OPENCURLY"
                       ("string-token" "Nest 2") "COLON"
                       "OPENCURLY"
                       ("string-token" "eta") "COLON" ("number-token" 19)
                       "COMMA"
                       ("string-token" "Nest 3")  "COLON"
                       "OPENCURLY"
                       ("string-token" "eta") "COLON" ("number-token" 19)
                       "COMMA"
                       ("string-token" "cognome") "COLON" ("string-token" "Dent")
                       "CLOSEDCURLY"
                       "CLOSEDCURLY"
                       "CLOSEDCURLY"
                       "CLOSEDCURLY"))

(defparameter empty-arr '("OPENBRACKET" "CLOSEDBRACKET"))

(defparameter arr-simple '("OPENBRACKET" "OPENBRACKET" "CLOSEDBRACKET"  "COMMA" ("string-token" "Arthur") "CLOSEDBRACKET"))

(defparameter arr-nested-obj '("OPENBRACKET" ("number-token" 10) "COMMA" ("string-token" "Arthur") "COMMA" "OPENCURLY"("string-token" "neste nest") "COLON" ("string-token" "Arthur") "COMMA"
  ("string-token" "eta") "COLON" ("number-token" 10) "CLOSEDCURLY" "COMMA" "OPENBRACKET" "CLOSEDBRACKET" "CLOSEDBRACKET"))

(defparameter arr-nested-arr
'("OPENBRACKET" "OPENBRACKET" ("number-token" 1) "COMMA"  "OPENBRACKET" ("number-token" 2) "CLOSEDBRACKET" "COMMA" ("number-token" 3) "CLOSEDBRACKET" "CLOSEDBRACKET"))


(defparameter arr-nested-obj2 '("OPENBRACKET" "OPENCURLY"("string-token" "neste nest") "COLON" ("string-token" "Arthur") "COMMA"
  ("string-token" "eta") "COLON" ("number-token" 10) "CLOSEDCURLY" "COMMA" "OPENBRACKET" ("number-token" 10) "COMMA" ("string-token" "Arthur") "CLOSEDBRACKET" "CLOSEDBRACKET"))
