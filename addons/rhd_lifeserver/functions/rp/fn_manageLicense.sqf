/*
    Server-internal license grant/revoke.
    [targetUID,licenseClass,enabled] call RHD_fnc_manageLicense
*/
if (!isServer || {isRemoteExecuted}) exitWith {false};
params [['_uid',''],['_license',''],['_enabled',true,[true]]];
if (_uid isEqualTo '' || {_license isEqualTo ''}) exitWith {false};
if (count _uid != 17) exitWith {false};
if !(_uid select {_x >= '0' && _x <= '9'} isEqualTo _uid) exitWith {false};

_license = toLower (_license select [0,64]);
private _allowed = ['driver','truck','boat','pilot','gun','dive','rebel','medical'];
if !(_license in _allowed) exitWith {false};

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
