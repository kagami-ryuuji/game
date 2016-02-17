-module(char).
-behaviour(gen_server).
-define(SERVER, ?MODULE).

-include("char.hrl").

%% ------------------------------------------------------------------
%% API Function Exports
%% ------------------------------------------------------------------

-export([start_link/0, update/3]).

%% ------------------------------------------------------------------
%% gen_server Function Exports
%% ------------------------------------------------------------------

-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3]).

%% ------------------------------------------------------------------
%% API Function Definitions
%% ------------------------------------------------------------------

start_link() ->
    gen_server:start_link(?MODULE, [], []).

update(Character, Module, Parameters) ->
    gen_server:call(Character, {update, Module, Parameters}).

%% ------------------------------------------------------------------
%% gen_server Function Definitions
%% ------------------------------------------------------------------

init(CharacterStats) ->
    Effects = [],
    % ets:insert()
    TriggeredEffects = [],
    % ets:insert()
    CharacterData = #char_servers{
        self = self(),
        attack = 0,
        defence = 0,
        effects = 0,
        triggered_effects = 0,
        stats = CharacterStats
    },
    {ok, CharacterData}.

handle_call({update, Module, Parameters}, _From, CharacterData) ->
    io:format("UPDATE: ~p~n", [CharacterData#char_servers.stats]),
    {reply, ok, CharacterData};

handle_call(_Request, _From, State) ->
    {reply, ok, State}.

handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%% ------------------------------------------------------------------
%% Internal Function Definitions
%% ------------------------------------------------------------------
