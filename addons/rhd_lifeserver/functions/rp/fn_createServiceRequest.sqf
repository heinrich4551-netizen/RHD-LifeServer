/*
    Client-callable service request entrypoint.
    The server binds the request owner and location to the remote caller.
*/
if (!isServer) exitWith {false};
params [['_service','GENERAL'],['_description',''],['_position',[0,0,0]],['_priority',2,[0]]];

private _owner = if (isRemoteExecuted) then {remoteExecutedOwner} else {2};
private _player = objNull;
if (isRemoteExecuted) then {
    private _matches = allPlayers select {owner _x isEqualTo _owner};
    _player = _matches param [0,objNull];
    if (isNull _player) exitWith {false};
};

private _uid = if (isNull _player) then {''} else {getPlayerUID _player};
if (_uid isEqualTo '') exitWith {false};

private _rate = missionNamespace getVariable ['RHD_ServiceRequestRate',createHashMap];
private _last = _rate getOrDefault [_uid,0];
if ((diag_tickTime - _last) < 30) exitWith {false};
_rate set [_uid,diag_tickTime];
missionNamespace setVariable ['RHD_ServiceRequestRate',_rate];

private _safePosition = getPosATL _player;
private _safeService = toUpper (if (_service isEqualTo '') then {'GENERAL'} else {_service});
if !(_safeService in ['GENERAL','POLICE','EMS','MECHANIC','TAXI','GOVERNMENT']) then {_safeService = 'GENERAL';};
private _safeDescription = if (_description isEqualTo '') then {'Service requested by player.'} else {_description};
_safeDescription = _safeDescription select [0,256];
private _safePriority = (_priority max 1) min 3;

private _r = missionNamespace getVariable ['RHD_ServiceRequests',createHashMap];
private _id = format ['S-%1-%2',floor diag_tickTime,floor random 10000];
_r set [_id,[_id,diag_tickTime,_safeService,_safeDescription,_safePosition,_safePriority,_owner,_uid,'OPEN']];
missionNamespace setVariable ['RHD_ServiceRequests',_r,true];

[_id,_safeService] remoteExecCall ['RHD_fnc_rpResult',_owner];
true
