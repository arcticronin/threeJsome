%per if_/3 e reification pr
:- use_module(library(reif)).
:- use_module(library(prolog_pack)). %for managing packs using pack_install/1

%%main functions:

%jsonparse/2
jsonparse(S, O):-
    atom_codes(S, C),
    codes_tokens(C, TWW),
    remove_whitespaces(TWW, T),
    tokens_jsonobj(T, O).


%jsonread/2
jsonread(FileName, Jobj):-
    read_file_to_string(FileName, S, []),
    jsonparse(S, Jobj).



%debug
%tokenizefile/1
tokenizefile(T):-
  read_file_to_codes("in.txt", X, []),
  codes_tokens(X,T).
%t/1
t(O):-
  read_file_to_codes("in.txt", X, []),
  codes_tokens(X, T1),
  remove_whitespaces(T1,T),
  %gtrace,
  tokens_jsonobj(T, O),
  write(O).

%quick debug reason
%remember to escape the "s
%string_tokens/2
string_tokens(S,T):-
    atom_codes(S,C),
    codes_tokens(C,T2),
    remove_whitespaces(T2,T).
    %collapse_whitespaces(T2,T).


%codes_tokens/2
%funzione base per trasformare da codice a token
% non reversibile per instantiation error su atom codes

codes_tokens([], []):-
    !.

codes_tokens([C|Cs], [T|Ts]):-
    C = 123,
    T = "OPENCURLY",
    !,
    codes_tokens(Cs, Ts).

codes_tokens([C|Cs], [T|Ts]):-
    C = 125,
    T = "CLOSEDCURLY",
    !,
    codes_tokens(Cs, Ts).

codes_tokens([C|Cs], [T|Ts]):-
    C = 91,
    T = "OPENBRACKET",
    !,
    codes_tokens(Cs, Ts).

codes_tokens([C|Cs], [T|Ts]):-
    C = 93,
    T = "CLOSEDBRACKET",
    !,
    codes_tokens(Cs, Ts).

codes_tokens([C|Cs], [T|Ts]):-
    C = 44,
    T = "COMMA",
    !,
    codes_tokens(Cs, Ts).

codes_tokens([C|Cs], [T|Ts]):-
    C = 58,
    T = "COLON",
    !,
    codes_tokens(Cs, Ts).

codes_tokens([C|Cs], [T|Ts]):-
    C = 43,
    T = sign("PLUS"),
    !,
    codes_tokens(Cs, Ts).

codes_tokens([C|Cs], [T|Ts]):-
    C = 45,
    T = sign("MINUS"),
    !,
    codes_tokens(Cs, Ts).

codes_tokens([T,R,U,E|Cs], [Tok| Ts]):-
    T = 116,
    R = 114,
    U = 117,
    E = 101,
    Tok = "true",
    !,
    codes_tokens(Cs, Ts).

codes_tokens([F,A,L,S,E|Cs], [T| Ts]):-
    F = 102,
    A = 97,
    L = 108,
    S = 115,
    E = 101,
    T = "false",
    !,
    codes_tokens(Cs, Ts).

codes_tokens([N,U,L,L|Cs], [T| Ts]):-
    N = 110,
    U = 117,
    L = 108,
    T = "null",
    !,
    codes_tokens(Cs, Ts).

%% whitespaces

codes_tokens([C|Cs], [T|Ts]):-
    is_whitespace(C),
    T = "WHITESPACE",
    !,
    codes_tokens(Cs, Ts).

% compound terms
% strings

% 39 code of '
% 34 code of "
% i could use a predicate to not hardcode it, but it's fine for now
codes_tokens([C|Cs], [string(T)|Ts]):-
    C = 34,
    !,
    codes_stringtoken_(Cs, S, Rest),
    atom_codes(T , S),

    codes_tokens(Rest, Ts).


% try to parse a number if no one of the others applies
% todo: better number parsing: group any of "+-123,e"
% till a WHITESPACE (or another term, see grammar) and then call atom_number or smth
codes_tokens(C, [number(T)|Ts]):-
    !,
    codes_number_(C, T, Rest),
    %parse_number(C, T, Rest),
    codes_tokens(Rest, Ts).

%% tutti i codici non riconosciuti vengono catalogati come debug(codice)
% not coded (DEBUG)
codes_tokens([C|Cs],[T|Ts]):-
    !,
    T = todo(C),
    codes_tokens(Cs, Ts).


%is_string_delimiter/1
is_string_delimiter(34).

%codes_stringtokens/3
%% when i find \" che è la apertura di una stringa,
%% append nothing and continue to tokenize the rest
%% second param is the accumulator,
%% third is the actual token unified

%% maybe not needed
codes_stringtoken_([], _, _):-
    fail.

%% found my end mark
codes_stringtoken_([A|Cs], [], Cs):-
    is_string_delimiter(A),
    !.

%% recursive case if input list not empty
codes_stringtoken_([C|Cs], [C|Ss], Rest):-
    not(is_string_delimiter(C)),
    !,
    codes_stringtoken_(Cs, Ss, Rest).

%% whitespace defining predicates
%is_whitespace/1
is_whitespace(9). %tab
is_whitespace(10). %nl
is_whitespace(32). %space


%codes_number_/3
%codes_number_(C, N, Rest):-
%    number_codes(N, Processed),
%    append(Processed, Rest, C).
%
codes_number_(AsciiCodes, Number, Rest) :-
    !,
    codes_number_(AsciiCodes, 0, Number, Rest).

codes_number_([], Acc, Acc, []):-
    !.
codes_number_([AsciiCode|AsciiCodes], Acc, Number, Rest) :-
  % Check if the ASCII code is a digit
  between(48, 57, AsciiCode),
  !,
  % Convert the ASCII code to a digit and add it to the accumulator
  Digit is AsciiCode - 48,
  NewAcc is Acc * 10 + Digit,
  % Recurse to parse the rest of the list
  codes_number_(AsciiCodes, NewAcc, Number, Rest).

codes_number_(Rest, Number, Number, Rest):-
    !.


%collapse_whitespaces/2

collapse_whitespaces([] , []).

collapse_whitespaces([A|Ls] , [A|Rs]):-
    A \= "WHITESPACE",
    collapse_whitespaces(Ls, Rs).

%removing trailing whitespace
collapse_whitespaces(["WHITESPACE"|Ls],[]):-
    Ls = [].

collapse_whitespaces([W,X|Ls], [W|Rs]):-
    W = "WHITESPACE",
    W \= X,
    collapse_whitespaces([X|Ls], Rs).

collapse_whitespaces([W,W2|Ls], R):-
    W = "WHITESPACE",
    W2 = W,
    collapse_whitespaces([W2|Ls], R).

%remove_whitespaces/2

remove_whitespaces([],[]):-
    !.

remove_whitespaces([L|Ls], Rs):-
    L = "WHITESPACE",
    !,
    remove_whitespaces(Ls, Rs).

remove_whitespaces([L|Ls],[L|Rs]):-
    !,
    remove_whitespaces(Ls, Rs).

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
    trace,
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



%% todo, try jasonparse using a string not enquoting it nd spot where it errors
