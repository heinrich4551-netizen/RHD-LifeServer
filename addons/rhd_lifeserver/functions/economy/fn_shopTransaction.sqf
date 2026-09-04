/*
    RHD server-side validation/audit for a completed virtual-shop transaction.
    The upstream Framework still owns the actual client inventory/cash mutation.
*/
if (!isServer || {!isRemoteExecuted}) exitWith {false};
params [['_uid','',['']],['_item','',['']],['_side',-1,[0]],['_amount',0,[0]],['_total',-1,[0]]];
if (_uid isEqualTo '' || {_item isEqualTo ''}) exitWith {false};
if !(_side in [0,1]) exitWith {false};
if (_amount <= 0 || {_amount > 10000}) exitWith {false};
if (_total < 0 || {_total > 100000000}) exitWith {false};

private _caller = allPlayers select {owner _x isEqualTo remoteExecutedOwner} param [0,objNull];
if (isNull _caller || {getPlayerUID _caller isNotEqualTo _uid}) exitWith {false};

private _prices = missionNamespace getVariable ['RHD_EconomyPrices',createHashMap];
private _entry = _prices getOrDefault [_item,[]];
if (_entry isEqualTo []) exitWith {false};
private _direction = if (_side isEqualTo 1) then {1} else {0};
private _unitPrice = [_item,_direction] call RHD_fnc_shopPrice;
if (_unitPrice < 0 || {_total isNotEqualTo (_unitPrice * _amount)}) exitWith {false};

private _rate = missionNamespace getVariable ['RHD_ShopTelemetryRate',createHashMap];
private _last = _rate getOrDefault [_uid,0];
if ((diag_tickTime - _last) < 0.25) exitWith {false};
_rate set [_uid,diag_tickTime];
missionNamespace setVariable ['RHD_ShopTelemetryRate',_rate];

private _taxable = round (_total max 0);
if (_taxable > 0) then {
    /* Sales tax is collected server-side after a validated shop operation. */
    [_caller,'SALES',_taxable,format ['Virtual shop %1',_item]] call RHD_fnc_taxTransaction;
};

private _supply = if (_side isEqualTo 1) then {_amount} else {0};
private _demand = if (_side isEqualTo 0) then {_amount} else {0};
[_item,_supply,_demand] call RHD_fnc_recordMarket;
true
