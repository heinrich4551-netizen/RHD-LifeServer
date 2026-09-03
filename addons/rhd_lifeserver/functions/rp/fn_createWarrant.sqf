/* Server-internal warrant creation. [targetUID,reason,durationSeconds] call RHD_fnc_createWarrant */
if (!isServer || {isRemoteExecuted}) exitWith {false};
params [['_uid',''],['_reason',''],['_duration',3600]];
if (_uid isEqualTo '' || {_reason isEqualTo ''}) exitWith {false};
private _w = missionNamespace getVariable ['RHD_Warrants',createHashMap];
private _id = format ['W-%1-%2',floor diag_tickTime,floor random 10000];
_w set [_id,[_id,_uid,_reason,diag_tickTime,diag_tickTime + (_duration max 60),2]];
missionNamespace setVariable ['RHD_Warrants',_w,true];
true
