/*
    Server-side read of a player's RHD license registry.
    A client may only request its own license list. Administrative reads should
    use a separate authorized server-side path.
*/
if (!isServer || {!isRemoteExecuted}) exitWith {false};
params [['_uid','']];

private _caller = allPlayers select {owner _x isEqualTo remoteExecutedOwner} param [0,objNull];
if (isNull _caller) exitWith {false};
private _callerUID = getPlayerUID _caller;
if (_callerUID isEqualTo '' || {_uid != _callerUID}) exitWith {false};

private _licenses = missionNamespace getVariable ['RHD_Licenses',createHashMap];
private _owned = +(_licenses getOrDefault [_callerUID,[]]);
[_owned] remoteExecCall ['RHD_fnc_rpResult',remoteExecutedOwner];
true
