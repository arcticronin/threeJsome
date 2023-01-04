
tokenize(T):-
  read_file_to_codes("in.txt", X, []),
  codes_tokens(X,T).

%codes_tokens/2
%funzione base per trasformare da codice a token

codes_tokens([], []).

codes_tokens([C|Cs], [T|Ts]):-
    C = 123,
    T = "OPENCURLY",
    codes_tokens(Cs, Ts).

codes_tokens([C|Cs], [T|Ts]):-
    C = 125,
    T = "CLOSEDCURLY",
    codes_tokens(Cs, Ts).

codes_tokens([C|Cs], [T|Ts]):-
    C = 91,
    T = "OPENBRACKET",
    codes_tokens(Cs, Ts).

codes_tokens([C|Cs], [T|Ts]):-
    C = 93,
    T = "CLOSEDBRACKET",
    codes_tokens(Cs, Ts).

codes_tokens([C|Cs], [T|Ts]):-
    C = 44,
    T = "COMMA",
    codes_tokens(Cs, Ts).

codes_tokens([C|Cs], [T|Ts]):-
    C = 58,
    T = "COLON",
    codes_tokens(Cs, Ts).

codes_tokens([C|Cs], [T|Ts]):-
    C = 43,
    T = sign("PLUS"),
    codes_tokens(Cs, Ts).

codes_tokens([C|Cs], [T|Ts]):-
    C = 45,
    T = sign("MINUS"),
    codes_tokens(Cs, Ts).

codes_tokens([T,R,U,E|Cs], [Tok| Ts]):-
    T = 116,
    R = 114,
    U = 117,
    E = 101,
    Tok = "true",
    codes_tokens(Cs, Ts).

codes_tokens([F,A,L,S,E|Cs], [T| Ts]):-
    F = 102,
    A = 97,
    L = 108,
    S = 115,
    E = 101,
    T = "false",
    codes_tokens(Cs, Ts).

codes_tokens([N,U,L,L|Cs], [T| Ts]):-
    N = 110,
    U = 117,
    L = 108,
    T = "null",
    codes_tokens(Cs, Ts).

%% whitespaces

% tab
codes_tokens([C|Cs], [T|Ts]):-
    C = 9,
    T = "WHITESPACE",
    codes_tokens(Cs, Ts).

% newline
codes_tokens([C|Cs], [T|Ts]):-
    C = 10,
    T = "WHITESPACE",
    codes_tokens(Cs, Ts).

% space
codes_tokens([C|Cs], [T|Ts]):-
    C = 32,
    T = "WHITESPACE",
    codes_tokens(Cs, Ts).

% compound terms
% strings

% 39 code of '
%34 code of "
codes_tokens([C|Cs], [string(T)|Ts]):-
    C = 34,
    codes_stringtoken_(Cs, S, Rest),
    atom_codes(T , S),

    codes_tokens(Rest, Ts).

%% tutti i codici no nriconosciuti vengono catalogati come debug(codice)
% not coded (DEBUG)
codes_tokens([C|Cs],[T|Ts]):-
    T = todo(C),
    codes_tokens(Cs, Ts).






%codes_stringtokens/3
%% when i find \" che è la apertura di una stringa, append nothing and continue to tokenize the rest
% second param is the accumulator, third is the actual token unified

%% maybe not needed
codes_stringtoken_([], _, _):-
    fail.

%% found my end mark
codes_stringtoken_([34|Cs], [], Cs).

%% recursive case if input list not empty
codes_stringtoken_([C|Cs], [C|Ss], Rest):-
    C \= 34,
    codes_stringtoken_(Cs, Ss, Rest).

