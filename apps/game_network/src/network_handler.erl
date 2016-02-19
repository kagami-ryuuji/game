%% -----------------------------------------------------------------------------
%% Kagami's Game
%%
%% Receives network packets via websocket, tcp or udp
%% and translate them into commands for character
%% -----------------------------------------------------------------------------

-module(network_handler).

-export([init/2]).
-export([websocket_handle/3]).
-export([websocket_info/3]).

-include("nw.hrl").

init(Req, Opts) ->
	{cowboy_websocket, Req, #nw_state{connection=Req#http_req.pid, character=pid}}.

websocket_handle({text, Msg}, Req, State) ->
	{reply, {text, <<":", Msg/binary>>}, Req, State};

websocket_handle({binary, <<131,104,2,100,0,7,99,111,110,116,114,111,108, Msg/binary>>}, Req, State) ->
    game_character:handle(State, binary_to_term(<<131, Msg/binary>>, [safe])),
	{ok, Req, State};
websocket_handle(Data, Req, CharacterPid) ->
	{ok, Req, CharacterPid}.

websocket_info({text, Msg}, Req, State) ->
	{reply, {text, Msg}, Req, State};

websocket_info(_Info, Req, State) ->
	{ok, Req, State}.
