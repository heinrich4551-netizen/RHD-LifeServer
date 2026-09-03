/*
    RHD F6/F7/F8 dispatcher.
    Resource actions are sent to the dedicated server for validation.
*/
if (!hasInterface) exitWith {false};
params ["_action"];

switch (_action) do {
    case 0: {
        private _near = [] call RHD_fnc_findNearbyResource;
        if (_near isEqualTo []) exitWith {hint "RHD: No configured resource node is within 60m.";};
        _near params ["_item", "_marker", "_distance"];
        closeDialog 0;
        [_item] remoteExecCall ["RHD_fnc_harvestServer", 2];
        hint format ["RHD: Harvest request sent for %1.", _item];
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
        hint format ["RHD: Processing request sent: %1 -> %2.", _input, _output];
        true
    };
    case 2: {
        hint "RHD JOBS\n\nFarming\nMining\nDeliveries\nContracts\nBusinesses";
        true
    };
    case 3: {
        hint "RHD SERVICES\n\nVehicle Services\nLicenses\nDispatch\nMarketplace\nEmergency Services";
        true
    };
    default {false};
};
