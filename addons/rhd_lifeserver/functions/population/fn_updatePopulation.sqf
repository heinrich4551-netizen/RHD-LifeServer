if (!isServer) exitWith {};

private _players = count (allPlayers select {isPlayer _x && {!(_x isKindOf 'HeadlessClient_F')}});
private _cfg = missionNamespace getVariable ['RHD_EdenConfig',createHashMap];
private _onePlayer = _cfg getOrDefault ['civiliansAtOnePlayer',115];
private _minimum = _cfg getOrDefault ['minimumCivilians',60];
private _maximum = _cfg getOrDefault ['maximumCivilians',115];
private _scale = _cfg getOrDefault ['populationScaleWithPlayers',true];

_onePlayer = (_onePlayer max _minimum) min _maximum;
_minimum = _minimum max 0;
_maximum = _maximum max _minimum;

private _target = if (_players <= 0) then {
    0
} else {
    if (_scale) then {
        /* Preserve the requested 115 at one player and reduce by the same
           amount per additional active player until the configured floor. */
        ((_onePlayer - ((_players max 1) - 1) * 10) max _minimum) min _maximum
    } else {
        _onePlayer
    }
};

private _civilians = missionNamespace getVariable ['RHD_CivilianAgents',[]];
_civilians = _civilians select {!isNull _x};
missionNamespace setVariable ['RHD_CivilianAgents',_civilians];

private _delta = _target - count _civilians;
if (_delta > 0 && {_players > 0}) then {
    private _classes = ['C_man_1','C_man_1_1_F','C_man_1_2_F','C_man_1_3_F','C_man_p_fugitive_F','C_man_p_beggar_F','C_man_p_shorts_1_F'];
    for '_i' from 1 to (_delta min 12) do {
        private _anchor = selectRandom (allPlayers select {isPlayer _x && {!(_x isKindOf 'HeadlessClient_F')}});
        if (!isNull _anchor) then {
            private _pos = [_anchor,300 + random 900,random 360] call BIS_fnc_relPos;
            if (surfaceIsWater _pos) then {_pos = getPosATL _anchor;};
            private _agent = createAgent [selectRandom _classes,_pos,[],0,'NONE'];
            _agent setVariable ['RHD_CivilianAgent',true,true];
            _civilians pushBack _agent;
        };
    };
};

missionNamespace setVariable ['RHD_CivilianAgents',_civilians];
[] call RHD_fnc_cleanupPopulation;
