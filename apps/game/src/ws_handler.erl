-module(ws_handler).

-export([init/3]).
-export([websocket_init/3]).
-export([websocket_handle/3]).
-export([websocket_info/3]).

init({T, P}, Req, Opts) ->
	{upgrade, protocol, cowboy_websocket, Req, Opts}.

websocket_init(T, Req, Opts) ->
	State = [],
	{ok, Req, State}.

websocket_handle({text, <<"bert">>}, Req, State) ->
	{reply, {binary, erlang:term_to_binary({chat, "Announce"})}, Req, State};
websocket_handle({text, Msg}, Req, State) ->
	{reply, {text, Msg}, Req, State};
websocket_handle({binary, Msg}, Req, State) ->
	io:format("~p~n", [erlang:binary_to_term(Msg)]),
	{reply, {text, <<"Binary">>}, Req, State};
websocket_handle(_Data, Req, State) ->
	{ok, Req, State}.

websocket_info(_Info, Req, State) ->
	{ok, Req, State}.
