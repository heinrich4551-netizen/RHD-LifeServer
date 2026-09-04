/*
    RHD scheduled world-event scheduler.
    Events are server-created and broadcast to connected clients.
    Active effects are exposed through missionNamespace for server-side systems.
*/
if (!isServer) exitWith {false};
private _cfg = missionConfigFile >> 'RHD_LifeServer' >> 'Events';
if (getNumber (_cfg >> 'enabled') <= 0) exitWith {false};
if (getNumber (_cfg >> 'randomEvents') <= 0) exitWith {false};

private _duration = (getNumber (_cfg >> 'eventDurationMinutes') max 1) min 120;
private _interval = (getNumber (_cfg >> 'eventIntervalMinutes') max 5) min 1440;
private _last = missionNamespace getVariable ['RHD_LastWorldEvent',-1];
private _active = missionNamespace getVariable ['RHD_CurrentWorldEvent',['NONE',0,0]];
private _activeUntil = _active param [2,0];

if (_activeUntil > 0 && {diag_tickTime >= _activeUntil}) then {
    missionNamespace setVariable ['RHD_CurrentWorldEvent',['NONE',0,0],true];
    missionNamespace setVariable ['RHD_HarvestMultiplier',1,true];
    missionNamespace setVariable ['RHD_MarketEventMultiplier',1,true];
    missionNamespace setVariable ['RHD_CivilianEventMultiplier',1,true];
    _active = ['NONE',0,0];
};

/* Wait one configured interval after startup before the first event. */
if (_last < 0) then {
    missionNamespace setVariable ['RHD_LastWorldEvent',diag_tickTime];
    exitWith {false};
};
if ((diag_tickTime - _last) < (_interval * 60)) exitWith {false};
if ((_active param [0,'NONE']) != 'NONE') exitWith {false};

private _events = [
    ['DOUBLE_HARVEST','RHD EVENT: Resource harvest yields are temporarily doubled!'],
    ['MARKET_BOOM','RHD EVENT: Market demand has surged. Watch resource prices!'],
    ['CIVIL_ALERT','RHD EVENT: Increased civilian activity reported across Altis.']
];
private _event = selectRandom _events;
private _type = _event param [0,'NONE'];
private _message = _event param [1,''];
private _started = diag_tickTime;
private _ends = _started + (_duration * 60);

missionNamespace setVariable ['RHD_LastWorldEvent',_started];
missionNamespace setVariable ['RHD_CurrentWorldEvent',[_type,_started,_ends],true];
missionNamespace setVariable ['RHD_HarvestMultiplier',if (_type isEqualTo 'DOUBLE_HARVEST') then {2} else {1},true];
missionNamespace setVariable ['RHD_MarketEventMultiplier',if (_type isEqualTo 'MARKET_BOOM') then {1.15} else {1},true];
missionNamespace setVariable ['RHD_CivilianEventMultiplier',if (_type isEqualTo 'CIVIL_ALERT') then {1.15} else {1},true];

[_type,_message] remoteExecCall ['RHD_fnc_worldEventResult',-2];
true
