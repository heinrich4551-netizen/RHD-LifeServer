/*
    Server-side hospital bill record.
    [targetUID,amount,description] call RHD_fnc_hospitalBill
*/
if (!isServer) exitWith {false};
params [['_uid',''],['_amount',0,[0]],['_description','Hospital service']];
if (_uid isEqualTo '' || {_amount <= 0}) exitWith {false};
private _bills = missionNamespace getVariable ['RHD_HospitalBills',createHashMap];
private _id = format ['HB-%1-%2',floor diag_tickTime,floor random 10000];
_bills set [_id,[_id,_uid,_amount,_description,diag_tickTime,false,remoteExecutedOwner]];
missionNamespace setVariable ['RHD_HospitalBills',_bills,true];
[_id,_amount,_description] remoteExecCall ['RHD_fnc_rpResult',remoteExecutedOwner];
true
