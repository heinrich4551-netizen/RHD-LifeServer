/* [uid,licenseClass,expiresAt] call RHD_fnc_issueLicense */
if (!isServer) exitWith {false};
params [['_uid',''],['_license',''],['_expires',0]];
if (_uid isEqualTo '' || {_license isEqualTo ''}) exitWith {false};
private _l = missionNamespace getVariable ['RHD_Licenses',createHashMap];
private _key = format ['%1:%2',_uid,toLower _license];
_l set [_key,[_uid,toLower _license,_expires max 0,diag_tickTime]];
missionNamespace setVariable ['RHD_Licenses',_l,true];
true
