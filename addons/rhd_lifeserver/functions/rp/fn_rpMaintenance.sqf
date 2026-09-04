/*
    Periodic RP registry maintenance.
    Expires warrants, stale service requests, stale dispatch calls and old
    telemetry rate-limit entries. Runs on the dedicated server.
*/
if (!isServer) exitWith {false};
private _now = diag_tickTime;

private _warrants = missionNamespace getVariable ['RHD_Warrants',createHashMap];
private _expiredWarrants = [];
{
    private _entry = _warrants get _x;
    if !(_entry isEqualTo []) then {
        private _expires = _entry param [4,0];
        if (_expires > 0 && {_expires <= _now}) then {_expiredWarrants pushBack _x;};
    };
} forEach keys _warrants;
{_warrants deleteAt _x;} forEach _expiredWarrants;
if (count _expiredWarrants > 0) then {missionNamespace setVariable ['RHD_Warrants',_warrants,true];};

private _services = missionNamespace getVariable ['RHD_ServiceRequests',createHashMap];
private _expiredServices = [];
{
    private _entry = _services get _x;
    if !(_entry isEqualTo []) then {
        private _created = _entry param [1,_now];
        private _status = _entry param [8,'OPEN'];
        if (_status isEqualTo 'OPEN' && {(_now - _created) > 1800}) then {_expiredServices pushBack _x;};
    };
} forEach keys _services;
{_services deleteAt _x;} forEach _expiredServices;
if (count _expiredServices > 0) then {missionNamespace setVariable ['RHD_ServiceRequests',_services,true];};

private _dispatch = missionNamespace getVariable ['RHD_DispatchCalls',createHashMap];
private _expiredDispatch = [];
{
    private _entry = _dispatch get _x;
    if !(_entry isEqualTo []) then {
        private _created = _entry param [1,_now];
        private _status = _entry param [7,'OPEN'];
        if (_status isEqualTo 'OPEN' && {(_now - _created) > 7200}) then {_expiredDispatch pushBack _x;};
    };
} forEach keys _dispatch;
{_dispatch deleteAt _x;} forEach _expiredDispatch;
if (count _expiredDispatch > 0) then {missionNamespace setVariable ['RHD_DispatchCalls',_dispatch,true];};

private _rate = missionNamespace getVariable ['RHD_ServiceRequestRate',createHashMap];
private _staleRate = [];
{
    if ((_now - (_rate get _x)) > 3600) then {_staleRate pushBack _x;};
} forEach keys _rate;
{_rate deleteAt _x;} forEach _staleRate;
missionNamespace setVariable ['RHD_ServiceRequestRate',_rate];

true
