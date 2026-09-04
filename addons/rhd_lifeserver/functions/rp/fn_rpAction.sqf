/*
    Authenticated RP action router.
    Clients request an action; the server derives the caller from the remote owner.
*/
if (!isServer || {!isRemoteExecuted}) exitWith {false};
params [['_action',''],['_args',[],[[]]]];
_action = toUpper _action;
private _caller = allPlayers select {owner _x isEqualTo remoteExecutedOwner} param [0,objNull];
if (isNull _caller || {getPlayerUID _caller isEqualTo ''}) exitWith {false};

switch (_action) do {
    case 'EVIDENCE': { if !(['COP',1] call RHD_fnc_authorizeRole) exitWith {false}; _args call RHD_fnc_createEvidence; };
    case 'WARRANT': { if !(['COP',2] call RHD_fnc_authorizeRole) exitWith {false}; _args call RHD_fnc_createWarrant; };
    case 'IMPOUND': { if !(['COP',1] call RHD_fnc_authorizeRole) exitWith {false}; _args call RHD_fnc_impoundVehicle; };
    case 'LICENSE': { if !(['COP',2] call RHD_fnc_authorizeRole) exitWith {false}; _args call RHD_fnc_manageLicense; };
    case 'HOSPITAL_BILL': { if !(['MEDIC',1] call RHD_fnc_authorizeRole) exitWith {false}; _args call RHD_fnc_hospitalBill; };
    case 'TREAT': { if !(['MEDIC',1] call RHD_fnc_authorizeRole) exitWith {false}; _args = [_caller] + _args; _args call RHD_fnc_treatPlayer; };
    case 'VEHICLE_SERVICE': {
        private _service = _args param [1,'INSPECTION'];
        if (toUpper _service isEqualTo 'INSPECTION') then {
            if !(['COP',1] call RHD_fnc_authorizeRole) exitWith {false};
        } else {
            if !(['COP',1] call RHD_fnc_authorizeRole) exitWith {false};
        };
        _args = [_args param [0,objNull],_service,_args param [2,0]];
        _args call RHD_fnc_vehicleService;
    };
    case 'DISPATCH_ACK': {
        private _authorized = ['COP',1] call RHD_fnc_authorizeRole;
        if (!_authorized) then {_authorized = ['MEDIC',1] call RHD_fnc_authorizeRole;};
        if (!_authorized) exitWith {false};
        _args pushBack 'ACK'; _args call RHD_fnc_dispatchAction;
    };
    case 'DISPATCH_CLOSE': {
        private _authorized = ['COP',1] call RHD_fnc_authorizeRole;
        if (!_authorized) then {_authorized = ['MEDIC',1] call RHD_fnc_authorizeRole;};
        if (!_authorized) exitWith {false};
        _args pushBack 'CLOSE'; _args call RHD_fnc_dispatchAction;
    };
    default {false};
};
