/*
    RHD virtual-shop list updater.

    Populates the standard Framework shop dialog using RHD's live market
    prices. It remains compatible with the existing 2400/2401/2402 controls.
*/
disableSerialization;
if (!hasInterface) exitWith {false};
private _display = findDisplay 2400;
if (isNull _display) exitWith {false};
if (!isClass (missionConfigFile >> 'VirtualShops' >> life_shop_type)) exitWith {
    closeDialog 0;
    hint localize 'STR_NOTF_ConfigDoesNotExist';
    false
};

private _items = getArray (missionConfigFile >> 'VirtualShops' >> life_shop_type >> 'items');
private _buyList = _display displayCtrl 2401;
private _sellList = _display displayCtrl 2402;
lbClear _buyList;
lbClear _sellList;

private _title = _display displayCtrl 2403;
ctrlSetText [2403,getText (missionConfigFile >> 'VirtualShops' >> life_shop_type >> 'name')];

{
    private _item = _x;
    private _name = getText (missionConfigFile >> 'VirtualItems' >> _item >> 'displayName');
    if (_name isEqualTo '') then {_name = _item;};
    private _buy = [_item,0] call RHD_fnc_shopPrice;
    if (_buy >= 0) then {
        _buyList lbAdd format ['%1  ($%2)',localize _name,[_buy] call life_fnc_numberText];
        private _i = (lbSize _buyList) - 1;
        _buyList lbSetData [_i,_item];
        _buyList lbSetValue [_i,_buy];
        private _icon = getText (missionConfigFile >> 'VirtualItems' >> _item >> 'icon');
        if !(_icon isEqualTo '') then {_buyList lbSetPicture [_i,_icon];};
    };

    private _owned = ITEM_VALUE(_item);
    private _sell = [_item,1] call RHD_fnc_shopPrice;
    if (_owned > 0 && {_sell >= 0}) then {
        _sellList lbAdd format ['%1 [x%2]  ($%3 ea)',localize _name,_owned,[_sell] call life_fnc_numberText];
        private _j = (lbSize _sellList) - 1;
        _sellList lbSetData [_j,_item];
        _sellList lbSetValue [_j,_sell];
        private _icon = getText (missionConfigFile >> 'VirtualItems' >> _item >> 'icon');
        if !(_icon isEqualTo '') then {_sellList lbSetPicture [_j,_icon];};
    };
} forEach _items;
true
