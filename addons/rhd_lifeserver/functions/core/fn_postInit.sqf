if (!isServer && !hasInterface) exitWith {};

if (isServer) then {
    [] spawn RHD_fnc_serverLoop;
};

if (hasInterface) then {
    [] spawn RHD_fnc_clientInit;
};
