/* [type,description,position,priority] call RHD_fnc_dispatch; */
if (!isServer) exitWith {false};
params [['_type','GENERAL'],['_description',''],['_position',[0,0,0]],['_priority',2]];
private _calls = missionNamespace getVariable ['RHD_DispatchCalls',createHashMap];
private _id = format ['%1-%2',floor diag_tickTime,floor random 10000];
private _owner = if (isRemoteExecuted) then {remoteExecutedOwner} else {2};
_calls set [_id,[_id,diag_tickTime,_type,_description,_position,_priority,_owner]];
missionNamespace setVariable ['RHD_DispatchCalls',_calls,true];
[_id,_type,_description,_position,_priority] remoteExecCall ['RHD_fnc_dispatchResult',-2];
true
