-module(game_char_controller).
-compile(export_all).

update(Char, Module, Data) ->
  Char.

handle({item, Id}, Char) ->
  {ok, Char}.
