/*
    RHD <-> Antistasi Ultimate compatibility bridge.

    RHD-LifeServer remains available to every player.
    ONLY functions routed through this bridge are Independent-only.

    Antistasi Ultimate remains the source of the A3A/A3U functions. This file
    does not copy, alter, or replace those functions.
*/
params [
    ["_function", "", [""]],
    ["_args", [], [[]]]
];

private _caller = objNull;
if (isRemoteExecuted) then {
    if (!isServer) exitWith {false};
    _caller = allPlayers select {owner _x isEqualTo remoteExecutedOwner} param [0, objNull];
    if (isNull _caller || {!isPlayer _caller}) exitWith {false};
};

private _gate = missionNamespace getVariable ["RHD_fnc_isAntistasiIndependent", {false}];
if (isRemoteExecuted) then {
    if !([_caller] call _gate) exitWith {false};
} else {
    if (hasInterface && {!([player] call _gate)}) exitWith {false};
};

if !(isClass (configFile >> "CfgPatches" >> "A3A_core") || {isClass (configFile >> "CfgPatches" >> "A3A_ultimate")}) exitWith {false};

/*
    Explicit whitelist. Do not turn this into a generic client-controlled
    function executor. These are the Antistasi functions RHD exposes to its
    compatibility layer.
*/
private _allowedFunctions = [
    "A3A_fnc_createUnit",
    "A3A_fnc_spawnGroup",
    "A3A_fnc_spawnVehicle",
    "A3A_fnc_revealToPlayer",
    "A3A_fnc_getVehicleSellPrice",
    "A3A_fnc_getAggroLevelString",
    "A3U_fnc_canInteract",
    "A3U_fnc_revealZone",
    "A3U_fnc_revealZones",
    "A3U_fnc_hasAddon"
];

if !(_function in _allowedFunctions) exitWith {false};

private _fn = missionNamespace getVariable [_function, {}];
if !(_fn isEqualType {}) exitWith {false};

/*
    Server-side creation helpers must execute on the server. Independent
    validation is performed both for the remote caller and for the requested
    owner/side/group so the bridge cannot manufacture enemy-side assets.
*/
switch (_function) do {
    case "A3A_fnc_createUnit": {
        if !isServer exitWith {false};
        if (count _args < 3) exitWith {false};
        _args params ["_group", "_type", "_position"];
        if (isNull _group || {side _group isNotEqualTo independent}) exitWith {false};
        _args call _fn
    };

    case "A3A_fnc_spawnGroup": {
        if !isServer exitWith {false};
        if (count _args < 3) exitWith {false};
        _args params ["_position", "_side", "_types"];
        if (_side isNotEqualTo independent) exitWith {false};
        _args call _fn
    };

    case "A3A_fnc_spawnVehicle": {
        if !isServer exitWith {false};
        if (count _args < 4) exitWith {false};
        _args params ["_position", "_azimuth", "_type", "_owner"];
        if (_owner isEqualType sideUnknown) then {
            if (_owner isNotEqualTo independent) exitWith {false};
        } else {
            if (isNull _owner || {side _owner isNotEqualTo independent}) exitWith {false};
        };
        _args call _fn
    };

    default {
        _args call _fn
    };
};
