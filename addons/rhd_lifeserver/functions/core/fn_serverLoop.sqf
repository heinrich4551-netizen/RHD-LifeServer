while {true} do {
    if (missionNamespace getVariable ["RHD_LifeServer_Enabled", true]) then {
        [] call RHD_fnc_updatePopulation;
        [] call RHD_fnc_economyLoop;
    };
    sleep 60;
};
