-module(gameserver).
-export([start/0]).

start() ->
  application:start(crypto),
  application:start(cowlib),
  application:start(ranch),
  application:start(cowboy),
  application:start(gameserver).
