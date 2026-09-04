/*
    RHD authoritative transaction audit endpoint.
    This endpoint records a completed client-side Framework shop transaction.
    Inventory/cash remain owned by the upstream Framework APIs.
*/
if (!isServer) exitWith {false};
params [['_uid','',['']],['_item','',['']],['_side',-1,[0]],['_amount',0,[0]],['_total',0,[0]]];
if (_uid isEqualTo '' || {_item isEqualTo ''}) exitWith {false};
if !(_side in [0,1]) exitWith {false};
if (_amount <= 0 || {_amount > 10000}) exitWith {false};
if (_total < 0 || {_total > 100000000}) exitWith {false};
private _tracked = missionNamespace getVariable ['RHD_EconomyPrices',createHashMap];
if (isNil {_tracked get _item}) exitWith {false};
private _supply = if (_side isEqualTo 1) then {_amount} else {0};
private _demand = if (_side isEqualTo 0) then {_amount} else {0};
[_item,_supply,_demand] call RHD_fnc_recordMarket;
true
