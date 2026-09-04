/* RHD market-aware replacement for the Framework virtual buy callback. */
disableSerialization;
if (!hasInterface || {isNull player}) exitWith {false};
private _display = findDisplay 2400;
if (isNull _display) exitWith {false};
private _list = _display displayCtrl 2401;
private _edit = _display displayCtrl 2404;
if (isNull _list || {isNull _edit}) exitWith {false};
private _index = lbCurSel _list;
if (_index < 0) exitWith {hint 'Select an item to buy.'; false};

private _item = _list lbData _index;
private _amountText = ctrlText _edit;
if !([_amountText] call TON_fnc_isnumber) exitWith {hint localize 'STR_Shop_Virt_NoNum'; false};
private _amount = floor parseNumber _amountText;
if (_amount <= 0 || {_amount > 10000}) exitWith {hint 'Enter a valid quantity.'; false};

private _price = [_item,0] call RHD_fnc_shopPrice;
if (_price < 0) exitWith {hint 'This item cannot be purchased here.'; false};
private _diff = [_item,_amount,life_carryWeight,life_maxWeight] call life_fnc_calWeightDiff;
if (_diff <= 0) exitWith {hint localize 'STR_NOTF_NoSpace'; false};
_amount = floor _diff;
private _total = _price * _amount;
if (_total > CASH) exitWith {hint localize 'STR_NOTF_NotEnoughMoney'; false};
if ((time - life_action_delay) < 0.2) exitWith {hint localize 'STR_NOTF_ActionDelay'; false};
life_action_delay = time;

if !([true,_item,_amount] call life_fnc_handleInv) exitWith {false};
CASH = CASH - _total;
[0] call SOCK_fnc_updatePartial;
[3] call SOCK_fnc_updatePartial;
[] call RHD_fnc_virtUpdate;

[getPlayerUID player,_item,0,_amount,_total] remoteExecCall ['RHD_fnc_shopTransaction',2];
private _name = getText (missionConfigFile >> 'VirtualItems' >> _item >> 'displayName');
if (_name isEqualTo '') then {_name = _item;};
hint format ['Bought %1 x%2 for $%3.',_name,_amount,[_total] call life_fnc_numberText];
true
