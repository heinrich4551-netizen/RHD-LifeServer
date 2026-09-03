if (!isServer) exitWith {false};
params ["_unit", "_input", "_output", ["_ratio", 1]];
if (isNull _unit || {!isPlayer _unit}) exitWith {false};
private _recipes = [
    ["iron_ore","iron",1],
    ["copper_ore","copper",1],
    ["gold_ore","gold",1],
    ["oil_sand","fuel",1]
];
private _recipe = _recipes select {(_x select 0) isEqualTo _input && {(_x select 1) isEqualTo _output}};
if (_recipe isEqualTo []) exitWith {false};
_recipe = _recipe select 0;
private _inKey = format ["RHD_VItem_%1", _input];
private _outKey = format ["RHD_VItem_%1", _output];
private _available = _unit getVariable [_inKey, 0];
private _take = (_ratio max 1) min 50 min _available;
if (_take < 1) exitWith {false};
_unit setVariable [_inKey, _available - _take, true];
private _yield = floor (_take * (_recipe select 2));
_unit setVariable [_outKey, (_unit getVariable [_outKey, 0]) + _yield, true];
true
