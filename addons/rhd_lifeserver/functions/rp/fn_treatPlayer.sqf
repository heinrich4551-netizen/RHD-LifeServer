/*
    Authenticated EMS treatment action.
    Called by RHD_fnc_rpAction after MEDIC authorization.
    [medic,target,fee] call RHD_fnc_treatPlayer

    This intentionally uses the Arma damage interface rather than inventing an
    upstream revive API. Framework-specific revive integrations can call this
    action after adapting their own revive state.
*/
if (!isServer) exitWith {false};
params [['_medic',objNull,[objNull]],['_target',objNull,[objNull]],['_fee',0,[0]]];
if (isNull _medic || {isNull _target}) exitWith {false};
if (isRemoteExecuted && {!(_medic isEqualTo (allPlayers select {owner _x isEqualTo remoteExecutedOwner} param [0,objNull]))}) exitWith {false};
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

private _owner = owner _target;
['TREATMENT',_charge] remoteExecCall ['RHD_fnc_rpResult',_owner];
true
