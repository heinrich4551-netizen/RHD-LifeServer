/*
    RHD <-> Antistasi Ultimate compatibility layer.

    RHD-LifeServer itself remains available to every player.
    ONLY the Antistasi-specific integration exposed by RHD is scoped to the
    Independent faction used by Antistasi Ultimate.

    The Antistasi source is not modified by this compatibility layer.
*/

private _enabled = isClass (configFile >> 'CfgPatches' >> 'A3A_core') || {isClass (configFile >> 'CfgPatches' >> 'A3A_ultimate')};
missionNamespace setVariable ['RHD_AntistasiAvailable',_enabled,true];

if (!_enabled) exitWith {false};

if (isServer) then {
    missionNamespace setVariable ['RHD_AntistasiIntegrationEnabled',true,true];
};

if (hasInterface) then {
    private _gate = missionNamespace getVariable ['RHD_fnc_isAntistasiIndependent',{false}];
    player setVariable ['RHD_AntistasiIndependentAccess',([player] call _gate),false];

    [] spawn {
        while {!isNull player} do {
            private _gate = missionNamespace getVariable ['RHD_fnc_isAntistasiIndependent',{false}];
            player setVariable ['RHD_AntistasiIndependentAccess',([player] call _gate),false];
            sleep 3;
        };
    };
};

true
