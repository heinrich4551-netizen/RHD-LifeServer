waitUntil {time > 0};
player setVariable ["RHD_Initialized", true, false];
[] spawn RHD_fnc_initMenus;

/*
    Antistasi compatibility is intentionally separate from RHD access.
    Every player keeps normal RHD menus, economy, jobs and RP systems.
    Only Antistasi-specific integration is exposed to Independent players.
*/
[] spawn {
    waitUntil {time > 0};
    if (isNil "RHD_fnc_isAntistasiIndependent") exitWith {};

    while {!isNull player} do {
        private _allowed = [player] call (missionNamespace getVariable ["RHD_fnc_isAntistasiIndependent",{false}]);
        player setVariable ["RHD_AntistasiIndependentAccess",_allowed,false];
        sleep 3;
    };
};

/*
    Recover any marketplace inventory reserved before a disconnect/restart.
    This is ordinary RHD functionality and is available to every player.
    The server binds the request to this client's remote owner and UID.
*/
[] spawn {
    sleep 2;
    ['MARKETPLACE_RECOVER',[]] remoteExecCall ['RHD_fnc_rpAction',2];
};

/*
    Runtime shop overlay.

    The upstream Framework remains untouched. RHD replaces the virtual shop
    callbacks for all players; Antistasi faction state does not affect this.
*/
[] spawn {
    waitUntil {
        time > 0 &&
        {!isNil {missionNamespace getVariable "life_fnc_virt_buy"}} &&
        {!isNil {missionNamespace getVariable "life_fnc_virt_sell"}} &&
        {!isNil {missionNamespace getVariable "life_fnc_virt_update"}}
    };

    if (isNil {missionNamespace getVariable "RHD_OriginalVirtBuy"}) then {
        missionNamespace setVariable ["RHD_OriginalVirtBuy", missionNamespace getVariable "life_fnc_virt_buy"];
        missionNamespace setVariable ["RHD_OriginalVirtSell", missionNamespace getVariable "life_fnc_virt_sell"];
        missionNamespace setVariable ["RHD_OriginalVirtUpdate", missionNamespace getVariable "life_fnc_virt_update"];
    };

    missionNamespace setVariable ["life_fnc_virt_buy", RHD_fnc_virtBuy];
    missionNamespace setVariable ["life_fnc_virt_sell", RHD_fnc_virtSell];
    missionNamespace setVariable ["life_fnc_virt_update", RHD_fnc_virtUpdate];
    missionNamespace setVariable ["RHD_ShopHooksActive", true, false];
};
