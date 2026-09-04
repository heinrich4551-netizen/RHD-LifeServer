/*
    Server-internal hospital bill record.
    [targetUID,amount,description] call RHD_fnc_hospitalBill
*/
if (!isServer || {isRemoteExecuted}) exitWith {false};
params [['_uid',''],['_amount',0,[0]],['_description','Hospital service']];
if (_uid isEqualTo '' || {_amount <= 0}) exitWith {false};
if (count _uid != 17) exitWith {false};
private _safeUID = _uid select {(_x >= '0') && (_x <= '9')};
if (_safeUID != _uid) exitWith {false};
_amount = round ((_amount max 1) min 1000000);
_description = _description select [0,256];

private _bills = missionNamespace getVariable ['RHD_HospitalBills',createHashMap];
private _id = format ['HB-%1-%2',floor diag_tickTime,floor random 10000];
_bills set [_id,[_id,_uid,_amount,_description,diag_tickTime,false,2]];
missionNamespace setVariable ['RHD_HospitalBills',_bills,true];
true
