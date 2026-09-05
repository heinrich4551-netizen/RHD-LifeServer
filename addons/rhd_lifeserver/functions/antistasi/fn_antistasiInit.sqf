/*
    RHD <-> Antistasi Ultimate compatibility layer.

    IMPORTANT:
    - This does NOT restrict or replace RHD-LifeServer functionality.
    - Existing RHD systems remain available to every player exactly as before.
    - Only the Antistasi Ultimate integration exposed by this layer is scoped
      to players serving on the Independent faction.
    - Antistasi source files are not modified by this compatibility layer.

    Antistasi Ultimate uses the Independent side as the rebel/player faction.
*/

private _enabled = isClass (configFile >> 'CfgPatches' >> 'A3A_core') || {isClass (configFile >> 'CfgPatches' >> 'A3A_ultimate')};
missionNamespace setVariable ['RHD_AntistasiAvailable',_enabled,true];

if (!_enabled) exitWith {false};

if (isServer) then {
    missionNamespace setVariable ['RHD_AntistasiIntegrationEnabled',true,true];
};

if (hasInterface) then {
    private _independent = side player isEqualTo independent;
    if (!isNil 'teamPlayer') then {
        _independent = _independent && {teamPlayer isEqualTo independent};
    };

    /* This flag controls ONLY Antistasi integration, never RHD core access. */
    player setVariable ['RHD_AntistasiIndependentAccess',_independent,false];

    /* Keep the state correct if Antistasi changes the player's faction. */
    [] spawn {
        while {!isNull player} do {
            private _allowed = side player isEqualTo independent;
            if (!isNil 'teamPlayer') then {
                _allowed = _allowed && {teamPlayer isEqualTo independent};
            };
            player setVariable ['RHD_AntistasiIndependentAccess',_allowed,false];
            sleep 3;
        };
    };
};

true
