/*
    Server-authoritative marketplace.
    Inventory remains managed by the upstream client API, so every listing and
    purchase crosses an explicit inventory acknowledgement boundary before the
    server settles money. This prevents the old direct-payment/listing path.
*/
if (!isServer || {!isRemoteExecuted}) exitWith {false};
params [['_action',''],['_args',[],[[]]]];
private _caller = allPlayers select {owner _x isEqualTo remoteExecutedOwner} param [0,objNull];
if (isNull _caller || {!alive _caller}) exitWith {false};
_action = toUpper _action;
private _uid = getPlayerUID _caller;
if (_uid isEqualTo '' || {count _uid != 17}) exitWith {false};
private _market = missionNamespace getVariable ['RHD_Marketplace',createHashMap];

switch (_action) do {
    case 'LIST': {
        private _item = _args param [0,''];
        private _amount = round (_args param [1,0]);
        private _unitPrice = round (_args param [2,0]);
        if (_item isEqualTo '' || {_amount < 1 || _amount > 1000} || {_unitPrice < 1 || _unitPrice > 100000000}) exitWith {false};
        private _prices = missionNamespace getVariable ['RHD_EconomyPrices',createHashMap];
        if (_prices getOrDefault [_item,[]] isEqualTo []) exitWith {false};
        private _id = format ['M-%1-%2',floor (diag_tickTime * 10),floor random 10000];
        _market set [_id,[_id,_uid,_item,_amount,_unitPrice,'PENDING_LIST',diag_tickTime,0]];
        missionNamespace setVariable ['RHD_Marketplace',_market,true];
        [_id,_item,_amount,_unitPrice] remoteExecCall ['RHD_fnc_marketplaceResult',owner _caller];
        true
    };
    case 'LIST_ACK': {
        private _id = _args param [0,''];
        private _removed = _args param [1,false];
        private _e = _market getOrDefault [_id,[]];
        if (_e isEqualTo [] || {(_e param [1,'']) isNotEqualTo _uid} || {(_e param [5,'']) isNotEqualTo 'PENDING_LIST'}) exitWith {false};
        if (!_removed) then {
            _e set [5,'CANCELLED'];
            _market set [_id,_e];
            missionNamespace setVariable ['RHD_Marketplace',_market,true];
            [['MARKET_LIST_FAILED',_id]] remoteExecCall ['RHD_fnc_rpResult',owner _caller];
            false
        } else {
            _e set [5,'OPEN'];
            _market set [_id,_e];
            missionNamespace setVariable ['RHD_Marketplace',_market,true];
            [['MARKET_LISTED',_id,_e param [2,''],_e param [3,0],_e param [4,0]]] remoteExecCall ['RHD_fnc_rpResult',owner _caller];
            true
        };
    };
    case 'VIEW': {
        private _rows = [];
        {
            private _e = _market getOrDefault [_x,[]];
            if (!(_e isEqualTo []) && {(_e param [5,'CLOSED']) isEqualTo 'OPEN'}) then {
                _rows pushBack [_e param [0,''],_e param [1,''],_e param [2,''],_e param [3,0],_e param [4,0]];
            };
        } forEach keys _market;
        [_rows] remoteExecCall ['RHD_fnc_rpResult',owner _caller];
        true
    };
    case 'BUY': {
        private _id = _args param [0,''];
        private _e = _market getOrDefault [_id,[]];
        if (_e isEqualTo [] || {(_e param [5,'']) isNotEqualTo 'OPEN'}) exitWith {false};
        private _sellerUID = _e param [1,''];
        if (_sellerUID isEqualTo _uid) exitWith {false};
        private _item = _e param [2,''];
        private _amount = _e param [3,0];
        private _unitPrice = _e param [4,0];
        private _total = round (_amount * _unitPrice);
        if (_item isEqualTo '' || {_amount < 1} || {_unitPrice < 1} || {_total < 1}) exitWith {false};

        private _buyerPaid = [_caller,'CHARGE','CASH',_total,format ['Marketplace purchase %1',_id]] call RHD_fnc_financialTransaction;
        if (!_buyerPaid) exitWith {
            [['MARKET_BUY_FAILED',_id,'Insufficient funds']] remoteExecCall ['RHD_fnc_rpResult',owner _caller];
            false
        };

        _e set [5,'PENDING_BUY'];
        _e set [7,remoteExecutedOwner];
        _market set [_id,_e];
        missionNamespace setVariable ['RHD_Marketplace',_market,true];
        [_id,_item,_amount,_total,_sellerUID] remoteExecCall ['RHD_fnc_marketplaceResult',owner _caller];
        true
    };
    case 'BUY_ACK': {
        private _id = _args param [0,''];
        private _added = _args param [1,false];
        private _e = _market getOrDefault [_id,[]];
        if (_e isEqualTo [] || {(_e param [5,'']) isNotEqualTo 'PENDING_BUY'}) exitWith {false};
        private _buyerOwner = _e param [7,-1];
        if (_buyerOwner isNotEqualTo remoteExecutedOwner) exitWith {false};
        private _item = _e param [2,''];
        private _amount = _e param [3,0];
        private _unitPrice = _e param [4,0];
        private _total = round (_amount * _unitPrice);
        private _sellerUID = _e param [1,''];
        private _seller = allPlayers select {getPlayerUID _x isEqualTo _sellerUID} param [0,objNull];

        if (!_added) then {
            [_caller,'REWARD','CASH',_total,format ['Marketplace refund %1',_id]] call RHD_fnc_financialTransaction;
            _e set [5,'CANCELLED'];
            _market set [_id,_e];
            missionNamespace setVariable ['RHD_Marketplace',_market,true];
            [['MARKET_BUY_FAILED',_id,'Inventory could not accept the items; payment refunded.']] remoteExecCall ['RHD_fnc_rpResult',owner _caller];
            true
        } else {
            if (isNull _seller || {!alive _seller}) exitWith {
                [_caller,'REWARD','CASH',_total,format ['Marketplace seller-unavailable refund %1',_id]] call RHD_fnc_financialTransaction;
                _e set [5,'CANCELLED'];
                _market set [_id,_e];
                missionNamespace setVariable ['RHD_Marketplace',_market,true];
                [['MARKET_BUY_FAILED',_id,'Seller is offline; payment refunded.']] remoteExecCall ['RHD_fnc_rpResult',owner _caller];
                true
            };
            private _sellerPaid = [_seller,'REWARD','CASH',_total,format ['Marketplace sale %1',_id]] call RHD_fnc_financialTransaction;
            if (!_sellerPaid) then {
                [_caller,'REWARD','CASH',_total,format ['Marketplace settlement refund %1',_id]] call RHD_fnc_financialTransaction;
                _e set [5,'CANCELLED'];
                _market set [_id,_e];
                missionNamespace setVariable ['RHD_Marketplace',_market,true];
                [['MARKET_BUY_FAILED',_id,'Seller account could not be credited; payment refunded.']] remoteExecCall ['RHD_fnc_rpResult',owner _caller];
                true
            } else {
                _e set [5,'CLOSED'];
                _market set [_id,_e];
                missionNamespace setVariable ['RHD_Marketplace',_market,true];
                [_item,_amount,0] call RHD_fnc_recordMarket;
                [_item,0,_amount] call RHD_fnc_recordMarket;
                [['MARKET_COMPLETE',_id,_item,_amount,_total]] remoteExecCall ['RHD_fnc_rpResult',owner _caller];
                [['MARKET_SOLD',_id,_item,_amount,_total]] remoteExecCall ['RHD_fnc_rpResult',owner _seller];
                true
            };
        };
    };
    case 'CANCEL': {
        private _id = _args param [0,''];
        private _e = _market getOrDefault [_id,[]];
        if (_e isEqualTo [] || {(_e param [1,'']) isNotEqualTo _uid} || {(_e param [5,'']) isNotEqualTo 'OPEN'}) exitWith {false};
        _e set [5,'PENDING_CANCEL'];
        _e set [7,remoteExecutedOwner];
        _market set [_id,_e];
        missionNamespace setVariable ['RHD_Marketplace',_market,true];
        [_id,_e param [2,''],_e param [3,0],-1,''] remoteExecCall ['RHD_fnc_marketplaceResult',owner _caller];
        true
    };
    case 'CANCEL_ACK': {
        private _id = _args param [0,''];
        private _returned = _args param [1,false];
        private _e = _market getOrDefault [_id,[]];
        if (_e isEqualTo [] || {(_e param [5,'']) isNotEqualTo 'PENDING_CANCEL'} || {(_e param [1,'']) isNotEqualTo _uid}) exitWith {false};
        if (_e param [7,-1] isNotEqualTo remoteExecutedOwner) exitWith {false};
        if (_returned) then {
            _e set [5,'CANCELLED'];
            [['MARKET_CANCELLED',_id]] remoteExecCall ['RHD_fnc_rpResult',owner _caller];
        } else {
            _e set [5,'OPEN'];
            [['MARKET_CANCEL_FAILED',_id,'The reserved items could not be returned.']] remoteExecCall ['RHD_fnc_rpResult',owner _caller];
        };
        _market set [_id,_e];
        missionNamespace setVariable ['RHD_Marketplace',_market,true];
        true
    };
    default {false};
};
