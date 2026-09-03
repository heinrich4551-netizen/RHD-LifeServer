if (!isServer) exitWith {};

private _players = count (allPlayers select {isPlayer _x && {!(_x isKindOf "HeadlessClient_F")}});
private _target = (115 - ((_players max 1) - 1) * 10) max 60 min 115;
private _civilians = missionNamespace getVariable ["RHD_CivilianAgents", []];
_civilians = _civilians select {!isNull _x};
missionNamespace setVariable ["RHD_CivilianAgents", _civilians];

private _delta = _target - count _civilians;
if (_delta > 0 && {_players > 0}) then {
    private _classes = ["C_man_1","C_man_1_1_F","C_man_1_2_F","C_man_1_3_F","C_man_p_fugitive_F","C_man_p_beggar_F","C_man_p_shorts_1_F"];
    for "_i" from 1 to (_delta min 12) do {
        private _anchor = selectRandom (allPlayers select {isPlayer _x && {!(_x isKindOf "HeadlessClient_F")}});
        if (!isNull _anchor) then {
            private _pos = [_anchor, 300 + random 900, random 360] call BIS_fnc_relPos;
            if (surfaceIsWater _pos) then {_pos = getPosATL _anchor;};
            private _agent = createAgent [selectRandom _classes, _pos, [], 0, "NONE"];
            _agent setVariable ["RHD_CivilianAgent", true, true];
            _civilians pushBack _agent;
        };
    };
};

missionNamespace setVariable ["RHD_CivilianAgents", _civilians];
[] call RHD_fnc_cleanupPopulation;
