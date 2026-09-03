if (!hasInterface) exitWith {};
waitUntil {time > 0 && {!isNull findDisplay 46}};
private _display = findDisplay 46;
if (_display getVariable ["RHD_KeyHandlerInstalled",false]) exitWith {};
_display setVariable ["RHD_KeyHandlerInstalled",true];
_display displayAddEventHandler ["KeyDown", {
    params ["_display","_key"];
    if (dialog) exitWith {false};
    switch (_key) do {
        case 117: {createDialog "RHD_MenuDialog"; true};
        case 118: {createDialog "RHD_MenuDialog"; true};
        case 119: {createDialog "RHD_MenuDialog"; true};
        default {false};
    };
}];
