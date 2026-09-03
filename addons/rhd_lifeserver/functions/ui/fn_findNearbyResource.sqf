/*
    Returns [virtualItem, nodeIndex, distance] for the nearest configured RHD node.
    Resource nodes are normally created by 3DEN modules; legacy markers are
    already converted into the same server registry.
*/
params [['_unit',player,[objNull]]];
if (isNull _unit) exitWith {[]};
private _best = [];
private _bestDist = 60;
private _nodes = missionNamespace getVariable ['RHD_ResourceNodes',[]];
{
    if (count _x >= 3) then {
        private _pos = _x select 0;
        private _item = _x select 1;
        private _radius = (_x select 2) max 1;
        private _distance = _pos distance2D _unit;
        private _range = _radius min 60;
        if (_distance <= _range && {_distance < _bestDist}) then {
            _best = [_item,_forEachIndex,_distance];
            _bestDist = _distance;
        };
    };
} forEach _nodes;
_best
