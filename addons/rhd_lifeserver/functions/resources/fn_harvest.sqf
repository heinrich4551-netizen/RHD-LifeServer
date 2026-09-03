if (!isServer) exitWith {false};
params ["_unit", "_item", ["_amount", 1]];
if (isNull _unit || {!isPlayer _unit}) exitWith {false};
private _nodes = missionNamespace getVariable ["RHD_ResourceNodes", []];
private _node = _nodes select {
    _x params ["_marker","_pos","_nodeItem"];
    (_nodeItem isEqualTo _item) && {(_unit distance2D _pos) < 12}
};
if (_node isEqualTo []) exitWith {false};

private _cooldown = _unit getVariable ["RHD_HarvestCooldown", 0];
if (diag_tickTime < _cooldown) exitWith {false};
_unit setVariable ["RHD_HarvestCooldown", diag_tickTime + 5];

private _give = (_amount max 1) min 25;
_unit setVariable [format ["RHD_VItem_%1", _item], (_unit getVariable [format ["RHD_VItem_%1", _item], 0]) + _give, true];
true
