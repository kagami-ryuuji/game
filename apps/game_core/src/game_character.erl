-module(game_character).
-behaviour(gen_server).
-compile(export_all).

handle(Character, {item, Id}) ->
    %% Не все так просто :)
    nw:send(Character, {text, <<"You used an item">>}).

init(Character) ->
    {ok, Character}.
