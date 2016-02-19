-module(game_core_app).

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
    {"/", cowboy_static, {priv_file, game_core, "index.html"}},
    {"/websocket", network_handler, []},
    {"/static/[...]", cowboy_static, {priv_dir, game_core, "static"}}
    ]}
  ]),
  cowboy:start_http(my_http_listener, 100, [{port, 8080}],
    [{env, [{dispatch, Dispatch}]}]
  ),
  game_core_sup:start_link().

stop(_State) ->
  ok.
