/* RHD LifeServer bootstrap. This is an independent overlay and does not modify the upstream framework. */
missionNamespace setVariable ["RHD_LifeServer_Enabled", true, true];
missionNamespace setVariable ["RHD_LifeServer_Version", "0.1.0", true];

if (isServer) then {
    missionNamespace setVariable ["RHD_ServerStartedAt", diag_tickTime, true];
};
