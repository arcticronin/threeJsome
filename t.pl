
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


process_file :-
   read(Line),
   Line \== end_of_file, % when Line is not not end of file, call process.
   process(Line).
process_file :- !. % use cut to stop backtracking

process2(Line):- %this will print the line into the console
   write(Line),nl,
   process_file.

process(Line):- %this will print the line into the console
   tokenize_atom(Line, X),nl,
   process_file.

start:-
    see('input.txt'),
    process_file,
    seen.



comma
colon
bracket("}")
brcket("{")
brcket("[")
brcket("]")
id("arthur")
value("dent")

elem (L|Ls):-
    id:
    bracket("{"),
    elem(Ls)
    bracket("}").

elem(L|Ls)
