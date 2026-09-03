/* [service,description,position,priority] call RHD_fnc_createServiceRequest */
if (!isServer) exitWith {false};
params [['_service','GENERAL'],['_description',''],['_position',[0,0,0]],['_priority',2]];
private _r = missionNamespace getVariable ['RHD_ServiceRequests',createHashMap];
private _id = format ['S-%1-%2',floor diag_tickTime,floor random 10000];
_r set [_id,[_id,diag_tickTime,_service,_description,_position,_priority,remoteExecutedOwner]];
missionNamespace setVariable ['RHD_ServiceRequests',_r,true];
[_id,_service] remoteExecCall ['RHD_fnc_rpResult',remoteExecutedOwner];
true
