%%% -*- Mode: prolog -*-

%%% [library(dcg/basics)].



integer(I) -->
        digit(D0),
        digits(D),
        { number_codes(I, [D0|D])
        }.


digits([D|T]) -->
        digit(D), !,
        digits(T).
digits([]) -->
        [].

digit(D) -->
        [D],
        { code_type(D, digit)
        }.


upto_doublequote(Atom) -->
        string_without(Codes), ":", !,
        { atom_codes(Atom, Codes) }.



c(X):-
    read_file_to_codes("in.txt", X, []).

try(X, Rest) :-
    atom_codes('version" 321', Codes),
    phrase(upto_doublequote(X), Codes, Rest).
