/*
    Server-authoritative RHD harvest validation.
    Marker format: rhd_resource_<virtualItem>_<id>
*/
if (!isServer) exitWith {false};
params ["_player", "_item"];
if (isNull _player || {!isPlayer _player}) exitWith {false};
if (_item isEqualTo "") exitWith {false};

private _nodes = missionNamespace getVariable ["RHD_ResourceNodes", []];
private _nearDist = 12;
private _nodeMarker = "";
{
    _x params ["_marker", "_pos", "_nodeItem"];
    if (_nodeItem isEqualTo _item) then {
        private _d = _player distance2D _pos;
        if (_d < _nearDist) then {
            _nearDist = _d;
            _nodeMarker = _marker;
        };
    };
} forEach _nodes;
if (_nodeMarker isEqualTo "") exitWith {false};

private _cooldownKey = format ["RHD_HarvestCooldown_%1", getPlayerUID _player];
private _nextAllowed = missionNamespace getVariable [_cooldownKey, 0];
if (diag_tickTime < _nextAllowed) exitWith {false};
missionNamespace setVariable [_cooldownKey, diag_tickTime + 5];

private _root = configFile >> "RHD_Resources";
private _cfg = configNull;
{
    private _group = _x;
    {
        private _candidate = _x;
        if (isClass _candidate && {(toLower (getText (_candidate >> "item"))) isEqualTo (toLower _item)}) exitWith {
            _cfg = _candidate;
        };
    } forEach configClasses _group;
    if (isClass _cfg) exitWith {};
} forEach [
    _root >> "Farming",
    _root >> "Mining"
];
if (!isClass _cfg) exitWith {false};

private _min = getNumber (_cfg >> "min");
private _max = getNumber (_cfg >> "max");
if (_min <= 0 || {_max < _min}) exitWith {false};
private _amount = floor (_min + random (_max - _min + 1));

[_item, _amount] remoteExecCall ["RHD_fnc_harvestResult", _player];
true
