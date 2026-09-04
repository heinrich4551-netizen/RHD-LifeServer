/*
    Server-internal economy price setter.
    Client price changes must never be accepted directly from remote execution.
    Administrative/economy routers should authorize callers before invoking this.
*/
if (!isServer || {isRemoteExecuted}) exitWith {nil};
params [['_item','',['']],['_price',0,[0]],['_demand',1,[0]],['_supply',1,[0]]];
if (_item isEqualTo '') exitWith {nil};
_price = ((_price max 0) min 100000000);
_demand = ((_demand max 0.01) min 1000000);
_supply = ((_supply max 0.01) min 1000000);
private _prices = missionNamespace getVariable ['RHD_EconomyPrices',createHashMap];
if (isNil {_prices get _item}) exitWith {nil};
private _entry = _prices get _item;
_entry set [1,_price];
_entry set [2,_demand];
_entry set [3,_supply];
_prices set [_item,_entry];
missionNamespace setVariable ['RHD_EconomyPrices',_prices,true];
_price
