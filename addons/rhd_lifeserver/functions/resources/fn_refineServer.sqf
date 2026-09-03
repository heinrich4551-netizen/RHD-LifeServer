/*
    Server-authoritative RHD processing validation.
    Processing marker format: rhd_process_<ProcessActionClass>_<id>
*/
if (!isServer) exitWith {false};
params ["_player", "_input", "_output", ["_amount", 1]];
if (isNull _player || {!isPlayer _player}) exitWith {false};
if (_input isEqualTo "" || {_output isEqualTo ""}) exitWith {false};

private _stationPrefix = format ["rhd_process_%1_", toLower _output];
private _atStation = false;
{
    private _marker = toLower _x;
    if ((_marker find _stationPrefix) isEqualTo 0 && {_player distance2D (getMarkerPos _x) < 12}) exitWith {
        _atStation = true;
    };
} forEach allMapMarkers;
if (!_atStation) exitWith {false};

private _processCfg = configFile >> "ProcessAction";
private _recipeCfg = _processCfg >> _output;
if (!isClass _recipeCfg) exitWith {false};

private _req = getArray (_recipeCfg >> "MaterialsReq");
private _give = getArray (_recipeCfg >> "MaterialsGive");
if (count _req < 1 || {count _give < 1}) exitWith {false};
if !(((_req select 0) select 0) isEqualTo _input) exitWith {false};
if !(((_give select 0) select 0) isEqualTo _output) exitWith {false};

private _reqQty = ((_req select 0) select 1) max 1;
private _giveQty = ((_give select 0) select 1) max 1;
private _batches = (_amount max 1) min 50;
private _inputAmount = _batches * _reqQty;
private _outputAmount = _batches * _giveQty;

private _cooldownKey = format ["RHD_RefineCooldown_%1", getPlayerUID _player];
private _nextAllowed = missionNamespace getVariable [_cooldownKey, 0];
if (diag_tickTime < _nextAllowed) exitWith {false};
missionNamespace setVariable [_cooldownKey, diag_tickTime + 2];

[_input, _output, _inputAmount, _outputAmount] remoteExecCall ["RHD_fnc_refineResult", _player];
true
