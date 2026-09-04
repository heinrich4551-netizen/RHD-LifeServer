/*
    RHD economy telemetry dashboard.
    Server-only; privileged requests are routed through RHD_fnc_rpAction.
    Returns bounded live price/supply/demand telemetry to the requesting admin.
*/
if (!isServer || {!isRemoteExecuted}) exitWith {false};
private _caller = allPlayers select {owner _x isEqualTo remoteExecutedOwner} param [0,objNull];
if (isNull _caller || {!alive _caller}) exitWith {false};

private _uid = getPlayerUID _caller;
if (_uid isEqualTo '' || {count _uid != 17}) exitWith {false};
private _safeUID = _uid select {(_x >= '0') && (_x <= '9')};
if (_safeUID != _uid) exitWith {false};
if (isNil 'DB_fnc_asyncCall') exitWith {false};

private _result = [format ["SELECT adminlevel FROM players WHERE pid='%1' LIMIT 1",_uid],2] call DB_fnc_asyncCall;
if !(_result isEqualType [] && {count _result > 0}) exitWith {false};
private _adminLevel = [_result param [0,0]] call RHD_fnc_numberSafe;
if (_adminLevel < 1) exitWith {false};

private _prices = missionNamespace getVariable ['RHD_EconomyPrices',createHashMap];
private _rows = [];
{
    private _entry = _prices getOrDefault [_x,[]];
    if (count _entry >= 4) then {
        private _base = round (_entry param [0,0]);
        private _current = round (_entry param [1,0]);
        private _demand = round ((_entry param [2,1]) * 100) / 100;
        private _supply = round ((_entry param [3,1]) * 100) / 100;
        _rows pushBack [_x,_base,_current,_demand,_supply];
    };
} forEach keys _prices;

_rows sort false;
if (count _rows > 25) then {_rows resize 25;};
private _marketEvent = missionNamespace getVariable ['RHD_MarketEventMultiplier',1];
private _event = missionNamespace getVariable ['RHD_CurrentWorldEvent',[]];
private _summary = [count _prices,round (_marketEvent * 100) / 100,_event,_rows];
['ECONOMY_DASHBOARD',_summary] remoteExecCall ['RHD_fnc_rpResult',owner _caller];
true
