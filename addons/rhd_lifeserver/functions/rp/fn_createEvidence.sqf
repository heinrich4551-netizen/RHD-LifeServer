/* Server-internal evidence creation. [type,description,position] call RHD_fnc_createEvidence */
if (!isServer) exitWith {false};
params [['_type','UNKNOWN'],['_description',''],['_position',[0,0,0]]];
private _e = missionNamespace getVariable ['RHD_Evidence',createHashMap];
private _id = format ['E-%1-%2',floor diag_tickTime,floor random 10000];
_e set [_id,[_id,diag_tickTime,_type,_description,_position,2]];
missionNamespace setVariable ['RHD_Evidence',_e,true];
true
