-module(game).
-behaviour(supervisor).
-behaviour(application).
-export([init/1, start/2, stop/1, main/1]).
-compile(export_all).

main(A) -> start(normal, []).

start(_StartType, _StartArgs) ->
  Dispatch = cowboy_router:compile([
  {'_', [
    {"/", cowboy_static, {priv_file, game, "templates/index.html"}},
    {"/ws", ws_handler, []},
    {"/templates/[...]", cowboy_static, {priv_dir, game, "templates"}},
    {"/scripts/[...]", cowboy_static, {priv_dir, game, "scripts"}}
    ]}
  ]),
  cowboy:start_http(my_http_listener, 100, [{port, 8080}],
    [{env, [{dispatch, Dispatch}]}]
  ),
  supervisor:start_link({local,game},game,[]).

init([]) ->
    {ok, { {one_for_one, 5, 10}, []} }.

stop(_)    -> ok.
