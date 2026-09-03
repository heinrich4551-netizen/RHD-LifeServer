/* Applies and validates RHD 3DEN values to the live systems. */
if (!isServer) exitWith {};
private _cfg = missionNamespace getVariable ['RHD_EdenConfig', createHashMap];

private _fMin = ((_cfg getOrDefault ['farmingHarvestMin',2]) max 1);
private _fMax = ((_cfg getOrDefault ['farmingHarvestMax',5]) max _fMin);
private _mMin = ((_cfg getOrDefault ['miningHarvestMin',2]) max 1);
private _mMax = ((_cfg getOrDefault ['miningHarvestMax',6]) max _mMin);
private _minCiv = ((_cfg getOrDefault ['minimumCivilians',60]) max 0);
private _maxCiv = ((_cfg getOrDefault ['maximumCivilians',115]) max _minCiv);
private _oneCiv = ((_cfg getOrDefault ['civiliansAtOnePlayer',115]) max _minCiv) min _maxCiv;
private _scale = _cfg getOrDefault ['populationScaleWithPlayers',true];
private _cooldown = ((_cfg getOrDefault ['harvestCooldown',2]) max 0.1);
private _dynamic = _cfg getOrDefault ['dynamicPricing',true];

_cfg set ['farmingHarvestMin',_fMin];
_cfg set ['farmingHarvestMax',_fMax];
_cfg set ['miningHarvestMin',_mMin];
_cfg set ['miningHarvestMax',_mMax];
_cfg set ['minimumCivilians',_minCiv];
_cfg set ['maximumCivilians',_maxCiv];
_cfg set ['civiliansAtOnePlayer',_oneCiv];
_cfg set ['populationScaleWithPlayers',_scale];
_cfg set ['harvestCooldown',_cooldown];
_cfg set ['dynamicPricing',_dynamic];

missionNamespace setVariable ['RHD_EdenConfig',_cfg,true];
missionNamespace setVariable ['RHD_HarvestCooldown',_cooldown,true];
missionNamespace setVariable ['RHD_DynamicPricing',_dynamic,true];
