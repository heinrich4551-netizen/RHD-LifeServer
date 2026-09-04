/*
    Server-side player business account transaction.
    [caller,businessId,mode,amount] call RHD_fnc_businessTransaction
    mode: DEPOSIT or WITHDRAW
    The business owner is resolved from the server registry; client-supplied owner
    information and account balances are never trusted.
*/
if (!isServer) exitWith {false};
params [['_caller',objNull,[objNull]],['_businessId',''],['_mode',''],['_amount',0,[0]]];
if (isNull _caller || {!alive _caller}) exitWith {false};
if (_businessId isEqualTo '') exitWith {false};
_mode = toUpper _mode;
if !(_mode in ['DEPOSIT','WITHDRAW']) exitWith {false};
_amount = round ((_amount max 1) min 100000000);

private _uid = getPlayerUID _caller;
if (_uid isEqualTo '' || {count _uid != 17}) exitWith {false};
private _safeUID = _uid select {(_x >= '0') && (_x <= '9')};
if (_safeUID != _uid) exitWith {false};

private _businesses = missionNamespace getVariable ['RHD_Businesses',createHashMap];
private _business = _businesses getOrDefault [_businessId,[]];
if (_business isEqualTo [] || {count _business < 3}) exitWith {false};
if ((_business param [1,'']) isNotEqualTo _uid) exitWith {false};
if (isNil 'DB_fnc_asyncCall') exitWith {false};

private _locks = missionNamespace getVariable ['RHD_BusinessLocks',createHashMap];
if (_locks getOrDefault [_businessId,false]) exitWith {false};
_locks set [_businessId,true];
missionNamespace setVariable ['RHD_BusinessLocks',_locks];

private _ok = false;
private _balance = 0;
private _before = 0;
private _result = [format ["SELECT balance FROM rhd_business_accounts WHERE business_key='%1' AND owner_uid='%2' LIMIT 1",_businessId,_uid],2] call DB_fnc_asyncCall;
if (_result isEqualType [] && {count _result > 0}) then {
    _balance = _result param [0,0];
    if (_balance isEqualType '') then {_balance = parseNumber _balance;};
    _balance = (_balance max 0) min 2000000000;
    _before = _balance;
    if (_mode isEqualTo 'DEPOSIT') then {
        private _cash = [format ["SELECT cash FROM players WHERE pid='%1' LIMIT 1",_uid],2] call DB_fnc_asyncCall;
        private _available = if (_cash isEqualType [] && {count _cash > 0}) then {_cash param [0,0]} else {0};
        if (_available isEqualType '') then {_available = parseNumber _available;};
        if (_available >= _amount) then {
            private _newCash = _available - _amount;
            private _newBusiness = (_balance + _amount) min 2000000000;
            [format ["UPDATE players SET cash='%1' WHERE pid='%2'",_newCash,_uid],1] call DB_fnc_asyncCall;
            [format ["UPDATE rhd_business_accounts SET balance='%1' WHERE business_key='%2' AND owner_uid='%3'",_newBusiness,_businessId,_uid],1] call DB_fnc_asyncCall;
            _balance = _newBusiness;
            _ok = true;
        };
    } else {
        if (_balance >= _amount) then {
            private _cashResult = [format ["SELECT cash FROM players WHERE pid='%1' LIMIT 1",_uid],2] call DB_fnc_asyncCall;
            private _cash = if (_cashResult isEqualType [] && {count _cashResult > 0}) then {_cashResult param [0,0]} else {0};
            if (_cash isEqualType '') then {_cash = parseNumber _cash;};
            private _newBusiness = _balance - _amount;
            private _newCash = ((_cash max 0) + _amount) min 2000000000;
            [format ["UPDATE rhd_business_accounts SET balance='%1' WHERE business_key='%2' AND owner_uid='%3'",_newBusiness,_businessId,_uid],1] call DB_fnc_asyncCall;
            [format ["UPDATE players SET cash='%1' WHERE pid='%2'",_newCash,_uid],1] call DB_fnc_asyncCall;
            _balance = _newBusiness;
            _ok = true;
        };
    };
};

if (_ok) then {
    [format ["INSERT INTO rhd_business_transactions (business_key,owner_uid,transaction_mode,amount,balance_before,balance_after) VALUES ('%1','%2','%3','%4','%5','%6')",_businessId,_uid,_mode,_amount,_before,_balance],1] call DB_fnc_asyncCall;
    [['BUSINESS_TRANSACTION',_businessId,_mode,_amount,_balance]] remoteExecCall ['RHD_fnc_rpResult',owner _caller];
} else {
    [['BUSINESS_TRANSACTION_DENIED',_businessId,_mode,_amount,_balance]] remoteExecCall ['RHD_fnc_rpResult',owner _caller];
};

_locks = missionNamespace getVariable ['RHD_BusinessLocks',createHashMap];
_locks deleteAt _businessId;
missionNamespace setVariable ['RHD_BusinessLocks',_locks];
_ok
