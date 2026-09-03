params ["_item", [0, false]];
private _prices = missionNamespace getVariable ["RHD_EconomyPrices", createHashMap];
private _entry = _prices getOrDefault [_item, [0,0,1,1]];
_entry param [1, 0]
