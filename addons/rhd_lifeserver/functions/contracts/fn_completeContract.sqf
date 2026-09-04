/* Server-authoritative contract completion check. */
if (!isServer || {!isRemoteExecuted}) exitWith {false};
params [['_player',objNull,[objNull]]];
private _caller = allPlayers select {owner _x isEqualTo remoteExecutedOwner} param [0,objNull];
if (isNull _caller || {_player isNotEqualTo _caller}) exitWith {false};
_player = _caller;
if (!isPlayer _player || {!alive _player}) exitWith {false};

private _uid = getPlayerUID _player;
private _contracts = missionNamespace getVariable ['RHD_ActiveContracts',createHashMap];
private _contract = _contracts getOrDefault [_uid,[]];
if (_contract isEqualTo []) exitWith {
    ['message','','',0,'You have no active delivery contract.'] remoteExecCall ['RHD_fnc_contractResult',_player];
    false
};

if (count _contract >= 8 && {(_contract param [7,'']) isEqualTo 'PENDING'}) exitWith {
    ['message','','',0,'Your previous contract delivery is still being processed.'] remoteExecCall ['RHD_fnc_contractResult',_player];
    false
};

_contract params ['_owner','_created','_item','_display','_amount','_destination','_reward'];
if (_owner isNotEqualTo _uid) exitWith {false};
if (_player distance2D _destination > 35) exitWith {
    ['message','','',0,'Move within 35m of the delivery destination.'] remoteExecCall ['RHD_fnc_contractResult',_player];
    false
};

_contract set [7,'PENDING'];
_contracts set [_uid,_contract];
missionNamespace setVariable ['RHD_ActiveContracts',_contracts,true];

['complete',_item,_amount,_reward,_display,_destination,_uid] remoteExecCall ['RHD_fnc_contractResult',_player];
true
