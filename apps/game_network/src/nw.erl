%% -----------------------------------------------------------------------------
%% Kagami's Game
%%
%% Client-core communication library
%% -----------------------------------------------------------------------------

-module(nw).
-compile(export_all).

-include("nw.hrl").

send(#nw_state{connection = Pid}, Message) ->
    Pid ! Message;

send(Pid, Message) ->
    Pid ! Message.
