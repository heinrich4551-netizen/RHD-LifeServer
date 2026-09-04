/* RHD F6/F7/F8 player interaction dispatcher. */
if (!hasInterface) exitWith {false};
params ['_action'];
private _mode = missionNamespace getVariable ['RHD_MenuMode',6];
private _copLevel = missionNamespace getVariable ['life_coplevel',0];
private _medicLevel = missionNamespace getVariable ['life_mediclevel',0];
private _isCop = _copLevel > 0;
private _isMedic = _medicLevel > 0;

if (_mode isEqualTo 7) exitWith {
    private _progress = missionNamespace getVariable ['RHD_MyJobProgress',[0,0,1,1]];
    _progress params ['_legalXP','_illegalXP','_legalLevel','_illegalLevel'];
    switch (_action) do {
        case 0: { hint format ['RHD FARMING JOBS\n\nLegal Level: %1\nLegal XP: %2\n\nUse a configured farming resource node and press F6 to harvest.',_legalLevel,_legalXP]; };
        case 1: { hint format ['RHD MINING JOBS\n\nLegal Level: %1\nLegal XP: %2\n\nUse a configured mining resource node and press F6 to harvest.',_legalLevel,_legalXP]; };
        case 2: { closeDialog 0; [player] remoteExecCall ['RHD_fnc_createContract',2]; };
        case 3: { closeDialog 0; ['BUSINESS_INFO',[]] remoteExecCall ['RHD_fnc_rpAction',2]; };
    };
    true
};

if (_mode isEqualTo 8) exitWith {
    if (_isCop || _isMedic) exitWith {
        switch (_action) do {
            case 0: {
                private _calls = missionNamespace getVariable ['RHD_DispatchCalls',createHashMap];
                private _lines = ['RHD DISPATCH CONSOLE',''];
                {
                    private _e = _calls getOrDefault [_x,[]];
                    if !(_e isEqualTo []) then {
                        private _status = _e param [7,'OPEN'];
                        if (_status in ['OPEN','ACK']) then {_lines pushBack format ['%1 | P%2 | %3 | %4 | %5',_e param [0,''],_e param [5,2],_e param [2,'GENERAL'],_status,_e param [3,'']];};
                    };
                } forEach keys _calls;
                if (count _lines <= 2) then {_lines pushBack 'No open or acknowledged calls.';};
                hint (_lines joinString '\n');
            };
            case 1: {
                private _calls = missionNamespace getVariable ['RHD_DispatchCalls',createHashMap]; private _open = [];
                {private _e=_calls getOrDefault [_x,[]]; if !(_e isEqualTo []) then {if ((_e param [7,'OPEN']) in ['OPEN','ACK']) then {_open pushBack [_e param [1,0],_x];};};} forEach keys _calls;
                if (_open isEqualTo []) exitWith {hint 'RHD: No dispatch calls to acknowledge.';};
                _open sort true; private _id = (_open select ((count _open)-1)) param [1,''];
                closeDialog 0; ['DISPATCH_ACK',[_id]] remoteExecCall ['RHD_fnc_rpAction',2];
            };
            case 2: {
                private _calls = missionNamespace getVariable ['RHD_DispatchCalls',createHashMap]; private _open = [];
                {private _e=_calls getOrDefault [_x,[]]; if !(_e isEqualTo []) then {if ((_e param [7,'OPEN']) in ['OPEN','ACK']) then {_open pushBack [_e param [1,0],_x];};};} forEach keys _calls;
                if (_open isEqualTo []) exitWith {hint 'RHD: No dispatch calls to close.';};
                _open sort true; private _id = (_open select ((count _open)-1)) param [1,''];
                closeDialog 0; ['DISPATCH_CLOSE',[_id]] remoteExecCall ['RHD_fnc_rpAction',2];
            };
            case 3: {
                if (_isCop) then {
                    private _target = cursorTarget;
                    if (!isNull _target && {_target isKindOf 'LandVehicle'}) then {
                        closeDialog 0;
                        if (_target getVariable ['RHD_Impounded',false]) then {
                            ['RELEASE_IMPOUND_TARGET',[_target]] remoteExecCall ['RHD_fnc_rpAction',2];
                            hint 'RHD: Impound release request sent to server.';
                        } else {
                            ['IMPOUND',[_target,'Police impound']] remoteExecCall ['RHD_fnc_rpAction',2];
                            hint 'RHD: Impound request sent to server.';
                        };
                    } else {
                        closeDialog 0;
                        ['LIST_IMPOUNDS',[]] remoteExecCall ['RHD_fnc_rpAction',2];
                        hint 'RHD: Requesting current impound registry...';
                    };
                } else {
                    private _target = cursorTarget;
                    if (isNull _target || {!(_target isKindOf 'CAManBase')}) exitWith {hint 'RHD: Look directly at the patient.';};
                    if (_target isEqualTo player) exitWith {hint 'RHD: You cannot treat yourself through this action.';};
                    closeDialog 0;
                    ['TREAT',[_target]] remoteExecCall ['RHD_fnc_rpAction',2];
                    hint 'RHD: Treatment request sent to the EMS server.';
                };
            };
        };
        true
    };

    switch (_action) do {
        case 0: { closeDialog 0; ['MECHANIC','Vehicle service requested by civilian.',getPosATL player,2] remoteExecCall ['RHD_fnc_createServiceRequest',2]; hint 'RHD: Vehicle service request sent.'; };
        case 1: { closeDialog 0; [getPlayerUID player] remoteExecCall ['RHD_fnc_getLicenses',2]; };
        case 2: { closeDialog 0; ['GENERAL','Civilian dispatch call.',getPosATL player,2] remoteExecCall ['RHD_fnc_dispatch',2]; hint 'RHD: Dispatch call sent.'; };
        case 3: { closeDialog 0; ['EMS','Emergency assistance requested by civilian.',getPosATL player,1] remoteExecCall ['RHD_fnc_createServiceRequest',2]; hint 'RHD: Emergency assistance request sent.'; };
    };
    true
};

