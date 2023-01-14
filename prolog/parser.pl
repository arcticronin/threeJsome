:- module(parser, [jsonparse/2, jsonaccess/3, jsonread/2]).
:- use_module(tokenizer).

%jsonparse/2
jsonparse(S, O):-
    string_tokens(S, T),
    tokens_jsonobj(T, O).

%jsonread/2
jsonread(FileName, Jobj):-
    read_file_to_string(FileName, S, []),
    jsonparse(S, Jobj).

%tokens_jsonobj/2
tokens_jsonobj([C|Cs], jsonobj(S)):-
    C = "OPENCURLY",
    !,
    tokens_members_rest(Cs, S, Rest),
    Rest = []. %% TODO: must be true at hte first callbut maybe
                %% can be omitted, it's checked there

%tokens_jsonobj/2
tokens_jsonobj([C|Cs], jsonarray(S)):-
    C = "OPENBRACKET",
    !,
    tokens_elements_rest(Cs, S, Rest),
    Rest = []. %% TODO: must be true at hte first callbut maybe
                %% can be omitted, it's checked there


%tokens_members_rest/3
%
%found endmark append nothing to my memebers, rest is everything
%after the endmark
tokens_members_rest(["CLOSEDCURLY"|Rest], [] , Rest).
%% maybe not needed, finished to read didnt find endmark

tokens_members_rest([], _, _):-
    fail.

%% recursive case if input list not empty
tokens_members_rest([C|Cs], [P|Ps], Rest):-
    C \= "CLOSEDCURLY", %opt
    tokens_pair_rest([C|Cs], P, R1),
    R1 = ["COMMA"|R2],
    !,
    tokens_members_rest(R2, Ps ,Rest).

tokens_members_rest([C|Cs], [P], Rest):-
    C \= "CLOSEDCURLY", %opt
    tokens_pair_rest([C|Cs], P, R1),
    R1 = ["CLOSEDCURLY"|Rest],
    !.

%tokens_pair_rest/3

tokens_pair_rest([string(A),"COLON"|Cs], (A , Val), Rest):-
    !,
    tokens_value_rest(Cs, Val, Rest).


%tokens_value_res/3
tokens_value_rest([string(Val)|Rest], Val, Rest):-
    !.
tokens_value_rest([number(Val)|Rest], Val, Rest):-
    !.
tokens_value_rest(["OPENBRACKET"|Cs], jsonarray(Elements), Rest):-
    !,
    tokens_elements_rest(Cs, Elements, Rest).
tokens_value_rest(["OPENCURLY"|Cs], jsonobj(Members), Rest):-
    !,
    tokens_members_rest(Cs, Members, Rest).

%tokens_elements_rest/3,
tokens_elements_rest(["CLOSEDBRACKET"|Rest], [], Rest):-
    !.

tokens_elements_rest(C, [V|V2], Rest):-
    tokens_value_rest(C, V, R1),
    R1 = ["COMMA"|R2],
    !,
    tokens_elements_rest(R2, V2, Rest).

%% [V] because it's == to [V|[]],
%% I could also call it without removing "CLOSEDBRACKET"
%% and calling tokens_elements_rest, that will return [] from basecase
tokens_elements_rest(C, [V], Rest):-
    tokens_value_rest(C, V, R1),
    R1 = ["CLOSEDBRACKET"|Rest],
    !.

%jsonaccess/3

%% case i have a string and not a list
jsonaccess(A, S, R):-
    string(S),
    jsonaccess(A, [S], R).

%PAIR
%special case string TODO
%BaseCase
jsonaccess((_, X), [], X). %% found result as pair, returning item
%RecursiveCase
jsonaccess((_, X), L, R):-
    jsonaccess(X, L, R).
%% basecase matches all
jsonaccess(X, [], X).


%ARRAY
jsonaccess(jsonarray(A), [F|Fs] , R):-
    integer(F),
    F >= 0,
    nth0(F , A , X),
    jsonaccess(X, Fs , R).

%% field matches
jsonaccess(O, [F|Fs], R):-
    O = jsonobj(UnwrappedO),
    member((F, X), UnwrappedO),
    jsonaccess(X, Fs, R).
%% fails if obj it goes empty, and i still have
%% a list of fields to check
