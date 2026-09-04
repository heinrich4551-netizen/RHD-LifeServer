/*
    Authenticated RP action router.
    Clients request an action; the server derives the caller from the remote owner.
*/
if (!isServer || {!isRemoteExecuted}) exitWith {false};
params [['_action',''],['_args',[],[[]]]];
_action = toUpper _action;
private _caller = allPlayers select {owner _x isEqualTo remoteExecutedOwner} param [0,objNull];
if (isNull _caller || {getPlayerUID _caller isEqualTo ''}) exitWith {false};
private _callerUID = getPlayerUID _caller;

switch (_action) do {
    case 'EVIDENCE': { if !(['COP',1] call RHD_fnc_authorizeRole) exitWith {false}; _args call RHD_fnc_createEvidence; };
    case 'WARRANT': { if !(['COP',2] call RHD_fnc_authorizeRole) exitWith {false}; _args call RHD_fnc_createWarrant; };
    case 'IMPOUND': {
        if !(['COP',1] call RHD_fnc_authorizeRole) exitWith {false};
        _args = [_caller] + _args;
        _args call RHD_fnc_impoundVehicle;
    };
    case 'RELEASE_IMPOUND': {
        if !(['COP',1] call RHD_fnc_authorizeRole) exitWith {false};
        _args = [_caller] + _args;
        _args call RHD_fnc_releaseImpound;
    };
    case 'RELEASE_IMPOUND_TARGET': {
        if !(['COP',1] call RHD_fnc_authorizeRole) exitWith {false};
        _args = [_caller] + _args;
        _args call RHD_fnc_releaseImpoundByVehicle;
    };
    case 'LIST_IMPOUNDS': {
        if !(['COP',1] call RHD_fnc_authorizeRole) exitWith {false};
        [_caller] call RHD_fnc_getImpounds;
    };
    case 'LICENSE': {
        if !(['COP',2] call RHD_fnc_authorizeRole) exitWith {false};
        _args = [_caller] + _args;
        _args call RHD_fnc_manageLicense;
    };
    case 'HOSPITAL_BILL': {
        if !(['MEDIC',1] call RHD_fnc_authorizeRole) exitWith {false};
        _args = [_caller] + _args;
        _args call RHD_fnc_hospitalBill;
    };
    case 'TREAT': {
        if !(['MEDIC',1] call RHD_fnc_authorizeRole) exitWith {false};
        _args = [_caller] + _args;
        _args call RHD_fnc_treatPlayer;
    };
    case 'VEHICLE_SERVICE': {
        if !(['COP',1] call RHD_fnc_authorizeRole) exitWith {false};
        _args = [_caller] + _args;
        _args call RHD_fnc_vehicleService;
    };
    case 'BUSINESS_CREATE': {
        _args = [_caller] + _args;
        _args call RHD_fnc_businessCreate;
    };
    case 'BUSINESS_INFO': {
        [_caller] call RHD_fnc_businessInfo;
    };
    case 'BUSINESS_TRANSACTION': {
        _args = [_caller] + _args;
        _args call RHD_fnc_businessTransaction;
    };
    case 'DISPATCH_ACK': {
        private _authorized = ['COP',1] call RHD_fnc_authorizeRole;
        if (!_authorized) then {_authorized = ['MEDIC',1] call RHD_fnc_authorizeRole;};
        if (!_authorized) exitWith {false};
        private _dispatchArgs = +_args;
        _dispatchArgs pushBack 'ACK';
        _dispatchArgs pushBack _callerUID;
        _dispatchArgs call RHD_fnc_dispatchAction;
    };
    case 'DISPATCH_CLOSE': {
        private _authorized = ['COP',1] call RHD_fnc_authorizeRole;
        if (!_authorized) then {_authorized = ['MEDIC',1] call RHD_fnc_authorizeRole;};
        if (!_authorized) exitWith {false};
        private _dispatchArgs = +_args;
        _dispatchArgs pushBack 'CLOSE';
        _dispatchArgs pushBack _callerUID;
        _dispatchArgs call RHD_fnc_dispatchAction;
    };
    default {false};
};
