params ["_resource"];
private _cfg = missionConfigFile >> "RHD_Resources";
private _result = [];
{
    private _class = _x;
    if (isClass (_cfg >> _class)) then {
        private _c = _cfg >> _class;
        private _item = getText (_c >> "item");
        if (_item != "") then {
            _result pushBack [
                _item,
                getNumber (_c >> "min"),
                getNumber (_c >> "max"),
                getText (_c >> "process"),
                getNumber (_c >> "illegal")
            ];
        };
    };
} forEach (configClasses _cfg);
_result select {toLower (_x select 0) isEqualTo toLower _resource}
