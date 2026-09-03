/* [uid,amount,reason] call RHD_fnc_billHospital. Money is held as a server-side charge record until the framework economy adapter applies it. */
if (!isServer) exitWith {false};
params [['_uid',''],['_amount',0],['_reason','Hospital treatment']];
if (_uid isEqualTo '' || {_amount <= 0}) exitWith {false};
private _g = missionNamespace getVariable ['RHD_Government',createHashMap];
private _key = format ['hospital:%1:%2',_uid,floor diag_tickTime];
_g set [_key,[_uid,round _amount,_reason,diag_tickTime]];
missionNamespace setVariable ['RHD_Government',_g,true];
true
