/*
    Client-callable service request entrypoint.
    The server binds the request owner and location to the remote caller.
    [service,description,position,priority] call RHD_fnc_createServiceRequest
*/
if (!isServer) exitWith {false};
params [['_service','GENERAL'],['_description',''],['_position',[0,0,0]],['_priority',2,[0]]];

private _owner = if (isRemoteExecuted) then {remoteExecutedOwner} else {2};
private _player = if (isRemoteExecuted) then {allPlayers select {owner _x isEqualTo _owner} param [0,objNull]} else {objNull};
if (isRemoteExecuted && {isNull _player}) exitWith {false};

private _safePosition = if (isNull _player) then {_position} else {getPosATL _player};
private _safeService = toUpper ([_service,'GENERAL'] select (_service isEqualTo ''));
private _safeDescription = ([_description,'Service requested by player.'] select (_description isEqualTo '')) select [0,256];
private _safePriority = (_priority max 1) min 3;

private _r = missionNamespace getVariable ['RHD_ServiceRequests',createHashMap];
private _id = format ['S-%1-%2',floor diag_tickTime,floor random 10000];
_r set [_id,[_id,diag_tickTime,_safeService,_safeDescription,_safePosition,_safePriority,_owner,getPlayerUID _player]];
missionNamespace setVariable ['RHD_ServiceRequests',_r,true];

if (_owner > 2) then {
    [_id,_safeService] remoteExecCall ['RHD_fnc_rpResult',_owner];
};
true
