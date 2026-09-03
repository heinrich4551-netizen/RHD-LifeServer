/*
    Returns [virtualItem, markerName, distance] for the nearest RHD resource node.
    Marker format: rhd_resource_<virtualItem>_<id>
*/
params [["_unit", player, [objNull]]];
if (isNull _unit) exitWith {[]};
private _best = [];
private _bestDist = 60;
{
    private _marker = _x;
    private _lower = toLower _marker;
    if ((_lower find "rhd_resource_") isEqualTo 0) then {
        private _pos = getMarkerPos _marker;
        private _distance = _pos distance2D _unit;
        if (_distance < _bestDist) then {
            private _parts = _lower splitString "_";
            if (count _parts >= 4) then {
                private _item = _parts select 2;
                _best = [_item, _marker, _distance];
                _bestDist = _distance;
            };
        };
    };
} forEach allMapMarkers;
_best
