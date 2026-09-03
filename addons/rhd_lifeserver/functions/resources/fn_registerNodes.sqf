/*
    Builds the server-side resource registry.
    Eden modules register structured nodes without needing map markers.
    Legacy rhd_resource_* markers remain supported for backwards compatibility.
*/
if (!isServer) exitWith {[]};

private _nodes = missionNamespace getVariable ['RHD_ResourceNodes',[]];
private _edenNodes = +_nodes;

{
    private _name = _x;
    private _lower = toLower _name;
    if ((_lower find 'rhd_resource_') isEqualTo 0) then {
        private _parts = _lower splitString '_';
        if (count _parts >= 3) then {
            private _item = _parts select 2;
            private _exists = _edenNodes findIf {
                (_x select 1) isEqualTo _item && {(_x select 0) distance2D (getMarkerPos _name) < 0.5}
            };
            if (_exists < 0) then {
                _edenNodes pushBack [_name, getMarkerPos _name, _item, 12, 2, 5, false, _item];
            };
        };
    };
} forEach allMapMarkers;

missionNamespace setVariable ['RHD_ResourceNodes',_edenNodes,true];

private _stations = missionNamespace getVariable ['RHD_ProcessStations',[]];
private _edenStations = +_stations;
{
    private _name = _x;
    private _lower = toLower _name;
    if ((_lower find 'rhd_process_') isEqualTo 0) then {
        private _parts = _lower splitString '_';
        if (count _parts >= 3) then {
            private _process = _parts select 2;
            private _exists = _edenStations findIf {
                (_x select 1) isEqualTo _process && {(_x select 0) distance2D (getMarkerPos _name) < 0.5}
            };
            if (_exists < 0) then {
                _edenStations pushBack [getMarkerPos _name,_process,12];
            };
        };
    };
} forEach allMapMarkers;
missionNamespace setVariable ['RHD_ProcessStations',_edenStations,true];

_edenNodes
