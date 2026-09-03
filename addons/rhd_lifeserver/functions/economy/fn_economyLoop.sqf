if (!isServer) exitWith {};
if (isNil {missionNamespace getVariable 'RHD_EconomyPrices'}) then {[] call RHD_fnc_initPrices;};

private _prices = missionNamespace getVariable ['RHD_EconomyPrices',createHashMap];
private _floor = missionNamespace getVariable ['RHD_EconomyFloor',0.65];
private _ceiling = missionNamespace getVariable ['RHD_EconomyCeiling',1.35];

{
    private _item = _x;
    private _entry = _prices get _item;
    _entry params ['_base','_current','_demand','_supply'];

    private _ratio = ((_demand max 0.25) / (_supply max 0.25)) min 2 max 0.5;
    private _target = (_base * (1 + ((_ratio - 1) * 0.30))) max (_base * _floor) min (_base * _ceiling);
    private _smoothed = _current + ((_target - _current) * 0.35);
    private _noise = 0.99 + random 0.02;
    _entry set [1,((_smoothed * _noise) max (_base * _floor)) min (_base * _ceiling)];

    /* Decay short-term pressure so old activity does not permanently distort prices. */
    _entry set [2,1 + ((_demand - 1) * 0.85)];
    _entry set [3,1 + ((_supply - 1) * 0.85)];
    _prices set [_item,_entry];
} forEach keys _prices;

missionNamespace setVariable ['RHD_EconomyPrices',_prices,true];
