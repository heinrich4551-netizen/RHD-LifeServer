/*
    RHD scheduled world-event scheduler.
    Events are server-created and broadcast to connected clients.
    Configure timing in RHD_LifeServer.hpp.
*/
if (!isServer) exitWith {false};
private _cfg = missionConfigFile >> 'RHD_LifeServer' >> 'Events';
if (getNumber (_cfg >> 'enabled') <= 0) exitWith {false};
private _interval = (getNumber (_cfg >> 'intervalMinutes') max 5) min 1440;
private _last = missionNamespace getVariable ['RHD_LastWorldEvent',-1];
if (_last >= 0 && {(diag_tickTime - _last) < (_interval * 60)}) exitWith {false};

private _events = [
    ['DOUBLE_HARVEST','RHD EVENT: Resource harvest yields are temporarily doubled!'],
    ['MARKET_BOOM','RHD EVENT: Market demand has surged. Watch resource prices!'],
    ['CIVIL_ALERT','RHD EVENT: Increased civilian activity reported across Altis.']
];
private _event = selectRandom _events;
missionNamespace setVariable ['RHD_LastWorldEvent',diag_tickTime];
missionNamespace setVariable ['RHD_CurrentWorldEvent',[_event param [0,''],diag_tickTime],true];
[_event param [0,''],_event param [1,'']] remoteExecCall ['RHD_fnc_worldEventResult',-2];
true
