/*
    Authenticated EMS treatment action.
    [medic,target,fee] call RHD_fnc_treatPlayer
*/
if (!isServer) exitWith {false};
params [['_medic',objNull,[objNull]],['_target',objNull,[objNull]],['_fee',0,[0]]];
if (isNull _medic || {isNull _target}) exitWith {false};
if !(_target isKindOf 'CAManBase') exitWith {false};
if (!alive _medic || {!alive _target}) exitWith {false};
if (_medic distance _target > 10) exitWith {false};
if (_medic isEqualTo _target) exitWith {false};

private _uid = getPlayerUID _target;
if (_uid isEqualTo '' || {count _uid != 17}) exitWith {false};
private _damage = damage _target;
if (_damage <= 0.01) exitWith {false};
_target setDamage 0;

private _charge = round ((_fee max 0) min 100000);
if (_charge > 0) then {
    private _bills = missionNamespace getVariable ['RHD_HospitalBills',createHashMap];
    private _id = format ['HB-%1-%2',floor diag_tickTime,floor random 10000];
    _bills set [_id,[_id,_uid,_charge,'EMS treatment',diag_tickTime,false,2]];
    missionNamespace setVariable ['RHD_HospitalBills',_bills,true];
};

['TREATMENT',_charge] remoteExecCall ['RHD_fnc_rpResult',owner _medic];
true
