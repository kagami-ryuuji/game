-module(game_ws_handler).

-export([init/2]).
-export([websocket_handle/3]).
-export([websocket_info/3]).

init(Req, Opts) ->
	{cowboy_websocket, Req, Opts}.

websocket_handle({text, Msg}, Req, State) ->
	{reply, {text, Msg}, Req, State};

websocket_handle({binary, <<131,104,2,100,0,7,99,111,110,116,114,111,108, Msg/binary>>}, Req, Char) ->
	game_char_controller:handle(binary_to_term(<<131, Msg/binary>>), Char),
	{reply, {text, unicode:characters_to_binary(<<"Контроллер"/utf8>>)}, Req, Char};
websocket_handle(Data, Req, State) ->
	{ok, Req, State},
	{reply, {text, << "X-FILES" >>}, Req, State}.

websocket_info(_Info, Req, State) ->
	{ok, Req, State}.
