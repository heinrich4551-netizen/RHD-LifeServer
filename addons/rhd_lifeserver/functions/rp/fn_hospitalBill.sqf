/*
    Server-internal hospital bill record.
    [caller,targetUID] call RHD_fnc_hospitalBill
    Standard hospital billing uses the server-configured treatment fee.
*/
if (!isServer) exitWith {false};
params [['_caller',objNull,[objNull]],['_uid','']];
if (isNull _caller || {!alive _caller}) exitWith {false};
if (_uid isEqualTo '') exitWith {false};
if (count _uid != 17) exitWith {false};
private _safeUID = _uid select {(_x >= '0') && (_x <= '9')};
if (_safeUID != _uid) exitWith {false};
private _target = allPlayers select {getPlayerUID _x isEqualTo _uid} param [0,objNull];
if (isNull _target || {!alive _target}) exitWith {false};
if (_caller distance _target > 10) exitWith {false};
private _amount = round (getNumber (missionConfigFile >> 'RHD_RP' >> 'Fees' >> 'treatment'));
_amount = (_amount max 0) min 1000000;
if (_amount <= 0) exitWith {false};
private _description = 'Hospital service';

if !([_target,'CHARGE','CASH',_amount,_description] call RHD_fnc_financialTransaction) exitWith {
    [['HOSPITAL_BILL_DENIED',_amount]] remoteExecCall ['RHD_fnc_rpResult',owner _caller];
    false
};

private _bills = missionNamespace getVariable ['RHD_HospitalBills',createHashMap];
private _id = format ['HB-%1-%2',floor diag_tickTime,floor random 10000];
_bills set [_id,[_id,_uid,_amount,_description,diag_tickTime,true,2]];
missionNamespace setVariable ['RHD_HospitalBills',_bills,true];
[['HOSPITAL_BILL',_amount]] remoteExecCall ['RHD_fnc_rpResult',owner _caller];
true
