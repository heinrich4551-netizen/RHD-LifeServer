/* Server-authoritative contract completion check. */
if (!isServer) exitWith {false};
params [['_player',objNull,[objNull]]];
if (isNull _player || {!isPlayer _player} || {!alive _player}) exitWith {false};

private _uid = getPlayerUID _player;
private _contracts = missionNamespace getVariable ['RHD_ActiveContracts',createHashMap];
private _contract = _contracts getOrDefault [_uid,[]];
if (_contract isEqualTo []) exitWith {
    ['RHD: You have no active delivery contract.'] remoteExecCall ['RHD_fnc_contractResult',_player];
    false
};

_contract params ['_owner','_created','_item','_display','_amount','_destination','_reward'];
if (_player distance2D _destination > 35) exitWith {
    ['RHD: Move within 35m of the delivery destination.'] remoteExecCall ['RHD_fnc_contractResult',_player];
    false
};

_contracts deleteAt _uid;
missionNamespace setVariable ['RHD_ActiveContracts',_contracts,true];

['complete',_item,_amount,_reward,_display] remoteExecCall ['RHD_fnc_contractResult',_player];
true
