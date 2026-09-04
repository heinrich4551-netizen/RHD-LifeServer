/*
    Authenticated server-side impound registration.
    [vehicle,reason,fee] call RHD_fnc_impoundVehicle
*/
if (!isServer) exitWith {false};
params [['_vehicle',objNull,[objNull]],['_reason',''],['_fee',0,[0]]];
if (isNull _vehicle || {_reason isEqualTo ''}) exitWith {false};

private _executorUID = '';
if (isRemoteExecuted) then {
    private _caller = allPlayers select {owner _x isEqualTo remoteExecutedOwner} param [0,objNull];
    if (isNull _caller || {!alive _caller}) exitWith {false};
    _executorUID = getPlayerUID _caller;
};

private _netId = netId _vehicle;
if (_netId isEqualTo '') exitWith {false};
_reason = _reason select [0,256];
private _feeSafe = round ((_fee max 0) min 1000000);
private _owners = _vehicle getVariable ['vehicle_info_owners',[]];

private _impounds = missionNamespace getVariable ['RHD_Impounds',createHashMap];
private _id = format ['I-%1-%2',floor diag_tickTime,floor random 10000];
_impounds set [_id,[_id,_netId,_owners,_reason,_feeSafe,diag_tickTime,2,_executorUID]];
_vehicle setVariable ['RHD_Impounded',true,true];
missionNamespace setVariable ['RHD_Impounds',_impounds,true];
true
