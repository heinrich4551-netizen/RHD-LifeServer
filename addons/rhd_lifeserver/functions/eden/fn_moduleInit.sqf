/* RHD 3DEN runtime configuration bridge. */
if (!isServer) exitWith {};
params [['_logic',objNull,[objNull]],['_units',[],[[]]],['_activated',true,[true]]];
if (!_activated || {isNull _logic}) exitWith {};
private _get = { params ['_name','_default']; _logic getVariable [_name,_default] };
missionNamespace setVariable ['RHD_EdenConfig', createHashMap, true];
private _cfg = missionNamespace getVariable 'RHD_EdenConfig';
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
['RHD 3DEN configuration applied.'] call RHD_fnc_log;
