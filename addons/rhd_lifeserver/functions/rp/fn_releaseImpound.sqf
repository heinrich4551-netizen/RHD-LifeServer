/*
    Authenticated server-side impound release.
    [caller,impoundId,vehicle] call RHD_fnc_releaseImpound

    The server derives the recorded impound fee. A future economy/payment
    adapter can debit the player before this state transition; this function
    never trusts a client-reported payment amount.
*/
if (!isServer) exitWith {false};
params [['_caller',objNull,[objNull]],['_id',''],['_vehicle',objNull,[objNull]]];
if (isNull _caller || {!alive _caller}) exitWith {false};
if (_id isEqualTo '' || {isNull _vehicle}) exitWith {false};
if (_caller distance _vehicle > 15) exitWith {false};
private _uid = getPlayerUID _caller;
if (_uid isEqualTo '') exitWith {false};
private _impounds = missionNamespace getVariable ['RHD_Impounds',createHashMap];
private _entry = _impounds getOrDefault [_id,[]];
if (_entry isEqualTo [] || {count _entry < 8}) exitWith {false};
private _netId = _entry param [1,''];
if (_netId isEqualTo '' || {netId _vehicle != _netId}) exitWith {false};
private _status = _entry param [6,2];
if (_status isEqualTo 3) exitWith {false};
private _fee = round ((_entry param [4,0]) max 0);
_vehicle setVariable ['RHD_Impounded',false,true];
_entry set [6,3];
_entry set [8,_uid];
_entry set [9,diag_tickTime];
_impounds set [_id,_entry];
missionNamespace setVariable ['RHD_Impounds',_impounds,true];
[['IMPOUND_RELEASED',_id,_fee]] remoteExecCall ['RHD_fnc_rpResult',owner _caller];
true
