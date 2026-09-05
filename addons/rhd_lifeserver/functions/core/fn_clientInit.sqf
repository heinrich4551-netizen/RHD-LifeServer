waitUntil {time > 0};
player setVariable ["RHD_Initialized", true, false];
[] spawn RHD_fnc_initMenus;

/*
    Recover any marketplace inventory reserved before a disconnect/restart.
    The server binds the request to this client's remote owner and UID.
*/
[] spawn {
    sleep 2;
    ['MARKETPLACE_RECOVER',[]] remoteExecCall ['RHD_fnc_rpAction',2];
};

/*
    Runtime shop overlay.

    The upstream Framework remains a separate submodule and is never edited.
    Once its CfgFunctions are available, RHD swaps the virtual shop callbacks
    with the RHD market-aware handlers for this client.
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
