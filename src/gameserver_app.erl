-module(gameserver_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

%% ===================================================================
%% Application callbacks
%% ===================================================================

start(_StartType, _StartArgs) ->
  Dispatch = cowboy_router:compile([
    {'_', [
			{"/", cowboy_static, {priv_file, game, "index.html"}},
      {"/websocket", ws_handler, []},
			{"/static/[...]", cowboy_static, {priv_dir, game, "static"}}
    ]}
  ]),
  cowboy:start_http(my_http_listener, 100, [{port, 8080}],
    [{env, [{dispatch, Dispatch}]}]
  ),
  gameserver_sup:start_link().

stop(_State) ->
  ok.
