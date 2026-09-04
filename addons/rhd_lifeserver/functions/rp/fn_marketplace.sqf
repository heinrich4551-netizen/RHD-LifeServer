/* Server-authoritative marketplace registry.
   [caller,action,args] call RHD_fnc_marketplace
   Actions: LIST, VIEW, CANCEL. LIST creates an offer; VIEW returns active offers.
   Item ownership remains governed by the upstream client inventory API; listings are
   therefore reservations and must be finalized by a future inventory acknowledgement.
*/
if (!isServer || {!isRemoteExecuted}) exitWith {false};
params [['_caller',objNull,[objNull]],['_action',''],['_args',[],[[]]]];
if (isNull _caller || {!alive _caller}) exitWith {false};
_action = toUpper _action;
private _uid = getPlayerUID _caller;
if (_uid isEqualTo '') exitWith {false};
private _market = missionNamespace getVariable ['RHD_Marketplace',createHashMap];
switch (_action) do {
    case 'LIST': {
        private _item = _args param [0,''];
        private _amount = round (_args param [1,0]);
        private _unitPrice = round (_args param [2,0]);
        if (_item isEqualTo '' || {_amount < 1 || {_amount > 1000} || {_unitPrice < 1 || _unitPrice > 100000000}) exitWith {false};
        private _prices = missionNamespace getVariable ['RHD_EconomyPrices',createHashMap];
        if (_prices getOrDefault [_item,[]] isEqualTo []) exitWith {false};
        private _id = format ['M-%1-%2',floor (diag_tickTime * 10),floor random 10000];
        _market set [_id,[_id,_uid,_item,_amount,_unitPrice,'OPEN',diag_tickTime]];
        missionNamespace setVariable ['RHD_Marketplace',_market,true];
        [['MARKET_LISTED',_id,_item,_amount,_unitPrice]] remoteExecCall ['RHD_fnc_rpResult',owner _caller];
        true
    };
    case 'VIEW': {
        private _rows = [];
        {private _e=_market getOrDefault [_x,[]]; if (!(_e isEqualTo []) && {(_e param [5,'CLOSED']) isEqualTo 'OPEN'}) then {_rows pushBack [_e param [0,''],_e param [1,''],_e param [2,''],_e param [3,0],_e param [4,0]];};} forEach keys _market;
        [_rows] remoteExecCall ['RHD_fnc_rpResult',owner _caller];
        true
    };
    case 'CANCEL': {
        private _id = _args param [0,''];
        private _e = _market getOrDefault [_id,[]];
        if (_e isEqualTo [] || {(_e param [1,'']) isNotEqualTo _uid} || {(_e param [5,'']) isNotEqualTo 'OPEN'}) exitWith {false};
        _e set [5,'CANCELLED'];
        _market set [_id,_e];
        missionNamespace setVariable ['RHD_Marketplace',_market,true];
        [['MARKET_CANCELLED',_id]] remoteExecCall ['RHD_fnc_rpResult',owner _caller];
        true
    };
    default {false};
};
