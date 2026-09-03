/*
    Save one RHD state blob through the upstream Framework extDB3 adapter.
    [stateKey,value] call RHD_fnc_saveState
*/
if (!isServer) exitWith {false};
params [['_key',''],['_value',nil]];
if (_key isEqualTo '' || {isNil '_value'}) exitWith {false};
if (isNil 'DB_fnc_asyncCall') exitWith {false};

private _safeKey = [_key] call DB_fnc_mresString;
private _payload = [str _value] call DB_fnc_mresString;
private _query = format [
    "INSERT INTO rhd_state (state_key,payload) VALUES ('%1','%2') ON DUPLICATE KEY UPDATE payload=VALUES(payload)",
    _safeKey,
    _payload
];
[_query,1] call DB_fnc_asyncCall;
true
