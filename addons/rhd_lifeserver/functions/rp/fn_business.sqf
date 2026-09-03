/*
    Server-internal business registry.
    A role-authorized business/government entrypoint should call this function.
    [businessId,ownerUID,name,position] call RHD_fnc_business
*/
if (!isServer || {isRemoteExecuted}) exitWith {false};
params [['_id',''],['_ownerUID',''],['_name',''],['_position',[0,0,0]]];
if (_id isEqualTo '' || {_ownerUID isEqualTo ''} || {_name isEqualTo ''}) exitWith {false};

private _businesses = missionNamespace getVariable ['RHD_Businesses',createHashMap];
if (_businesses getOrDefault [_id,[]] isNotEqualTo []) exitWith {false};
_businesses set [_id,[_id,_ownerUID,_name,_position,[],diag_tickTime]];
missionNamespace setVariable ['RHD_Businesses',_businesses,true];
true
