%% -----------------------------------------------------------------------------
%% Kagami's Game
%%
%% Client-core communication library
%% -----------------------------------------------------------------------------

-module(network_client).
-compile(export_all).

-include("nw.hrl").

% INTERFACE

%% Send Message to all clients' chat windows
announce(#nw_state{connection = Pid}, Message) ->
    nw:send(Pid, {text, Message}).
