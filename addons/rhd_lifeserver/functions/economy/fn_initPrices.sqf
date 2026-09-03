if (!isServer) exitWith {};

private _items = [
    ["apple",120],["grape",140],["peach",135],["corn",110],
    ["cannabis",420],["coca_leaf",500],
    ["iron_ore",180],["copper_ore",240],["gold_ore",900],["diamond",1800],["oil_sand",320],
    ["iron",360],["copper",480],["gold",1500],["fuel",260]
];

private _prices = createHashMap;
{
    _x params ["_item","_base"];
    _prices set [_item, [_base, _base, 1, 1]];
} forEach _items;

missionNamespace setVariable ["RHD_EconomyPrices", _prices, true];
