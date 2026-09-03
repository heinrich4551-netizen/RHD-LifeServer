/*
    Server-side read of a player's RHD license registry.
    Client supplies only the UID; the server returns the authoritative list.
*/
if (!isServer) exitWith {false};
params [['_uid','']];
if (_uid isEqualTo '') exitWith {false};

private _licenses = missionNamespace getVariable ['RHD_Licenses',createHashMap];
private _owned = +(_licenses getOrDefault [_uid,[]]);
private _owner = if (isRemoteExecuted) then {remoteExecutedOwner} else {2};
if (_owner <= 0) exitWith {false};

[_owned] remoteExecCall ['RHD_fnc_rpResult',_owner];
true
