/*
    Authenticated RP action router.
    Clients request an action; the server derives the caller from the remote
    owner and uses the shared Framework database-backed authorization helper.
*/
if (!isServer || {!isRemoteExecuted}) exitWith {false};
params [['_action',''],['_args',[],[[]]]];
_action = toUpper _action;
private _caller = allPlayers select {owner _x isEqualTo remoteExecutedOwner} param [0,objNull];
if (isNull _caller || {getPlayerUID _caller isEqualTo ''}) exitWith {false};

switch (_action) do {
    case 'EVIDENCE': {
        if !(['COP',1] call RHD_fnc_authorizeRole) exitWith {false};
        _args call RHD_fnc_createEvidence;
    };
    case 'WARRANT': {
        if !(['COP',2] call RHD_fnc_authorizeRole) exitWith {false};
        _args call RHD_fnc_createWarrant;
    };
    case 'IMPOUND': {
        if !(['COP',1] call RHD_fnc_authorizeRole) exitWith {false};
        _args call RHD_fnc_impoundVehicle;
    };
    case 'LICENSE': {
        if !(['COP',2] call RHD_fnc_authorizeRole) exitWith {false};
        _args call RHD_fnc_manageLicense;
    };
    case 'HOSPITAL_BILL': {
        if !(['MEDIC',1] call RHD_fnc_authorizeRole) exitWith {false};
        _args call RHD_fnc_hospitalBill;
    };
    default {false};
};
