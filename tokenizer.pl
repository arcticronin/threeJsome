%per if_/3 e reification pr
:- use_module(library(reif)).
:- use_module(library(prolog_pack)). %for managing packs using pack_install/1

tokenize(T):-
  read_file_to_codes("in.txt", X, []),
  codes_tokens(X,T).

t(O):-
  read_file_to_codes("in.txt", X, []),
  codes_tokens(X, T1),
  remove_whitespaces(T1,T),
  write(T),
  tokens_jsonobj(T, O).

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
    is_string_delimiter(A).

%% recursive case if input list not empty
codes_stringtoken_([C|Cs], [C|Ss], Rest):-
    not(is_string_delimiter(C)),
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
    tokens_members_rest(R1, Ps ,Rest).

%tokens_pair_rest/3
tokens_pair_rest([string(A),"COLON"|Cs], (A , Val), Rest):-
    tokens_value_rest(Cs, Val, Rest).


%tokens_value_res/3
tokens_value_rest([string(Val)|Rest], Val, Rest):-
    !.
tokens_value_rest([num(Val)|Rest], Val, Rest):-
    !.
tokens_value_rest(["OPENBRACKET"|Cs], jsonobj(Members), Rest):-
    !,
    tokens_members_rest(Cs, Members, Rest).

%tokens_elements_rest/3,
tokens_elements_rest(["CLOSEDBRACKET"|Rest], [], Rest):-
    !.

tokens_elements_rest(C, [V1|V2], Rest):-
    !,
    tokens_value_rest(C, V1, ["COMMA"|R1]),
    tokens_elements_rest(R1, V2, Rest).


tokens_elements_rest(C, V, Rest):-
    !,
    tokens_value_rest(C, V, Rest).
    % nocomma so it's just V1
    %tokens_elements_rest(R1, V2, Rest).


%string_obj/2
string_obj(S, O):-
    string_tokens(S, T),
    tokens_jsonobj(T, O).
