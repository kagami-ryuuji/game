-module(send_after).
-compile(export_all).

start(N) ->
    spawn(?MODULE, init0, [N]).

init0(N) ->
    loop(N).

loop(0) -> erlang:send_after(20000, self(), stop), loop({0, 0});
loop({stop, {0, Sum}}) -> io:format("~p (secs)~n", [{0, Sum}]);
loop({stop, {Count, Sum}}) -> io:format("~p (secs)~n", [{Count, Sum, Sum / Count}]);
loop({Count, Sum}) ->
    NewState = receive
        {delayed, X} -> {Count+1, Sum + X};
        {ok, 0} -> {Count, Sum};
        stop -> {stop, {Count, Sum / 1000}}
    end,
    loop(NewState);
loop(N) -> start_effect(), loop(N-1).

start_effect() ->
    spawn(?MODULE, init, [self()]).

init(Parent) ->
    Timeout = random:uniform(15) * 1000,
    erlang:send_after(Timeout, self(), stop),
    loop(Parent, Timeout, erlang:monotonic_time(milli_seconds)).

loop(Parent, Timeout, MS) ->
    receive
        stop ->
            MS2 = erlang:monotonic_time(milli_seconds),
            case MS2-MS - Timeout of
                X when X > 10 -> Parent ! {delayed, X};
                X -> Parent ! {ok, 0}
            end
    end.
