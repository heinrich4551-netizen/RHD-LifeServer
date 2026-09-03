if (!isServer) exitWith {};
private _agents = missionNamespace getVariable ["RHD_CivilianAgents", []];
private _players = allPlayers select {isPlayer _x && {!(_x isKindOf "HeadlessClient_F")}};
private _keep = [];
{
    private _agent = _x;
    if (isNull _agent) then {continue};
    private _near = _players findIf {(_agent distance2D _x) < 1800};
    if (!alive _agent || {_near isEqualTo -1}) then {
        deleteVehicle _agent;
    } else {
        _keep pushBack _agent;
    };
} forEach _agents;
missionNamespace setVariable ["RHD_CivilianAgents", _keep];
