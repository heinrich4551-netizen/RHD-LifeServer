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

    _cfg set ['farmingHarvestMin', ['RHD_farmingHarvestMin',2] call _get];
    _cfg set ['farmingHarvestMax', ['RHD_farmingHarvestMax',5] call _get];
    _cfg set ['miningHarvestMin', ['RHD_miningHarvestMin',2] call _get];
    _cfg set ['miningHarvestMax', ['RHD_miningHarvestMax',6] call _get];
    _cfg set ['civiliansAtOnePlayer', ['RHD_civiliansAtOnePlayer',115] call _get];
    _cfg set ['minimumCivilians', ['RHD_minimumCivilians',60] call _get];
    _cfg set ['maximumCivilians', ['RHD_maximumCivilians',115] call _get];
    _cfg set ['populationScaleWithPlayers', ['RHD_populationScaleWithPlayers',true] call _get];
    _cfg set ['harvestCooldown', ['RHD_harvestCooldown',2] call _get];
    _cfg set ['dynamicPricing', ['RHD_dynamicPricing',true] call _get];
    _cfg set ['farmingEnabled', ['RHD_farmingEnabled',true] call _get];
    _cfg set ['miningEnabled', ['RHD_miningEnabled',true] call _get];
    _cfg set ['useHeadlessClient', ['RHD_useHeadlessClient',true] call _get];
    _cfg set ['hcSpawnBatch', ['RHD_hcSpawnBatch',12] call _get];
    _cfg set ['civilianDespawnDistance', ['RHD_civilianDespawnDistance',2500] call _get];
    _cfg set ['persistenceEnabled', ['RHD_persistenceEnabled',true] call _get];
    _cfg set ['worldEventsEnabled', ['RHD_worldEventsEnabled',true] call _get];

    missionNamespace setVariable ['RHD_EdenConfig', _cfg, true];
    [] call RHD_fnc_applyConfig;
    ['RHD LifeCore 3DEN configuration applied.'] call RHD_fnc_log;
};

if (_class isEqualTo 'RHD_Module_ResourceNode') then {
    private _resourceIndex = _logic getVariable ['RHD_resourceType',0];
    private _map = [
        ['apple','Apples'],
        ['peach','Peaches'],
        ['grape','Grapes'],
        ['corn','Corn Cob'],
        ['cannabis','Cannabis Plant'],
        ['coca_leaf','Coca Leaf'],
        ['iron_unrefined','Iron Ore'],
        ['copper_unrefined','Copper Ore'],
        ['gold_ore','Gold Ore'],
        ['diamond_uncut','Uncut Diamond'],
        ['oil_sand','Oil Sand']
    ];
    _resourceIndex = (_resourceIndex max 0) min ((count _map) - 1);
    private _entry = _map select _resourceIndex;
    private _item = _entry select 0;
    private _displayName = _entry select 1;
    private _min = (_logic getVariable ['RHD_minimumYield',2]) max 1;
    private _max = (_logic getVariable ['RHD_maximumYield',5]) max _min;
    private _radius = (_logic getVariable ['RHD_nodeRadius',12]) max 1;
    private _illegal = _logic getVariable ['RHD_illegal',false];
    private _enabled = _logic getVariable ['RHD_enabled',true];

    private _nodes = missionNamespace getVariable ['RHD_ResourceNodes',[]];
    if (_enabled) then {
        _nodes pushBack [getPosATL _logic, _item, _radius, _min, _max, _illegal, _displayName];
    };
    missionNamespace setVariable ['RHD_ResourceNodes',_nodes,true];
};

if (_class isEqualTo 'RHD_Module_ProcessStation') then {
    private _processIndex = _logic getVariable ['RHD_processClass',0];
    private _processMap = [
        'iron',
        'copper',
        'gold',
        'oil',
        'diamond',
        'cannabis'
    ];
    _processIndex = (_processIndex max 0) min ((count _processMap) - 1);
    private _process = _processMap select _processIndex;
    private _radius = (_logic getVariable ['RHD_stationRadius',12]) max 1;
    private _enabled = _logic getVariable ['RHD_enabled',true];
    private _stations = missionNamespace getVariable ['RHD_ProcessStations',[]];
    if (_enabled) then {
        _stations pushBack [getPosATL _logic, _process, _radius];
    };
    missionNamespace setVariable ['RHD_ProcessStations',_stations,true];
};
