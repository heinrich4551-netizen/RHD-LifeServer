if (!hasInterface) exitWith {};
waitUntil {time > 0 && {!isNull findDisplay 46}};
private _display = findDisplay 46;
if (_display getVariable ["RHD_KeyHandlerInstalled",false]) exitWith {};
_display setVariable ["RHD_KeyHandlerInstalled",true];
_display displayAddEventHandler ["KeyDown", {
    params ["_display","_key"];
    if (dialog) exitWith {false};
    private _mode = -1;
    switch (_key) do {
        case 117: {_mode = 6;};
        case 118: {_mode = 7;};
        case 119: {_mode = 8;};
        default {};
    };
    if (_mode isEqualTo -1) exitWith {false};
    missionNamespace setVariable ["RHD_MenuMode", _mode];
    if !(createDialog "RHD_MenuDialog") exitWith {false};
    private _menu = findDisplay 8800;
    if (isNull _menu) exitWith {false};
    private _header = _menu displayCtrl 1001;
    private _a1 = _menu displayCtrl 1601;
    private _a2 = _menu displayCtrl 1602;
    private _a3 = _menu displayCtrl 1603;
    private _a4 = _menu displayCtrl 1604;

    private _copLevel = missionNamespace getVariable ["life_coplevel",0];
    private _medicLevel = missionNamespace getVariable ["life_mediclevel",0];
    private _isCop = _copLevel > 0;
    private _isMedic = _medicLevel > 0;

    switch (_mode) do {
        case 6: {
            _header ctrlSetText "RHD LIFE | CIVILIAN";
            _a1 ctrlSetText "Harvest Nearby Resource";
            _a2 ctrlSetText "Process Resources";
            _a3 ctrlSetText "Jobs / Contracts";
            _a4 ctrlSetText "Marketplace";
        };
        case 7: {
            _header ctrlSetText "RHD LIFE | JOBS";
            _a1 ctrlSetText "Farming Jobs";
            _a2 ctrlSetText "Mining Jobs";
            _a3 ctrlSetText "Deliveries / Contracts";
            _a4 ctrlSetText "Job Progress";
        };
        case 8: {
            if (_isCop || _isMedic) then {
                private _role = if (_isCop && _isMedic) then {"PUBLIC SAFETY"} else {if (_isCop) then {"POLICE"} else {"EMS"}};
                _header ctrlSetText format ["RHD LIFE | %1",_role];
                _a1 ctrlSetText "Dispatch Console";
                _a2 ctrlSetText "Acknowledge Latest Call";
                _a3 ctrlSetText "Close Latest Call";
                if (_isCop) then {
                    _a4 ctrlSetText "Police / DMV Services";
                } else {
                    _a4 ctrlSetText "EMS Services";
                };
            } else {
                _header ctrlSetText "RHD LIFE | SERVICES";
                _a1 ctrlSetText "Request Vehicle Service";
                _a2 ctrlSetText "View Licenses";
                _a3 ctrlSetText "Send Dispatch Call";
                _a4 ctrlSetText "Request Emergency Service";
            };
        };
    };
    true
}];
