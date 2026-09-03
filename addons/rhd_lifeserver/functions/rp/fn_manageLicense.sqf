/*
    Server-internal license grant/revoke.
    A role-authorized police/DMV/government entrypoint should call this function.
    [targetUID,licenseClass,enabled] call RHD_fnc_manageLicense
*/
if (!isServer || {isRemoteExecuted}) exitWith {false};
params [['_uid',''],['_license',''],['_enabled',true,[true]]];
if (_uid isEqualTo '' || {_license isEqualTo ''}) exitWith {false};

private _licenses = missionNamespace getVariable ['RHD_Licenses',createHashMap];
private _owned = _licenses getOrDefault [_uid,[]];
if (_enabled) then {
    if !(_license in _owned) then {_owned pushBack _license;};
} else {
    _owned = _owned select {_x != _license};
};
_licenses set [_uid,_owned];
missionNamespace setVariable ['RHD_Licenses',_licenses,true];
true
