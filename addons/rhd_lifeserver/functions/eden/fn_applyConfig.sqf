/* Applies RHD 3DEN values to the live resource/economy/population systems. */
if (!isServer) exitWith {};
private _cfg = missionNamespace getVariable ['RHD_EdenConfig', createHashMap];
private _set = { params ['_key','_value']; _cfg set [_key,_value]; };
['farmingHarvestMin', ((_cfg getOrDefault ['farmingHarvestMin',2]) max 1)] call _set;
['farmingHarvestMax', ((_cfg getOrDefault ['farmingHarvestMax',5]) max (_cfg getOrDefault ['farmingHarvestMin',2]))] call _set;
['miningHarvestMin', ((_cfg getOrDefault ['miningHarvestMin',2]) max 1)] call _set;
['miningHarvestMax', ((_cfg getOrDefault ['miningHarvestMax',6]) max (_cfg getOrDefault ['miningHarvestMin',2]))] call _set;
['minimumCivilians', ((_cfg getOrDefault ['minimumCivilians',60]) max 0)] call _set;
['maximumCivilians', ((_cfg getOrDefault ['maximumCivilians',115]) max (_cfg getOrDefault ['minimumCivilians',60]))] call _set;
['civiliansAtOnePlayer', ((_cfg getOrDefault ['civiliansAtOnePlayer',115]) max 0)] call _set;
missionNamespace setVariable ['RHD_EdenConfig', _cfg, true];
