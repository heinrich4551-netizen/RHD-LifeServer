/*
    Server-authoritative RHD harvesting.
    Eden resource modules define position, item, radius and yield.
    Legacy rhd_resource_* markers are converted by RHD_fnc_registerNodes.
*/
if (!isServer) exitWith {false};
params ['_player','_item'];
if (isNull _player || {!isPlayer _player} || {!alive _player}) exitWith {false};
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
missionNamespace setVariable [_cooldownKey,diag_tickTime + (_cooldown max 0.1)];

private _min = _best select 3;
private _max = _best select 4;
if (_min <= 0 || {_max < _min}) exitWith {false};

private _root = configFile >> 'RHD_Resources';
private _cfg = configNull;
{
    private _group = _x;
    {
        private _candidate = _x;
        if (isClass _candidate && {(toLower (getText (_candidate >> 'item'))) isEqualTo (toLower _item)}) exitWith {
            _cfg = _candidate;
        };
    } forEach configClasses _group;
    if (isClass _cfg) exitWith {};
} forEach [_root >> 'Farming',_root >> 'Mining'];
if (!isClass _cfg) exitWith {false};

/* A configured Eden node controls yield. Global Eden min/max values act as
   defaults for nodes left at their standard 2/5 or 2/6 values. */
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

[_item,_amount] remoteExecCall ['RHD_fnc_harvestResult',_player];
true
