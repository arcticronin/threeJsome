
tryread(Filename, String) :-
    read_file_to_string(FileName, JSON_obj, []).


readit(Name) :-
    open(Name, read, Str),
    read_file(Str, Lines),
    close(Str),
    write(Lines), n1.

printit(What):-
    open('input.txt', read, Str),
    read(In, Lines),
    close(In).

read_file(Stream, []) :-
    at_end_of_stream(Stream).

read_file(Stream, [X | Xs]) :-
    \+ at_end_of_stream(Stream),
    read(Stream, X),
    read_file(Stream, Xs).


skip([' ' | Xs], []).


Jsonparse().

object('{', L, '}').

array('[', L, ']').

object('{', L, '}').

object('{', L, '}').


json_parse(JSON, Object) :-
    atom(JSON),
    %% !,
    skip(Rest, []).
