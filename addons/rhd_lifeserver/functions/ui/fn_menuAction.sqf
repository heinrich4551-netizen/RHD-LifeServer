/*
    RHD F6/F7/F8 dispatcher.
    Resource actions are sent to the dedicated server for validation.
*/
if (!hasInterface) exitWith {false};
params ['_action'];
private _mode = missionNamespace getVariable ['RHD_MenuMode',6];

if (_mode isEqualTo 7) exitWith {
    switch (_action) do {
        case 0: {hint 'RHD FARMING JOBS\n\nUse an RHD Resource Node configured in 3DEN and press F6 to harvest.';};
        case 1: {hint 'RHD MINING JOBS\n\nUse an RHD Resource Node configured in 3DEN and press F6 to harvest.';};
        case 2: {hint 'RHD DELIVERIES / CONTRACTS\n\nContract integration is enabled for the RHD server layer.';};
        case 3: {hint 'RHD BUSINESSES\n\nBusiness systems are available to the server economy layer.';};
    };
    true
};

if (_mode isEqualTo 8) exitWith {
    switch (_action) do {
        case 0: {hint 'RHD VEHICLE SERVICES\n\nVehicle services integration point ready.';};
        case 1: {hint 'RHD LICENSES\n\nUse the upstream framework license system.';};
        case 2: {hint 'RHD DISPATCH\n\nDispatch integration point ready.';};
        case 3: {hint 'RHD MARKETPLACE / EMERGENCY\n\nMarketplace and emergency-service integration points ready.';};
    };
    true
};

switch (_action) do {
    case 0: {
        private _near = [] call RHD_fnc_findNearbyResource;
        if (_near isEqualTo []) exitWith {hint 'RHD: No configured resource node is within range.';};
        _near params ['_item','_nodeIndex','_distance'];
        closeDialog 0;
        [_item] remoteExecCall ['RHD_fnc_harvestServer',2];
        true
    };
    case 1: {
        private _stations = missionNamespace getVariable ['RHD_ProcessStations',[]];
        private _best = [];
        private _bestDist = 60;
        {
            if (count _x >= 3) then {
                private _pos = _x select 0;
                private _process = toLower (_x select 1);
                private _radius = (_x select 2) max 1;
                private _d = player distance2D _pos;
                if (_d <= (_radius min 60) && {_d < _bestDist}) then {
                    _best = [_process,_d];
                    _bestDist = _d;
                };
            };
        } forEach _stations;
        if (_best isEqualTo []) exitWith {hint 'RHD: No processing station is within range.';};
        _best params ['_process','_distance'];
        private _recipeCfg = missionConfigFile >> 'ProcessAction' >> _process;
        if (!isClass _recipeCfg) exitWith {hint format ['RHD: No ProcessAction recipe named %1.',_process];};
        private _req = getArray (_recipeCfg >> 'MaterialsReq');
        private _give = getArray (_recipeCfg >> 'MaterialsGive');
        if (count _req < 1 || {count _give < 1}) exitWith {hint 'RHD: Invalid processing recipe.';};
        private _input = (_req select 0) select 0;
        private _output = (_give select 0) select 0;
        closeDialog 0;
        [_input,_output,1] remoteExecCall ['RHD_fnc_refineServer',2];
        true
    };
    case 2: {hint 'RHD JOBS\n\nFarming\nMining\nDeliveries\nContracts\nBusinesses'; true};
    case 3: {hint 'RHD SERVICES\n\nVehicle Services\nLicenses\nDispatch\nMarketplace\nEmergency Services'; true};
    default {false};
};
