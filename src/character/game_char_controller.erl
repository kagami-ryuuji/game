-module(game_char_controller).
-compile(export_all).

update(Char) ->
  Char.

handle({item, Id}, Char) ->
  {ok, Char}.
