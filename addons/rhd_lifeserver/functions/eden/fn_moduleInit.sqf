/*
    RHD 3DEN runtime bridge.
    The placed module itself becomes the authoritative runtime definition;
    no map markers are required.
*/
if (!isServer) exitWith {};
params [['_logic',objNull,[objNull]],['_units',[],[[]]],['_activated',true,[true]]];
if (!_activated || {isNull _logic}) exitWith {};

private _class = typeOf _logic;

if (_class isEqualTo 'RHD_Module_LifeCore') then {
    private _cfg = missionNamespace getVariable ['RHD_EdenConfig', createHashMap];
    private _get = { params ['_name','_default']; _logic getVariable [_name,_default] };

    _cfg set ['farmingHarvestMin', ['farmingHarvestMin',2] call _get];
    _cfg set ['farmingHarvestMax', ['farmingHarvestMax',5] call _get];
    _cfg set ['miningHarvestMin', ['miningHarvestMin',2] call _get];
    _cfg set ['miningHarvestMax', ['miningHarvestMax',6] call _get];
    _cfg set ['civiliansAtOnePlayer', ['civiliansAtOnePlayer',115] call _get];
    _cfg set ['minimumCivilians', ['minimumCivilians',60] call _get];
    _cfg set ['maximumCivilians', ['maximumCivilians',115] call _get];
    _cfg set ['populationScaleWithPlayers', ['populationScaleWithPlayers',true] call _get];
    _cfg set ['harvestCooldown', ['harvestCooldown',2] call _get];
    _cfg set ['dynamicPricing', ['dynamicPricing',true] call _get];

    missionNamespace setVariable ['RHD_EdenConfig', _cfg, true];
    [] call RHD_fnc_applyConfig;
    ['RHD LifeCore 3DEN configuration applied.'] call RHD_fnc_log;
};

if (_class isEqualTo 'RHD_Module_ResourceNode') then {
    private _resourceIndex = _logic getVariable ['resourceType',0];
    private _map = [
        ['apple','Apples'],
        ['peach','Peaches'],
        ['cannabis','Cannabis Plant'],
        ['cocaine_unprocessed','Coca Leaf'],
        ['iron_unrefined','Iron Ore'],
        ['copper_unrefined','Copper Ore'],
        ['goldbar','Gold'],
        ['diamond_uncut','Uncut Diamond'],
        ['oil_unprocessed','Oil / Oil Sand']
    ];
    _resourceIndex = (_resourceIndex max 0) min ((count _map) - 1);
    private _entry = _map select _resourceIndex;
    private _item = _entry select 0;
    private _displayName = _entry select 1;
    private _min = (_logic getVariable ['minimumYield',2]) max 1;
    private _max = (_logic getVariable ['maximumYield',5]) max _min;
    private _radius = (_logic getVariable ['nodeRadius',12]) max 1;
    private _illegal = _logic getVariable ['illegal',false];
    private _enabled = _logic getVariable ['enabled',true];

    private _nodes = missionNamespace getVariable ['RHD_ResourceNodes',[]];
    if (_enabled) then {
        _nodes pushBack [getPosATL _logic, _item, _radius, _min, _max, _illegal, _displayName];
    };
    missionNamespace setVariable ['RHD_ResourceNodes',_nodes,true];
};

if (_class isEqualTo 'RHD_Module_ProcessStation') then {
    private _process = toLower (_logic getVariable ['processClass','iron']);
    private _radius = (_logic getVariable ['stationRadius',12]) max 1;
    private _enabled = _logic getVariable ['enabled',true];
    private _stations = missionNamespace getVariable ['RHD_ProcessStations',[]];
    if (_enabled && {_process != ''}) then {
        _stations pushBack [getPosATL _logic, _process, _radius];
    };
    missionNamespace setVariable ['RHD_ProcessStations',_stations,true];
};
