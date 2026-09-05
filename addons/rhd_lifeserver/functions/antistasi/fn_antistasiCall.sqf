/*
    Safe bridge for calling an Antistasi Ultimate function from RHD.

    This bridge affects ONLY the Antistasi integration. RHD-LifeServer's own
    gameplay, economy, jobs, menus, persistence and server services are not
    faction-gated by this function.

    Usage:
        ['A3A_fnc_someFunction',[_arg1,_arg2]] call RHD_fnc_antistasiCall;

    Remote calls are accepted only from the player's own network owner and
    only while that caller is Independent / Antistasi teamPlayer.
*/
params [['_function','', ['']],['_args',[],[[]]]];

private _validName = _function find 'A3A_fnc_' isEqualTo 0 || {_function find 'A3U_fnc_' isEqualTo 0};
if (!_validName) exitWith {false};

private _caller = objNull;
if (isRemoteExecuted) then {
    if (!isServer) exitWith {false};
    _caller = allPlayers select {owner _x isEqualTo remoteExecutedOwner} param [0,objNull];
    if (isNull _caller) exitWith {false};

    private _allowed = side _caller isEqualTo independent;
    if (!isNil 'teamPlayer') then {
        _allowed = _allowed && {teamPlayer isEqualTo independent};
    };
    if (!_allowed) exitWith {false};
} else {
    if (hasInterface) then {
        if (side player isNotEqualTo independent) exitWith {false};
        if (!isNil 'teamPlayer' && {teamPlayer isNotEqualTo independent}) exitWith {false};
    };
};

private _fn = missionNamespace getVariable [_function,{}];
if !(_fn isEqualType {}) exitWith {false};

_args call _fn
