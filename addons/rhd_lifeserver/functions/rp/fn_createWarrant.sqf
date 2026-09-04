/* Server-internal warrant creation. [targetUID,reason,durationSeconds] call RHD_fnc_createWarrant */
if (!isServer) exitWith {false};
params [['_uid',''],['_reason',''],['_duration',3600,[0]]];
if (_uid isEqualTo '' || {_reason isEqualTo ''}) exitWith {false};
if (count _uid != 17) exitWith {false};
private _safeUID = _uid select {(_x >= '0') && (_x <= '9')};
if (_safeUID != _uid) exitWith {false};
_reason = _reason select [0,256];
_duration = (_duration max 60) min (30 * 24 * 3600);

private _w = missionNamespace getVariable ['RHD_Warrants',createHashMap];
private _id = format ['W-%1-%2',floor diag_tickTime,floor random 10000];
_w set [_id,[_id,_uid,_reason,diag_tickTime,diag_tickTime + _duration,2]];
missionNamespace setVariable ['RHD_Warrants',_w,true];
true
