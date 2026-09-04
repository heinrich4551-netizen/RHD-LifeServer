/*
    Server-authoritative RHD harvesting.
    Eden resource modules define position, item, radius and yield.
    Legacy rhd_resource_* markers are converted by RHD_fnc_registerNodes.
*/
if (!isServer || {!isRemoteExecuted}) exitWith {false};
params ['_player','_item'];
private _caller = allPlayers select {owner _x isEqualTo remoteExecutedOwner} param [0,objNull];
if (isNull _caller || {_player isNotEqualTo _caller}) exitWith {false};
_player = _caller;
if (!isPlayer _player || {!alive _player}) exitWith {false};
if (_item isEqualTo '') exitWith {false};

private _nodes = missionNamespace getVariable ['RHD_ResourceNodes',[]];
private _best = [];
private _bestDist = 1e10;
{
    if (count _x >= 5) then {
        private _pos = _x select 0;
        private _nodeItem = _x select 1;
        private _radius = (_x select 2) max 1;
        if (_nodeItem isEqualTo _item) then {
            private _d = _player distance2D _pos;
            if (_d <= _radius && {_d < _bestDist}) then {
                _bestDist = _d;
                _best = _x;
            };
        };
    };
} forEach _nodes;
if (_best isEqualTo []) exitWith {false};

private _cooldown = missionNamespace getVariable ['RHD_HarvestCooldown',2];
private _cooldownKey = format ['RHD_HarvestCooldown_%1',getPlayerUID _player];
private _nextAllowed = missionNamespace getVariable [_cooldownKey,0];
if (diag_tickTime < _nextAllowed) exitWith {false};

private _min = _best select 3;
private _max = _best select 4;
if (_min <= 0 || {_max < _min}) exitWith {false};

private _root = configFile >> 'RHD_Resources';
private _cfg = configNull;
{
    private _group = _x;
    {
        private _candidate = _x;
        if (isClass _candidate && {(toLower (getText (_candidate >> 'item'))) isEqualTo (toLower _item)}) exitWith {_cfg = _candidate;};
    } forEach configClasses _group;
    if (isClass _cfg) exitWith {};
} forEach [_root >> 'Farming',_root >> 'Mining'];
if (!isClass _cfg) exitWith {false};

private _eden = missionNamespace getVariable ['RHD_EdenConfig',createHashMap];
private _isMining = isClass (_root >> 'Mining' >> (configName _cfg));
if (_isMining && {_min isEqualTo 2 && {_max isEqualTo 6}}) then {
    _min = _eden getOrDefault ['miningHarvestMin',_min];
    _max = _eden getOrDefault ['miningHarvestMax',_max];
};
if (!_isMining && {_min isEqualTo 2 && {_max isEqualTo 5}}) then {
    _min = _eden getOrDefault ['farmingHarvestMin',_min];
    _max = _eden getOrDefault ['farmingHarvestMax',_max];
};
_min = _min max 1;
_max = _max max _min;
private _amount = floor (_min + random (_max - _min + 1));
private _harvestMultiplier = (missionNamespace getVariable ['RHD_HarvestMultiplier',1]) max 1;
_amount = round (_amount * _harvestMultiplier);
missionNamespace setVariable [_cooldownKey,diag_tickTime + (_cooldown max 0.1)];

private _illegal = getNumber (_cfg >> 'illegal') isEqualTo 1;
private _jobType = if (_isMining) then {'MINING'} else {'FARMING'};

if (_eden getOrDefault ['dynamicPricing',true]) then {
    [_item,_amount,0] call RHD_fnc_recordMarket;
};

private _uid = getPlayerUID _player;
private _jobs = missionNamespace getVariable ['RHD_JobProgress',createHashMap];
private _state = _jobs getOrDefault [_uid,[0,0,1,1,0]];
_state params ['_legalXP','_illegalXP','_legalLevel','_illegalLevel','_harvests'];
private _xp = (_amount max 1) * if (_illegal) then {2} else {1};
if (_illegal) then {_illegalXP = _illegalXP + _xp;} else {_legalXP = _legalXP + _xp;};
_harvests = _harvests + 1;
private _oldLevel = if (_illegal) then {_illegalLevel} else {_legalLevel};
_legalLevel = 1 + floor (_legalXP / 100);
_illegalLevel = 1 + floor (_illegalXP / 100);
private _level = if (_illegal) then {_illegalLevel} else {_legalLevel};
private _leveled = _level > _oldLevel;
_jobs set [_uid,[_legalXP,_illegalXP,_legalLevel,_illegalLevel,_harvests]];
missionNamespace setVariable ['RHD_JobProgress',_jobs,true];

/* Progression rewards are server-side financial transactions. */
if ((_harvests mod 10) isEqualTo 0) then {
    private _reward = 250 + ((_level max 1) * 50);
    [_player,'REWARD','CASH',_reward,'RHD harvest progression bonus'] call RHD_fnc_financialTransaction;
};

[_item,_amount,_jobType,_illegal,_legalXP,_illegalXP,_legalLevel,_illegalLevel,0,_leveled] remoteExecCall ['RHD_fnc_harvestResult',_player];
true
