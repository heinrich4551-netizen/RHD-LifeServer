/*
    RHD F6/F7/F8 dispatcher.
    Resource actions are sent to the dedicated server for validation.
*/
if (!hasInterface) exitWith {false};
params ["_action"];
private _mode = missionNamespace getVariable ["RHD_MenuMode", 6];

if (_mode isEqualTo 7) exitWith {
    switch (_action) do {
        case 0: {hint "RHD FARMING JOBS\n\nTravel to a rhd_resource_<item>_<id> marker and harvest through F6.";};
        case 1: {hint "RHD MINING JOBS\n\nTravel to a configured mining node and harvest through F6.";};
        case 2: {hint "RHD DELIVERIES / CONTRACTS\n\nContract integration is enabled for the RHD server layer.";};
        case 3: {hint "RHD BUSINESSES\n\nBusiness systems are available to the server economy layer.";};
    };
    true
};

if (_mode isEqualTo 8) exitWith {
    switch (_action) do {
        case 0: {hint "RHD VEHICLE SERVICES\n\nVehicle services integration point ready.";};
        case 1: {hint "RHD LICENSES\n\nUse the upstream framework license system.";};
        case 2: {hint "RHD DISPATCH\n\nDispatch integration point ready.";};
        case 3: {hint "RHD MARKETPLACE / EMERGENCY\n\nMarketplace and emergency-service integration points ready.";};
    };
    true
};

switch (_action) do {
    case 0: {
        private _near = [] call RHD_fnc_findNearbyResource;
        if (_near isEqualTo []) exitWith {hint "RHD: No configured resource node is within 60m.";};
        _near params ["_item", "_marker", "_distance"];
        closeDialog 0;
        [_item] remoteExecCall ["RHD_fnc_harvestServer", 2];
        true
    };
    case 1: {
        private _best = [];
        private _bestDist = 60;
        {
            private _marker = _x;
            private _lower = toLower _marker;
            if ((_lower find "rhd_process_") isEqualTo 0) then {
                private _d = player distance2D (getMarkerPos _marker);
                if (_d < _bestDist) then {
                    private _parts = _lower splitString "_";
                    if (count _parts >= 4) then {
                        _best = [_parts select 2, _marker, _d];
                        _bestDist = _d;
                    };
                };
            };
        } forEach allMapMarkers;
        if (_best isEqualTo []) exitWith {hint "RHD: No processing station is within 60m.";};
        _best params ["_process", "_marker", "_distance"];
        private _recipeCfg = missionConfigFile >> "ProcessAction" >> _process;
        if (!isClass _recipeCfg) exitWith {hint format ["RHD: No ProcessAction recipe named %1.", _process];};
        private _req = getArray (_recipeCfg >> "MaterialsReq");
        private _give = getArray (_recipeCfg >> "MaterialsGive");
        if (count _req < 1 || {count _give < 1}) exitWith {hint "RHD: Invalid processing recipe.";};
        private _input = (_req select 0) select 0;
        private _output = (_give select 0) select 0;
        closeDialog 0;
        [_input, _output, 1] remoteExecCall ["RHD_fnc_refineServer", 2];
        true
    };
    case 2: {hint "RHD JOBS\n\nFarming\nMining\nDeliveries\nContracts\nBusinesses"; true};
    case 3: {hint "RHD SERVICES\n\nVehicle Services\nLicenses\nDispatch\nMarketplace\nEmergency Services"; true};
    default {false};
};
