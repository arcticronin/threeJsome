:- use_module(tokenizer).
:- use_module(parser).
:- use_module(file_io).

%% from tokenizer, everything is private except
%% string_tokens, useful here for debug too.

semi(T):-
    jsonparse('{"nome" : "Arthur", "cognome" : "Dent"}',X),
    X = jsonobj([("nome", T)|_]).

r:-
    [jsonparse].

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
