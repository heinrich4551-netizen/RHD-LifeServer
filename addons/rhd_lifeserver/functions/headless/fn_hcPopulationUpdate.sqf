/*
    Optional Headless Client civilian population manager.
    The server remains authoritative for the target population and only sends
    the target count here. The HC owns the local AI simulation.
*/
if (!isHeadlessClient || {!isRemoteExecuted} || {remoteExecutedOwner != 2}) exitWith {false};
params [['_target',0,[0]],['_spawnBatch',20,[0]],['_despawnDistance',1200,[0]]];
_target = round (_target max 0);
_spawnBatch = round ((_spawnBatch max 1) min 50);
_despawnDistance = (_despawnDistance max 300) min 5000;

private _agents = missionNamespace getVariable ['RHD_HCCivilianAgents',[]];
_agents = _agents select {!isNull _x && {alive _x}};

if (count _agents < _target) then {
    private _anchors = allPlayers select {isPlayer _x && {!(_x isKindOf 'HeadlessClient_F')}};
    if !(_anchors isEqualTo []) then {
        private _classes = ['C_man_1','C_man_1_1_F','C_man_1_2_F','C_man_1_3_F','C_man_p_fugitive_F','C_man_p_beggar_F','C_man_p_shorts_1_F'];
        private _spawnCount = (( _target - count _agents) min _spawnBatch) max 0;
        for '_i' from 1 to _spawnCount do {
            private _anchor = selectRandom _anchors;
            private _pos = [_anchor,300 + random 900,random 360] call BIS_fnc_relPos;
            if (surfaceIsWater _pos) then {_pos = getPosATL _anchor;};
            private _agent = createAgent [selectRandom _classes,_pos,[],0,'NONE'];
            _agent setVariable ['RHD_CivilianAgent',true,true];
            _agents pushBack _agent;
        };
    };
};

if (count _agents > _target) then {
    private _removeCount = (count _agents - _target) min _spawnBatch;
    for '_i' from 1 to _removeCount do {
        private _agent = _agents deleteAt 0;
        if (!isNull _agent) then {deleteVehicle _agent;};
    };
};

/* Cull only RHD-managed civilians that have moved far from every player. */
private _players = allPlayers select {isPlayer _x && {!(_x isKindOf 'HeadlessClient_F')}};
_agents = _agents select {
    private _keep = if (_players isEqualTo []) then {false} else {
        private _nearest = _players apply {_x distance2D _this};
        (selectMin _nearest) <= _despawnDistance
    };
    if (!_keep) then {deleteVehicle _this;};
    _keep
};

missionNamespace setVariable ['RHD_HCCivilianAgents',_agents];
missionNamespace setVariable ['RHD_HCCivilianCount',count _agents,true];
true
