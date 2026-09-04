/*
    Authenticated server-side impound release.
    [impoundId,vehicle,feePaid] call RHD_fnc_releaseImpound
*/
if (!isServer || {!isRemoteExecuted}) exitWith {false};
params [['_id',''],['_vehicle',objNull,[objNull]],['_feePaid',0,[0]]];
if (_id isEqualTo '' || {isNull _vehicle}) exitWith {false};

private _caller = allPlayers select {owner _x isEqualTo remoteExecutedOwner} param [0,objNull];
if (isNull _caller || {!alive _caller}) exitWith {false};
private _uid = getPlayerUID _caller;
if (_uid isEqualTo '') exitWith {false};

private _impounds = missionNamespace getVariable ['RHD_Impounds',createHashMap];
private _entry = _impounds getOrDefault [_id,[]];
if (_entry isEqualTo [] || {count _entry < 8}) exitWith {false};
private _netId = _entry param [1,''];
if (_netId isEqualTo '' || {netId _vehicle != _netId}) exitWith {false};

private _fee = round ((_entry param [4,0]) max 0);
private _paid = round ((_feePaid max 0) min 1000000);
if (_paid < _fee) exitWith {false};

_vehicle setVariable ['RHD_Impounded',false,true];
_entry set [6,3];
_entry set [8,_uid];
_entry set [9,diag_tickTime];
_impounds set [_id,_entry];
missionNamespace setVariable ['RHD_Impounds',_impounds,true];

['IMPOUND_RELEASED',_id,_fee] remoteExecCall ['RHD_fnc_rpResult',owner _caller];
true
