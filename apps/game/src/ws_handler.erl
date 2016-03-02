-module(ws_handler).

-export([init/2]).
-export([websocket_handle/3]).
-export([websocket_info/3]).

init(Req, Opts) ->
	{cowboy_websocket, Req, Opts}.

websocket_handle({text, <<"bert">>}, Req, State) ->
	{reply, {binary, erlang:term_to_binary({chat, "Announce"})}, Req, State};
websocket_handle({text, Msg}, Req, State) ->
	{reply, {text, Msg}, Req, State};
websocket_handle(_Data, Req, State) ->
	{ok, Req, State}.

websocket_info(_Info, Req, State) ->
	{ok, Req, State}.
