/* [uid,name,type] call RHD_fnc_createBusiness */
if (!isServer) exitWith {false};
params [['_uid',''],['_name',''],['_type','GENERAL']];
if (_uid isEqualTo '' || {_name isEqualTo ''}) exitWith {false};
private _b = missionNamespace getVariable ['RHD_Businesses',createHashMap];
private _id = format ['B-%1-%2',floor diag_tickTime,floor random 10000];
_b set [_id,[_id,_uid,_name,_type,[],0,diag_tickTime]];
missionNamespace setVariable ['RHD_Businesses',_b,true];
true
