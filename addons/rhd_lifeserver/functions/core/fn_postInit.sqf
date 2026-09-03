if (!isServer && !hasInterface) exitWith {};

if (isServer) then {
    [] call RHD_fnc_initRP;
    [] call RHD_fnc_initPrices;
    [] call RHD_fnc_registerNodes;
    [] call RHD_fnc_initPersistence;
    [] spawn {
        waitUntil {time > 0};
        sleep 2;
        [] call RHD_fnc_registerNodes;
    };
    [] spawn RHD_fnc_serverLoop;
};

if (hasInterface) then {
    [] spawn RHD_fnc_clientInit;
};
