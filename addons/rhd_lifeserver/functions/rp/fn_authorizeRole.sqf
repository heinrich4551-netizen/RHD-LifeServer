/*
    Server-side Framework role authorization.
    Returns true only when the remote caller's UID has the required rank in
    the upstream players table. This never trusts client-side rank variables.
    [requiredRole, minimumRank] call RHD_fnc_authorizeRole
    requiredRole: "COP", "MEDIC", "ADMIN"
*/
if (!isServer || {!isRemoteExecuted}) exitWith {false};
params [['_role','',['']],['_minimumRank',1,[0]]];
_role = toUpper _role;
if !(_role in ['COP','MEDIC','ADMIN']) exitWith {false};
private _caller = allPlayers select {owner _x isEqualTo remoteExecutedOwner} param [0,objNull];
if (isNull _caller) exitWith {false};
private _uid = getPlayerUID _caller;
if (_uid isEqualTo '' || {count _uid != 17}) exitWith {false};
if (isNil 'DB_fnc_asyncCall') exitWith {false};
private _safeUid = _uid select {(_x >= '0') && (_x <= '9')};
if (_safeUid != _uid) exitWith {false};
private _result = [format ["SELECT coplevel, mediclevel, adminlevel FROM players WHERE pid='%1' LIMIT 1",_uid],2] call DB_fnc_asyncCall;
if !(_result isEqualType []) exitWith {false};
if (count _result < 3) exitWith {false};
private _rank = switch (_role) do {
    case 'COP': {_result select 0};
    case 'MEDIC': {_result select 1};
    case 'ADMIN': {_result select 2};
};
_rank = [_rank] call DB_fnc_numberSafe;
_rank >= (_minimumRank max 0)
