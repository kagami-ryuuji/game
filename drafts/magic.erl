-module(magic).
-behavoiur(effect).
-compile(export_all).

%% Активация эффекта
activate(Char, Player, Effect#effect{pid=undefined}) ->
    action_attack:cancel(Char, Player),
    effect:start(Char, Player, Effect);

activate(Char, Player, #effect{data={{CastTime, ReuseTime}, ready}} = Effect) ->
    {timeout, CastTime, Effect#effect{data={{CastTime, ReuseTime}, casting}}};

activate(Char, Player, #effect{data={{CastTime, ReuseTime}, casting}} = Effect) ->
    % считаем потенциальный урон
    % отправляем противнику
    {timeout, ReuseTime, Effect#effect{data={{CastTime, ReuseTime}, about_ready}}};

activate(Char, Player, #effect{data={Time, about_ready}} = Effect) ->
    ok.

%% Реакция на эффект
reaction(Char, Player, Attacker, Effect) ->
    % считаем реальный урон
    ok.
