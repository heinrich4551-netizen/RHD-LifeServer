params [["_unit",player,[objNull]]];
if (isNull _unit) exitWith {""};
private _best = "";
private _bestDist = 60;
{
    private _m = _x;
    private _pos = getMarkerPos _m;
    if (_pos distance2D _unit < _bestDist) then {
        private _name = _m;
        if ((toLower _name) find "rhd_" == 0) then {_best = _name; _bestDist = _pos distance2D _unit;};
    };
} forEach allMapMarkers;
_best
