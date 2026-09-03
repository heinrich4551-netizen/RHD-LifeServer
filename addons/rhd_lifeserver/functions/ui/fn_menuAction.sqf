/* RHD F6/F7/F8 player interaction dispatcher. */
if (!hasInterface) exitWith {false};
params ['_action'];
private _mode = missionNamespace getVariable ['RHD_MenuMode',6];

if (_mode isEqualTo 7) exitWith {
    switch (_action) do {
        case 0: {hint 'RHD FARMING JOBS\n\nUse a configured RHD Resource Node and press F6 to harvest.';};
        case 1: {hint 'RHD MINING JOBS\n\nUse a configured RHD Resource Node and press F6 to harvest.';};
        case 2: {
            closeDialog 0;
            [player] remoteExecCall ['RHD_fnc_createContract',2];
        };
        case 3: {
            closeDialog 0;
            [player] remoteExecCall ['RHD_fnc_completeContract',2];
        };
    };
    true
};

if (_mode isEqualTo 8) exitWith {
    switch (_action) do {
        case 0: {
            closeDialog 0;
            ['VEHICLE','Vehicle service requested by civilian.',getPosATL player,2] remoteExecCall ['RHD_fnc_createServiceRequest',2];
            hint 'RHD: Vehicle service request sent.';
        };
        case 1: {
            private _licenses = missionNamespace getVariable ['RHD_Licenses',createHashMap];
            private _owned = _licenses getOrDefault [getPlayerUID player,[]];
            if (_owned isEqualTo []) then {
                hint 'RHD LICENSES\n\nNo RHD licenses are currently registered.';
            } else {
                hint format ['RHD LICENSES\n\n%1',_owned joinString '\n'];
            };
        };
        case 2: {
            closeDialog 0;
            ['GENERAL','Civilian dispatch call.',getPosATL player,2] remoteExecCall ['RHD_fnc_dispatch',2];
            hint 'RHD: Dispatch call sent.';
        };
        case 3: {
            closeDialog 0;
            ['EMS','Emergency assistance requested by civilian.',getPosATL player,1] remoteExecCall ['RHD_fnc_createServiceRequest',2];
            hint 'RHD: Emergency service request sent.';
        };
    };
    true
};

switch (_action) do {
    case 0: {
        private _near = [] call RHD_fnc_findNearbyResource;
        if (_near isEqualTo []) exitWith {hint 'RHD: No configured resource node is within range.';};
        _near params ['_item','_nodeIndex','_distance'];
        closeDialog 0;
        [player,_item] remoteExecCall ['RHD_fnc_harvestServer',2];
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
        [player,_input,_output,1] remoteExecCall ['RHD_fnc_refineServer',2];
        true
    };
    case 2: {hint 'RHD JOBS\n\nFarming\nMining\nDeliveries\nContracts'; true};
    case 3: {hint 'RHD SERVICES\n\nVehicle Services\nLicenses\nDispatch\nEmergency Services'; true};
    default {false};
};
