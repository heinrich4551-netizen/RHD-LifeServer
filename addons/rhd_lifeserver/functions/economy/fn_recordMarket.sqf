/*
    Increment short-term supply/demand counters used by RHD dynamic pricing.
    Positive supply represents production entering the market.
    Positive demand represents consumption/processing pressure.
*/
if (!isServer) exitWith {false};
params [['_item','',['']],['_supplyDelta',0,[0]],['_demandDelta',0,[0]]];
if (_item isEqualTo '') exitWith {false};

private _prices = missionNamespace getVariable ['RHD_EconomyPrices',createHashMap];
private _entry = _prices getOrDefault [_item,[0,0,1,1]];
_entry set [2, ((_entry param [2,1]) + (_demandDelta max 0)) max 0.01];
_entry set [3, ((_entry param [3,1]) + (_supplyDelta max 0)) max 0.01];
_prices set [_item,_entry];
missionNamespace setVariable ['RHD_EconomyPrices',_prices,true];
true
