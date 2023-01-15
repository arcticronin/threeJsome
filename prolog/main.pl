:- use_module(tokenizersplit).
:- use_module(parser).


%% try to follow a TOP DOWN tecnique
%% using a tokenizer first, 
%% then a recursive descent on top of that.


%% imported predicates for short:

%% from tokenizer, everything is private except
%string_tokens/2 (just for debug here)

%% from parser
%jsonparse/2
%jsonaccess/3
%jsonread/2