:- use_module(tokenizer).
:- use_module(parser).

%jsondump/2
%jsondump(JsonTerm, String)
jsondump(J, S):-
    atom_chars(J, JL),
    json_string(JL, S, 0, 0, _Rest).

%json_string/5
%json_string(JsonList, String, Indent, NextIndent, Rest).

%% NOTE implement manually {} and [] case
json_string(JL, S, I, NI, Rest):-
    prefix_list_rest('jsonarray(', JL, Rest),
    NI is I + 4,
    tab(NI, Tab),
    append([Tab, '[','\n'], S).

json_string(JL, S, I, NI, Rest):-
    prefix_list_rest('jsonobj(', JL, Rest),
    NI is I + 4,
    tab(NI, Tab),
    append(Tab, ['{','\n'],S).
    %append(['{','\n'], Ss, S).
    %parse_members_(R1, Ss, NI).

%parse_members_/5
parse_members_([JL|JLs], [], I ,NI, Rest):-
    JL = [','].

parse_members_([JL|JLs], [], I ,NI, Rest):-
    JL /= [',']. %%opt
    %parsefirst
    %:
    %parsesecond
    %% parsemoremembers
    %parse_members_(R

%parse_element/5
%element|elements
%
%parse_value/5
%case inizia con ',
%case finisce con :' (credo)

%parse_e
%parse_element


json_string(_JL, Rest, _, _, Rest):-
    write("fallback here").

json_string(_JL, _S, _, _, []):-
    write("fallback here 2").

%% Utils
%prefix_list_rest/3 takes a prefix as a string
% checks if it's a prefix of a list of chars
prefix_list_rest(String, L, R):-
    atom_chars(String, Cs),
    append(Cs, R, L).

try(R):-
    atom_chars("jsonarray([1,2,3])", L),
    R = (NI, L, P ,Rest),
    json_string(L, P, 0, NI, Rest).

try2(R):-
    atom_chars("jsonobj((ciao:[1,2,3]))", L),
    R = (NI, L, P , Rest),
    json_string(L, P, 0, NI, Rest).

%tab/2
%tab(Int, String):-
tab(0, []):-
    !.
tab(I, S):-
    integer(I),
    I >= 0,
    NI is I - 1,
    append(['\n'], S2 , S),
    tab(NI, S2).

%r/0
r:-
    notrace,
    nodebug,
    [jsondump].
