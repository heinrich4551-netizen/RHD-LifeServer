waitUntil {time > 0};

player setVariable ["RHD_Initialized", true, false];

/* Generic interaction hooks. Framework-specific menus can call these functions without changing the upstream framework. */
player addAction ["RHD: Check Server Status", {
    private _count = count allPlayers;
    hint format ["RHD LifeServer\nPlayers online: %1\nFramework overlay: %2", _count, missionNamespace getVariable ["RHD_LifeServer_Version", "unknown"]];
}];
