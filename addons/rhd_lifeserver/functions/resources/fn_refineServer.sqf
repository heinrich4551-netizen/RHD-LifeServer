/*
    Server-authoritative RHD processing validation.
    3DEN processing stations define their ProcessAction class and radius.
    Legacy rhd_process_<ProcessActionClass>_<id> markers remain supported.
*/
if (!isServer) exitWith {false};
params ['_player','_input','_output',['_amount',1]];
if (isNull _player || {!isPlayer _player} || {!alive _player}) exitWith {false};
if (_input isEqualTo '' || {_output isEqualTo ''}) exitWith {false};

private _processRoot = missionConfigFile >> 'ProcessAction';
private _recipeCfg = configNull;
private _processName = '';
{
    private _candidate = _x;
    private _req = getArray (_candidate >> 'MaterialsReq');
    private _give = getArray (_candidate >> 'MaterialsGive');
    if (count _req > 0 && {count _give > 0}) then {
        if (((_req select 0) select 0) isEqualTo _input && {((_give select 0) select 0) isEqualTo _output}) exitWith {
            _recipeCfg = _candidate;
            _processName = toLower (configName _candidate);
        };
    };
} forEach configClasses _processRoot;
if (!isClass _recipeCfg) exitWith {false};

private _stations = missionNamespace getVariable ['RHD_ProcessStations',[]];
private _atStation = false;
{
    if (count _x >= 3) then {
        private _pos = _x select 0;
        private _stationProcess = toLower (_x select 1);
        private _radius = (_x select 2) max 1;
        if (_stationProcess isEqualTo _processName && {_player distance2D _pos <= _radius}) exitWith {_atStation = true;};
    };
} forEach _stations;
if (!_atStation) exitWith {false};

private _req = getArray (_recipeCfg >> 'MaterialsReq');
private _give = getArray (_recipeCfg >> 'MaterialsGive');
private _reqQty = ((_req select 0) select 1) max 1;
private _giveQty = ((_give select 0) select 1) max 1;
private _batches = (_amount max 1) min 20;
private _inputAmount = _batches * _reqQty;
private _outputAmount = _batches * _giveQty;

private _cooldownKey = format ['RHD_RefineCooldown_%1',getPlayerUID _player];
private _nextAllowed = missionNamespace getVariable [_cooldownKey,0];
if (diag_tickTime < _nextAllowed) exitWith {false};
missionNamespace setVariable [_cooldownKey,diag_tickTime + 2];

private _eden = missionNamespace getVariable ['RHD_EdenConfig',createHashMap];
if (_eden getOrDefault ['dynamicPricing',true]) then {
    [_input,0,_inputAmount] call RHD_fnc_recordMarket;
    [_output,_outputAmount,0] call RHD_fnc_recordMarket;
};

[_input,_output,_inputAmount,_outputAmount] remoteExecCall ['RHD_fnc_refineResult',_player];
true