switch (_action) do {
    case 0: {
        private _near = [] call RHD_fnc_findNearbyResource;
        if (_near isEqualTo []) exitWith {hint 'RHD: No configured resource node is within range.';};
        _near params ['_item','_nodeIndex','_distance'];
        closeDialog 0; [player,_item] remoteExecCall ['RHD_fnc_harvestServer',2]; true
    };
    case 1: {
        private _stations = missionNamespace getVariable ['RHD_ProcessStations',[]]; private _best = []; private _bestDist = 60;
        { if (count _x >= 3) then { private _pos=_x select 0; private _process=toLower (_x select 1); private _radius=(_x select 2) max 1; private _d=player distance2D _pos; if (_d <= (_radius min 60) && {_d < _bestDist}) then {_best=[_process,_d];_bestDist=_d;}; }; } forEach _stations;
        if (_best isEqualTo []) exitWith {hint 'RHD: No processing station is within range.';};
        _best params ['_process','_distance']; private _recipeCfg = missionConfigFile >> 'ProcessAction' >> _process;
        if (!isClass _recipeCfg) exitWith {hint format ['RHD: No ProcessAction recipe named %1.',_process];};
        private _req=getArray (_recipeCfg >> 'MaterialsReq'); private _give=getArray (_recipeCfg >> 'MaterialsGive');
        if (count _req < 1 || {count _give < 1}) exitWith {hint 'RHD: Invalid processing recipe.';};
        private _input=(_req select 0) select 0; private _output=(_give select 0) select 0;
        closeDialog 0; [player,_input,_output,1] remoteExecCall ['RHD_fnc_refineServer',2]; true
    };
    case 2: {hint 'RHD JOBS\n\nFarming\nMining\nDeliveries\nContracts'; true};
    case 3: {
        private _prices=missionNamespace getVariable ['RHD_EconomyPrices',createHashMap]; private _lines=['RHD MARKETPLACE',''];
        { private _entry=_prices get _x; if !(_entry isEqualTo []) then {private _display=getText (missionConfigFile >> 'VirtualItems' >> _x >> 'displayName'); if (_display isEqualTo '') then {_display=_x;}; _lines pushBack format ['%1: $%2',_display,round (_entry param [1,0])];}; } forEach keys _prices;
        hint (_lines joinString '\n'); true
    };
    default {false};
};
