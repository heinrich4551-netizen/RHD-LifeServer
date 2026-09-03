waitUntil {time > 0};
player setVariable ["RHD_Initialized", true, false];
[] spawn RHD_fnc_initMenus;
