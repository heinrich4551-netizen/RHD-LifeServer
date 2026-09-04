/*
    RHD virtual-shop sell transaction.

    Uses the live RHD market price for tracked resources and records demand
    telemetry on the dedicated server. The upstream Framework is untouched.
*/
disableSerialization;
if (!hasInterface || {isNull player}) exitWith {false};
private _display = findDisplay 2400;
if (isNull _display) exitWith {false};
private _list = _display displayCtrl 2402;
private _edit = _display displayCtrl 2405;
if (isNull _list || {isNull _edit}) exitWith {false};
private _index = lbCurSel _list;
if (_index < 0) exitWith {hint 'Select an item to sell.'; false};

private _item = _list lbData _index;
private _amountText = ctrlText _edit;
if !([_amountText] call TON_fnc_isnumber) exitWith {hint localize 'STR_Shop_Virt_NoNum'; false};
private _amount = floor parseNumber _amountText;
if (_amount <= 0) exitWith {hint 'Enter a valid quantity.'; false};
private _owned = ITEM_VALUE(_item);
if (_amount > _owned) exitWith {hint localize 'STR_Shop_Virt_NotEnough'; false};
if ((time - life_action_delay) < 0.2) exitWith {hint localize 'STR_NOTF_ActionDelay'; false};
life_action_delay = time;

private _price = [_item,1] call RHD_fnc_shopPrice;
if (_price < 0) exitWith {hint 'This item cannot be sold here.'; false};
private _total = _price * _amount;
if !([false,_item,_amount] call life_fnc_handleInv) exitWith {false};
CASH = CASH + _total;
[0] call SOCK_fnc_updatePartial;
[3] call SOCK_fnc_updatePartial;
[] call life_fnc_virt_update;

[_item,0,_amount] remoteExecCall ['RHD_fnc_recordMarket',2];
private _name = getText (missionConfigFile >> 'VirtualItems' >> _item >> 'displayName');
if (_name isEqualTo '') then {_name = _item;};
hint format ['Sold %1 x%2 for $%3.',_name,_amount,[_total] call life_fnc_numberText];
true
