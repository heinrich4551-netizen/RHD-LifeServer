/*
    RHD shop transaction validation helper.
    Server-side only. Keeps telemetry input bounded and rejects invalid item keys.
*/
if (!isServer) exitWith {false};
params [['_item','',['']],['_supplyDelta',0,[0]],['_demandDelta',0,[0]]];
if (_item isEqualTo '') exitWith {false};
if ((_supplyDelta < 0) || {_demandDelta < 0}) exitWith {false};
if ((_supplyDelta + _demandDelta) > 10000) exitWith {false};
private _tracked = missionNamespace getVariable ['RHD_EconomyPrices',createHashMap];
if !(_tracked isEqualType createHashMap) exitWith {false};
if (isNil {_tracked get _item}) exitWith {false};
[_item,_supplyDelta,_demandDelta] call RHD_fnc_recordMarket
