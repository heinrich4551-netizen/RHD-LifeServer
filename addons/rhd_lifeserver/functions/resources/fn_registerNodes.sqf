if (!isServer) exitWith {[]};
private _nodes = [];
{
    private _name = _x;
    private _lower = toLower _name;
    if (_lower find "rhd_resource_" isEqualTo 0) then {
        private _parts = _lower splitString "_";
        if (count _parts >= 3) then {
            private _item = _parts select 2;
            _nodes pushBack [_name, getMarkerPos _name, _item];
        };
    };
} forEach allMapMarkers;
missionNamespace setVariable ["RHD_ResourceNodes", _nodes, true];
_nodes
