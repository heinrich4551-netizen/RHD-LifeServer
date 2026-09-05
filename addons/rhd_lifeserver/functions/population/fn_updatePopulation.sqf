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
        ((_onePlayer - ((_players max 1) - 1) * 10) max _minimum) min _maximum
    } else {
        _onePlayer
    }
};

private _civilianEventMultiplier = (missionNamespace getVariable ['RHD_CivilianEventMultiplier',1]) max 0.1;
_target = round ((_target * _civilianEventMultiplier) min _maximum) max _minimum;
if (_players <= 0) then {_target = 0;};

private _hcCfg = missionConfigFile >> 'RHD_LifeServer' >> 'HeadlessClient';
private _hcEnabled = isClass _hcCfg && {getNumber (_hcCfg >> 'enabled') isEqualTo 1};
private _hcUsePopulation = _hcEnabled && {getNumber (_hcCfg >> 'useForPopulation') isEqualTo 1};
private _hc = if (_hcUsePopulation) then {
    allPlayers select {isPlayer _x && {_x isKindOf 'HeadlessClient_F'}} param [0,objNull]
} else {objNull};

if (!isNull _hc && {_players > 0}) then {
    private _spawnBatch = (getNumber (_hcCfg >> 'spawnBatch') max 1) min 50;
    private _despawnDistance = getNumber (_hcCfg >> 'despawnDistance');
    if (_despawnDistance <= 0) then {_despawnDistance = 1200;};
    [_target,_spawnBatch,_despawnDistance] remoteExecCall ['RHD_fnc_hcPopulationUpdate',owner _hc];
    missionNamespace setVariable ['RHD_CivilianAgents',[]];
    missionNamespace setVariable ['RHD_CivilianPopulationTarget',_target,true];
    exitWith {};
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
missionNamespace setVariable ['RHD_CivilianPopulationTarget',_target,true];
[] call RHD_fnc_cleanupPopulation;
