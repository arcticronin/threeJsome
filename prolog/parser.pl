:- module(parser, [jsonparse/2, jsonaccess/3, jsonread/2]).
:- use_module(tokenizersplit).

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
tokens_jsonobj([C|Cs], jsonarr(S)):-
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




    



%tokens_elements_rest(C, [V1|V2], Rest):-
 %   tokens_value_rest(C, V1, [R1|R1s]),
  %  R1 = "COMMA",
   % tokens_elements_rest(R1s, V2, Rest).

%tokens_elements_rest(C, [V1|V2], Rest):-
 %   tokens_value_rest(C, V1, R1),
  %  tokens_elements_rest(R1, V2, Rest).


%tokens_elements_rest(C, [V], Rest):-
 %   tokens_value_rest(C, V, ["CLOSEDBRACKET"|Rest]),
  %  !.
    % nocomma so it's just V1
    %tokens_elements_rest(R1, V2, Rest).

try3(E,R):-
    string_tokens('1,2,3]',T),
    trace,
    tokens_elements_rest(T,E,R).

try2(E,R):-
    string_tokens('"A": 1, "B": 2 }',T),
    write(T),
    trace,
    tokens_members_rest(T,E,R).



%string_obj/2
string_obj(S, O):-
    string_tokens(S, T),
    %trace,
    tokens_jsonobj(T, O).

%r/0
r():-
    notrace,
    nodebug,
    [tokenizer].

%jsonaccss/3
%jsonaccess(O, F, R):-

%che minchia e questa roba
%jsonaccess(X, [], X):-
%    X = jsonobj(_). %% fails if array


%jsonaccess(jsonarray(_), [], []).

%PAIR
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

%% use integer/1 to check
try(Res):-
    jsonparse('{"a" : [100, {"tipo" : [65,66,67] }, 120, 130] , "b" : 20, "c" : 30}', WX),
    %trace,
    jsonaccess(WX, [a,1,tipo], Res).
    %jsonaccess(R1, [1], Res).

try2(Res):-
    jsonparse('{"ciao": {}}', WX),
    write(WX),
    trace,
    jsonaccess(WX, [ciao], Res),
    !.


try3(Res):-
    jsonparse('[1,2,{"ciao": 10},4,5]', WX),
    write(WX),
    trace,
    jsonaccess(WX, [2], Res),
    !.
