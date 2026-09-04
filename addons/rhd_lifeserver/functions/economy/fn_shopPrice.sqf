/*
    RHD dynamic virtual-shop pricing.

    Returns the effective shop price for an item. RHD-tracked items use the
    live supply/demand price; all other Framework virtual items fall back to
    their mission-configured buy/sell price.

    [item, direction] call RHD_fnc_shopPrice
    direction: 0 = buy, 1 = sell
*/
params [['_item','',['']],['_direction',0,[0]]];
if (_item isEqualTo '') exitWith {0};

private _prices = missionNamespace getVariable ['RHD_EconomyPrices',createHashMap];
private _entry = _prices getOrDefault [_item,[]];
private _dynamic = !(_entry isEqualTo []) && {(_entry param [1,0]) > 0};
private _base = if (_dynamic) then {_entry param [1,0]} else {
    private _field = if (_direction isEqualTo 1) then {'sellPrice'} else {'buyPrice'};
    getNumber (missionConfigFile >> 'VirtualItems' >> _item >> _field)
};
if (_base < 0) exitWith {-1};

private _sellMultiplier = getNumber (missionConfigFile >> 'RHD_LifeServer' >> 'Economy' >> 'shopSellMultiplier');
if (_sellMultiplier <= 0) then {_sellMultiplier = 0.80;};
private _buyMultiplier = getNumber (missionConfigFile >> 'RHD_LifeServer' >> 'Economy' >> 'shopBuyMultiplier');
if (_buyMultiplier <= 0) then {_buyMultiplier = 1.00;};

private _price = if (_direction isEqualTo 1) then {_base * _sellMultiplier} else {_base * _buyMultiplier};
private _eventMultiplier = (missionNamespace getVariable ['RHD_MarketEventMultiplier',1]) max 0.1;
_price = _price * _eventMultiplier;
round (_price max 0)
