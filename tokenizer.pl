
tokenize(T):-
  read_file_to_codes("in.txt", X, []),
  codes_tokens(X,T).

%quick debug reason
%remember to escape the "s
%string_tokens/2
string_tokens(S,T):-
    atom_codes(S,C),
    codes_tokens(C,T).


%codes_tokens/2
%funzione base per trasformare da codice a token
% non reversibile per instantiation error su atom codes

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


% numbers
codes_tokens(C, [number(T)|Ts]):-
    codes_number_(C, T, Rest),
    %parse_number(C, T, Rest),
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

%codes_number_/3
%codes_number_(C, N, Rest):-
%    number_codes(N, Processed),
%    append(Processed, Rest, C).
%
codes_number_(AsciiCodes, Number, Rest) :-
  codes_number_(AsciiCodes, 0, Number, Rest).

codes_number_([], Acc, Acc, []).
codes_number_([AsciiCode|AsciiCodes], Acc, Number, Rest) :-
  % Check if the ASCII code is a digit
  between(48, 57, AsciiCode),

  % Convert the ASCII code to a digit and add it to the accumulator
  Digit is AsciiCode - 48,
  NewAcc is Acc * 10 + Digit,

  % Recurse to parse the rest of the list
  codes_number_(AsciiCodes, NewAcc, Number, Rest).

codes_number_(Rest, Number, Number, Rest).
