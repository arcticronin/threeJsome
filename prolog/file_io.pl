:- module(file_io, [jsonread/2, jsondump/2]).

% input
%jsonread/2
jsonread(FileName, Jobj):-
    read_file_to_string(FileName, S, []),
    jsonparse(S, Jobj).

%jsondump/2
jsondump(JSON, FileName) :-
    atom(FileName),
    open(FileName, write, Out),
    jsondump_(JSON, Out),
    close(Out).

% Write json in a file definition:
% write_json/2

% Case in which there is a json_obj
jsondump_(jsonobj(Members), Out) :-
    !,
    write(Out, "{"),
    write_members(Members, Out),
    write(Out, '}').

% Case in which there is a json_array
jsondump_(jsonarray(Elements), Out) :-
    !,
    write(Out, '['),
    write_elements(Elements, Out),
    write(Out, ']').



% Write members definition:
% write_members/2

% Base case -> empty JSON
write_members([], _Out) :-
    !.

% Base case -> string : string
write_members([(Chiave, Valore)], Out) :-
    string(Chiave),
    string(Valore),
    !,
    writeq(Out, Chiave),
    write(Out, " : "),
    writeq(Out, Valore).

% Base case -> string : number
write_members([(Chiave, Valore)], Out) :-
    string(Chiave),
    number(Valore),
    !,
    writeq(Out, Chiave),
    write(Out, " : "),
    writeq(Out, Valore).

% Base case -> string : json_Obj
write_members([(Chiave, jsonobj(Members))], Out) :-
    string(Chiave),
    !,
    writeq(Out, Chiave),
    write(Out, " : "),
    jsondump_(jsonobj(Members), Out).

% Recursive case -> string : json_Obj
write_members([(Chiave, jsonobj(Members)) | Members1], Out) :-
    string(Chiave),
    !,
    writeq(Out, Chiave),
    write(Out, " : "),
    jsondump_(jsonobj(Members), Out),
    write(Out, ', '),
    write_members(Members1, Out).

% Base case -> string : json_Array
write_members([(Chiave, jsonarray(Elements))], Out) :-
    string(Chiave),
    !,
    writeq(Out, Chiave),
    write(Out, " : "),
    jsondump_(jsonarray(Elements), Out).

% Recursive case -> more than just a member
write_members([(Chiave, Valore) | Members], Out) :-
    !,
    write_members([(Chiave, Valore)], Out),
    write(Out, ", "),
    write_members(Members, Out).



% Write Elements definition:
% write_elements/2

% Base case: empty array
write_elements([], _Out) :-
    !.
% Base case: element is a string
write_elements([Element], Out) :-
    string(Element),
    !,
    writeq(Out, Element).

% Base case: element is a number
write_elements([Element], Out) :-
    number(Element),
    !,
    writeq(Out, Element).

% Base case: element is a json_obj
write_elements([json_obj(Members)], Out) :-
    !,
    jsondump_(json_obj(Members), Out).

% Base case: element is a json_array
write_elements([json_array(Elements)], Out) :-
    !,
    jsondump_(json_array(Elements), Out).

% Recursive case: more than just an element
write_elements([Element | Elements], Out) :-
    !,
    write_elements([Element], Out),
    write(Out, ", "),
    write_elements(Elements, Out).


r:-
    notrace,
    nodebug,
    [write].

try(X):-
    jsonread('in.txt', X),
    %trace,
    jsondump(X, 'out.txt').




%tab/2
%tab(Int, String):-
tab(0, []):-
    !.
tab(I, S):-
    integer(I),
    I >= 0,
    NI is I - 1,
    append(['\t'], S2 , S),
    tab(NI, S2).
