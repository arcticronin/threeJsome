:- use_module(tokenizer).
:- use_module(parser).

%% from tokenizer, everything is private except
%% string_tokens, useful here for debug too.

semi(T):-
    jsonparse('{"nome" : "Arthur", "cognome" : "Dent"}',X),
    X = jsonobj([("nome", T)|_]).
r:-
    [jsonparse].

              %%jsonobj([("nome", "arthur"), T])).

              %%jsonobj([jsonarray(_) | _]).o

test1(O, R):-
    jsonparse('{"nome" : "Arthur", "cognome" : "Dent"}', O),
    jsonaccess(O, ["nome"], R).
test2(O, R):-
    jsonparse('{"nome": "Arthur", "cognome": "Dent"}', O),
    jsonaccess(O, "nome", R).
test3(Z,R):-
    jsonparse('{"nome" : "Zaphod",
    "heads" : ["Head1", "Head2"]}', % Attenzione al newline.
              Z),
    jsonaccess(Z, ["heads", 1], R).
test4(R):-
    jsonparse('{"nome" : "Arthur", "cognome" : "Dent"}', JSObj),
    jsonaccess(JSObj, ["cognome"], R).
