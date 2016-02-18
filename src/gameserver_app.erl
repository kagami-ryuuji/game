-module(gameserver_app).

-behaviour(application).

%% Application callbacks
-export([main/1, start/2, stop/1]).

%% ===================================================================
%% Application callbacks
%% ===================================================================

main(A) -> start(normal, []).

start(_StartType, _StartArgs) ->
  Dispatch = cowboy_router:compile([
    {'_', [
			{"/", cowboy_static, {file, "priv/index.html"}},
      {"/websocket", game_ws_handler, []},
			{"/static/[...]", cowboy_static, {dir, "priv/static"}}
    ]}
  ]),
  cowboy:start_http(my_http_listener, 100, [{port, 8080}],
    [{env, [{dispatch, Dispatch}]}]
  ),
  gameserver_sup:start_link().

stop(_State) ->
  ok.
