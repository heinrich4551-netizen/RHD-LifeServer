/*
    Authenticated contract completion acknowledgement.
    The client sends only the server-issued contract ID after successfully
    removing the required cargo. The server derives the caller UID and reward
    from its own pending contract record.
*/
if (!isServer || {!isRemoteExecuted}) exitWith {false};
params [['_contractId','']];
if (_contractId isEqualTo '') exitWith {false};

private _caller = allPlayers select {owner _x isEqualTo remoteExecutedOwner} param [0,objNull];
if (isNull _caller || {!alive _caller}) exitWith {false};
private _uid = getPlayerUID _caller;
if (_uid isEqualTo '') exitWith {false};

private _contracts = missionNamespace getVariable ['RHD_ActiveContracts',createHashMap];
private _contract = _contracts getOrDefault [_uid,[]];
if (_contract isEqualTo [] || {count _contract < 8}) exitWith {false};
if ((_contract param [0,'']) isNotEqualTo _uid) exitWith {false};
if ((_contract param [7,'']) isNotEqualTo 'PENDING') exitWith {false};

private _reward = round ((_contract param [6,0]) max 0);
private _paid = true;
if (_reward > 0) then {
    _paid = [_caller,'REWARD','CASH',_reward,'Delivery contract reward'] call RHD_fnc_financialTransaction;
};
if (!_paid) exitWith {
    ['message','','',0,'Contract payment could not be completed. Please retry.'] remoteExecCall ['RHD_fnc_contractResult',_caller];
    false
};

_contracts deleteAt _uid;
missionNamespace setVariable ['RHD_ActiveContracts',_contracts,true];
['paid','',0,_reward] remoteExecCall ['RHD_fnc_contractResult',_caller];
true
