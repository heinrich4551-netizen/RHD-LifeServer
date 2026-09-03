waitUntil {time > 0};

player setVariable ["RHD_Initialized", true, false];

player addAction ["RHD: Check Server Status", {
    private _count = count allPlayers;
    hint format ["RHD LifeServer\nPlayers online: %1\nFramework overlay: %2", _count, missionNamespace getVariable ["RHD_LifeServer_Version", "unknown"]];
}];

player addAction ["RHD: Harvest Nearby Resource", {
    private _nodes = missionNamespace getVariable ["RHD_ResourceNodes", []];
    private _near = _nodes select {
        _x params ["_marker","_pos","_item"];
        (player distance2D _pos) < 12
    };
    if (_near isEqualTo []) exitWith {hint "No RHD resource node nearby."};
    private _node = _near select 0;
    private _item = _node select 2;
    [player, _item, 1] remoteExecCall ["RHD_fnc_harvest", 2];
    hint format ["Harvest request sent: %1", _item];
}, nil, 1.5, true, true, "", "alive _target", 12];
