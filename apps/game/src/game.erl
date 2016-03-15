-module(game).
-behaviour(supervisor).
-behaviour(application).
-export([init/1, start/2, stop/1, main/1]).
-compile(export_all).

main(A) -> start(normal, []).

start(_StartType, _StartArgs) ->
  application:start(mnesia),
  application:start(ranch),
  supervisor:start_link({local,game},game,[]).

init([]) ->
  RanchSupSpec = {ranch_sup, {ranch_sup, start_link, []},
		permanent, 5000, supervisor, [ranch_sup]},
	ListenerSpec = ranch:child_spec(fufu, 100,
		ranch_tcp, [{port, 8000}],
		cowboy_protocol, [{env, [{dispatch, dispatch()}]}]
	),
  {ok, { {one_for_one, 5, 10}, [ListenerSpec]} }.

dispatch() ->
  cowboy_router:compile([
  {'_', [
    {"/", cowboy_static, {priv_file, game, "templates/index.html"}},
    {"/ws", ws_handler, []},
    {"/templates/[...]", cowboy_static, {priv_dir, game, "templates"}},
    {"/scripts/[...]", cowboy_static, {priv_dir, game, "scripts"}}
    ]}
  ]).

stop(_)    -> ok.
