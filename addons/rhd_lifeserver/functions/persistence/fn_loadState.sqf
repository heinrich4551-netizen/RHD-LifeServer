/*
    Load one RHD state blob from the upstream Framework extDB3 adapter.
    [stateKey,defaultValue] call RHD_fnc_loadState
*/
if (!isServer) exitWith {nil};
params [['_key',''],['_default',nil]];
if (_key isEqualTo '') exitWith {_default};

if (isNil 'DB_fnc_asyncCall') exitWith {
    ['RHD persistence unavailable: DB_fnc_asyncCall is not initialized.'] call RHD_fnc_log;
    _default
};

private _safeKey = [_key] call DB_fnc_mresString;
private _row = [format ["SELECT payload FROM rhd_state WHERE state_key='%1' LIMIT 1",_safeKey],2] call DB_fnc_asyncCall;
if (_row isEqualTo [] || {_row isEqualTo [nil]}) exitWith {_default};

private _payload = if (_row isEqualType []) then {_row param [0,'']} else {''};
if !(_payload isEqualType '') then {_default} else {
    if (_payload isEqualTo '') exitWith {_default};
    private _value = nil;
    try {_value = call compile _payload;} catch {_value = nil;};
    if (isNil '_value') then {_default} else {_value}
}
