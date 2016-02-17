-record(char_servers, {
    self,              % pid()
    attack,            % pid()
    defence,           % pid()
    effects,           % effects ets
    triggered_effects, % triggered effects
    stats              % tuple()
}).

-record(char_stats, {
    name, % binary()
    hp,   % integer()
    mp    % integer()
}).
