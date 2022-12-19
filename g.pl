%%
%%
%%



%% primo livello : tokens
%% OPEN_BRACKET
%% CLOSED_BRACKET
%% OPEN_CURLYBRACE
%% CLOSED_CURLYBRACE
%%
%%
%%



%% normalize forse non serve ma è stato una cazzata farlo
%% prove, codice non ancora funzionante
string_manipulation(Input,Output):-
	normalize_space(atom(S0), Input),
	replace_in_string(":"," : ",S0,S1),
	replace_in_string(","," , ",S1,S2),
	replace_in_string("{"," { ",S4,S5),
	replace_in_string("}"," } ",S5,S6),
	replace_in_string("("," ( ",S6,S7),
	replace_in_string(")"," ) ",S7,S8),
	normalize_space(atom(SF), S8),
	%atomic_list_concat(Output," ",SF),
	write("\n================== tokenz list ==================\n"),
	write(SF),
	split_string(SF, " ", "",Output). %returns a list of strings splited by space



replace_in_string(Old_Char,New_Char,String,New_String):-
	atomic_list_concat(Atoms,Old_Char, String),
	atomic_list_concat(Atoms,New_Char, New_String).


%% end normalizer

%% tokenizer: funziona con file normalizzato!!!
tokenize_file(FileName, Token_List) :-
  open(FileName, read, Stream),
  read_tokens_from_stream(Stream, Tokens_From_Stream),
  close(Stream),
  clean_token_list(Tokens_From_Stream, Token_List).

read_tokens_from_stream(Stream, [Token|Tokens_From_Stream]) :-
  \+ at_end_of_stream(Stream),
  get_next_token(Stream, Token),
  !,
  read_tokens_from_stream(Stream, Tokens_From_Stream).
read_tokens_from_stream(_, []).

get_next_token(Stream, Token) :-
  get0(Stream, Ascii_Char),
  get_next_char(Stream, String, Ascii_Char),
  atom_codes(Token, String).

get_next_char(Stream, [Ascii_Char|String], Ascii_Char) :-
  Ascii_Char > 32,
  get0(Stream, Next_Ascii_Char),
  !,
  get_next_char(Stream, String, Next_Ascii_Char).
get_next_char(_, [], _).


%whitespaces
clean_token_list([], []) :-
  !.

clean_token_list([''|Tokens_From_Stream], Token_List) :-
  !,
  clean_token_list(Tokens_From_Stream, Token_List).

clean_token_list([Token|Tokens_From_Stream], [Token|Token_List]) :-
  clean_token_list(Tokens_From_Stream, Token_List).

%% fine tokens

%% secondo livello:
%% grammatica
%% object()
%% array()
%% id()
%% value()
%%
%%
% definizioone della grammar
object(Body) -->
    ['OPEN_CURLYB'],
    pairlist(Body),
    ['CLOSED_CURLYB'].

array(Body) -->
    ['OPEN_BRACKET'],
    valuelist(Body),
    ['CLOSED_BRACKET'].

pair(Body) -->
    id(),
    [COLON],
    object().



% value can be:
% string()
% number
% obj
% array
% true
% false
% null
% tutti saranno messi come tokens
