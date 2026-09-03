if (!isServer) exitWith {nil};
params ["_item", "_price", ["_demand", 1], ["_supply", 1]];
private _prices = missionNamespace getVariable ["RHD_EconomyPrices", createHashMap];
private _entry = _prices getOrDefault [_item, [0,0,1,1]];
_entry set [1, _price max 0];
_entry set [2, _demand max 0];
_entry set [3, _supply max 0.01];
_prices set [_item, _entry];
missionNamespace setVariable ["RHD_EconomyPrices", _prices, true];
_price
