/*
    Server-internal impound registration.
    Role-authorized police/DMV entrypoints should call this function server-side.
    [vehicle,reason,fee] call RHD_fnc_impoundVehicle
*/
if (!isServer || {isRemoteExecuted}) exitWith {false};
params [['_vehicle',objNull,[objNull]],['_reason',''],['_fee',0,[0]]];
if (isNull _vehicle || {_reason isEqualTo ''}) exitWith {false};

private _i = missionNamespace getVariable ['RHD_Impounds',createHashMap];
private _id = format ['I-%1-%2',floor diag_tickTime,floor random 10000];
private _ownerUID = _vehicle getVariable ['vehicle_info_owners',[]];
_i set [_id,[_id,netId _vehicle,_ownerUID,_reason,_fee max 0,diag_tickTime,2]];
_vehicle setVariable ['RHD_Impounded',true,true];
missionNamespace setVariable ['RHD_Impounds',_i,true];
true
