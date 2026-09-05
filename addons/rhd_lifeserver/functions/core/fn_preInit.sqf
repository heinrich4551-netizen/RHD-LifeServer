/* RHD LifeServer bootstrap. This is an independent overlay and does not modify the upstream framework. */
missionNamespace setVariable ["RHD_LifeServer_Enabled", true, true];
missionNamespace setVariable ["RHD_LifeServer_Version", "0.1.0", true];

/*
    Antistasi compatibility helper.

    This helper gates ONLY RHD's Antistasi integration. It must never be used
    to gate ordinary RHD-LifeServer systems. Antistasi Ultimate's player side
    is Independent; teamPlayer is additionally checked when the Antistasi
    mission variable exists.
*/
missionNamespace setVariable ["RHD_fnc_isAntistasiIndependent", {
    params [["_unit", objNull, [objNull]]];
    if (isNull _unit) exitWith {false};
    if !(side _unit isEqualTo independent) exitWith {false};
    if (!isNil "teamPlayer") then {
        if !(teamPlayer isEqualTo independent) exitWith {false};
    };
    true
}];

if (isServer) then {
    missionNamespace setVariable ["RHD_ServerStartedAt", diag_tickTime, true];
};
