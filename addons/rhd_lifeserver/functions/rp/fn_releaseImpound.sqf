/*
    Authenticated server-side impound release.
    [caller,impoundId,vehicle] call RHD_fnc_releaseImpound

    The server derives the recorded impound fee and vehicle owner. The owner
    must be online for a fee-bearing release so the Framework account can be
    charged and synchronized safely.
*/
if (!isServer) exitWith {false};
params [['_caller',objNull,[objNull]],['_id',''],['_vehicle',objNull,[objNull]]];
if (isNull _caller || {!alive _caller}) exitWith {false};
if (_id isEqualTo '' || {isNull _vehicle}) exitWith {false};
if (_caller distance _vehicle > 15) exitWith {false};
private _executorUID = getPlayerUID _caller;
if (_executorUID isEqualTo '') exitWith {false};
private _impounds = missionNamespace getVariable ['RHD_Impounds',createHashMap];
private _entry = _impounds getOrDefault [_id,[]];
if (_entry isEqualTo [] || {count _entry < 8}) exitWith {false};
private _netId = _entry param [1,''];
if (_netId isEqualTo '' || {netId _vehicle != _netId}) exitWith {false};
private _status = _entry param [6,2];
if (_status isEqualTo 3) exitWith {false};
private _fee = round ((_entry param [4,0]) max 0);

private _owners = _entry param [2,[]];
private _ownerUID = '';
if (_owners isEqualType [] && {count _owners > 0}) then {
    private _ownerRow = _owners param [0,[]];
    if (_ownerRow isEqualType [] && {count _ownerRow > 0}) then {_ownerUID = _ownerRow param [0,''];};
};
private _payer = if (_ownerUID isEqualTo _executorUID) then {_caller} else {allPlayers select {getPlayerUID _x isEqualTo _ownerUID} param [0,objNull]};
if (_fee > 0 && {isNull _payer || {!alive _payer}}) exitWith {
    [['IMPOUND_PAYMENT_DENIED',_id,_fee]] remoteExecCall ['RHD_fnc_rpResult',owner _caller];
    false
};

if (_fee > 0) then {
    if !([_payer,'CHARGE','CASH',_fee,'Impound release fee'] call RHD_fnc_financialTransaction) exitWith {
        [['IMPOUND_PAYMENT_DENIED',_id,_fee]] remoteExecCall ['RHD_fnc_rpResult',owner _caller];
        false
    };
};

_vehicle setVariable ['RHD_Impounded',false,true];
_entry set [6,3];
_entry set [8,_executorUID];
_entry set [9,diag_tickTime];
_impounds set [_id,_entry];
missionNamespace setVariable ['RHD_Impounds',_impounds,true];
[['IMPOUND_RELEASED',_id,_fee]] remoteExecCall ['RHD_fnc_rpResult',owner _caller];
true
