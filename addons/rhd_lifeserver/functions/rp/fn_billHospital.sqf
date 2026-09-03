/*
    [uid,amount,reason] call RHD_fnc_billHospital.
    Creates a server-side hospital charge record. The persistence/economy
    adapter can settle this against the framework account system.
*/
if (!isServer) exitWith {false};
params [['_uid',''],['_amount',0],['_reason','Hospital treatment']];
if (_uid isEqualTo '' || {_amount <= 0}) exitWith {false};

private _g = missionNamespace getVariable ['RHD_Government',createHashMap];
private _key = format ['hospital:%1:%2',_uid,floor diag_tickTime];
_g set [_key,[_uid,round _amount,_reason,diag_tickTime]];
missionNamespace setVariable ['RHD_Government',_g,true];
true
