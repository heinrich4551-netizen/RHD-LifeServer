if (!isServer) exitWith {};

/*
    Price keys use the actual virtual-item class names consumed by the
    Framework inventory/shop layer. This keeps RHD pricing compatible with
    both upstream and RHD-added items.
*/
private _items = [
    ['apple',120],['peach',135],['grape',140],['corn',110],
    ['cannabis',420],['coca_leaf',500],
    ['iron_unrefined',180],['copper_unrefined',240],['gold_ore',900],
    ['diamond_uncut',1800],['oil_sand',320],
    ['iron_refined',360],['copper_refined',480],['gold',1500],['fuelFull',260],
    ['marijuana',700],['cocaine_processed',1200]
];

private _prices = createHashMap;
{
    _x params ['_item','_base'];
    _prices set [_item, [_base, _base, 1, 1]];
} forEach _items;

missionNamespace setVariable ['RHD_EconomyPrices', _prices, true];
