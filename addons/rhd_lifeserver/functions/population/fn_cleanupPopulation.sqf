if (!isServer) exitWith {};
private _agents = missionNamespace getVariable ["RHD_CivilianAgents", []];
private _players = allPlayers select {isPlayer _x && {!(_x isKindOf "HeadlessClient_F")}};
private _keep = [];
{
    if (isNull _x) then {continue};
    private _near = _players findIf {(_x distance2D _x) < 1800};
    if (!alive _x || {_near isEqualTo -1}) then {
        deleteVehicle _x;
    } else {
        _keep pushBack _x;
    };
} forEach _agents;
missionNamespace setVariable ["RHD_CivilianAgents", _keep];
