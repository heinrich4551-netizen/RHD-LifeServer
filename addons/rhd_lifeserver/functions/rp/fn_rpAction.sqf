/*
    Authenticated RP action router.
    Clients request an action; the server derives the caller UID and verifies
    the caller's Framework rank from the players table before invoking the
    protected server-internal registry functions.

    [action,arguments] remoteExecCall ['RHD_fnc_rpAction',2]
*/
if (!isServer || {!isRemoteExecuted}) exitWith {false};
params [['_action',''],['_args',[],[[]]]];
_action = toUpper _action;
private _caller = allPlayers select {owner _x isEqualTo remoteExecutedOwner} param [0,objNull];
if (isNull _caller) exitWith {false};

private _uid = getPlayerUID _caller;
private _authorize = {
    params ['_role','_rank'];
    ['_role',_role,'rank',_rank] params ['_unusedRole','_roleValue','_unusedRank','_rankValue'];
    if (isNil 'DB_fnc_asyncCall') exitWith {false};
    private _result = [format ["SELECT coplevel, mediclevel, adminlevel FROM players WHERE pid='%1' LIMIT 1",_uid],2] call DB_fnc_asyncCall;
    if !(_result isEqualType []) exitWith {false};
    if (count _result < 3) exitWith {false};
    private _value = switch (_roleValue) do {
        case 'COP': {_result select 0};
        case 'MEDIC': {_result select 1};
        case 'ADMIN': {_result select 2};
        default {0};
    };
    ([_value] call DB_fnc_numberSafe) >= (_rankValue max 0)
};

switch (_action) do {
    case 'EVIDENCE': {
        if !(['COP',1] call _authorize) exitWith {false};
        _args call RHD_fnc_createEvidence;
    };
    case 'WARRANT': {
        if !(['COP',2] call _authorize) exitWith {false};
        _args call RHD_fnc_createWarrant;
    };
    case 'IMPOUND': {
        if !(['COP',1] call _authorize) exitWith {false};
        _args call RHD_fnc_impoundVehicle;
    };
    case 'LICENSE': {
        if !(['COP',2] call _authorize) exitWith {false};
        _args call RHD_fnc_manageLicense;
    };
    case 'HOSPITAL_BILL': {
        if !(['MEDIC',1] call _authorize) exitWith {false};
        _args call RHD_fnc_hospitalBill;
    };
    default {false};
};
