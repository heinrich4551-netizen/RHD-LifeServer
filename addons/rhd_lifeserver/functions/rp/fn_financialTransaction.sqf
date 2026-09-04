/*
    RHD server-side Framework cash/bank transaction adapter.

    [player,mode,account,amount,reason] call RHD_fnc_financialTransaction
    mode: CHARGE or REWARD
    account: CASH or BANK

    The server reads the persisted Framework balance, calculates the new
    balance, writes it through the Framework DB adapter, and then synchronizes
    the selected account back to the online client. No client-reported balance
    or payment amount is trusted.
*/
if (!isServer) exitWith {false};
params [['_player',objNull,[objNull]],['_mode',''],['_account','CASH'],['_amount',0,[0]],['_reason','RHD transaction']];
if (isNull _player || {!alive _player}) exitWith {false};
_mode = toUpper _mode;
_account = toUpper _account;
if !(_mode in ['CHARGE','REWARD']) exitWith {false};
if !(_account in ['CASH','BANK']) exitWith {false};
_amount = round ((_amount max 0) min 100000000);
if (_amount <= 0) exitWith {true};
if (isNil 'DB_fnc_asyncCall') exitWith {false};

private _uid = getPlayerUID _player;
if (_uid isEqualTo '' || {count _uid != 17}) exitWith {false};
private _safeUID = _uid select {(_x >= '0') && (_x <= '9')};
if (_safeUID != _uid) exitWith {false};

private _locks = missionNamespace getVariable ['RHD_FinancialLocks',createHashMap];
if (_locks getOrDefault [_uid,false]) exitWith {false};
_locks set [_uid,true];
missionNamespace setVariable ['RHD_FinancialLocks',_locks];

private _ok = false;
private _newBalance = 0;
private _oldBalance = 0;

private _result = [format ["SELECT cash, bankacc FROM players WHERE pid='%1' LIMIT 1",_uid],2] call DB_fnc_asyncCall;
if (_result isEqualType [] && {count _result >= 2}) then {
    private _cash = _result param [0,0];
    private _bank = _result param [1,0];
    _cash = if (_cash isEqualType '') then {parseNumber _cash} else {_cash};
    _bank = if (_bank isEqualType '') then {parseNumber _bank} else {_bank};
    _cash = (_cash max 0) min 2000000000;
    _bank = (_bank max 0) min 2000000000;
    _oldBalance = if (_account isEqualTo 'BANK') then {_bank} else {_cash};

    if (_mode isEqualTo 'CHARGE') then {
        if (_oldBalance >= _amount) then {_newBalance = _oldBalance - _amount; _ok = true;};
    } else {
        _newBalance = (_oldBalance + _amount) min 2000000000;
        _ok = true;
    };

    if (_ok) then {
        private _query = if (_account isEqualTo 'BANK') then {
            format ["UPDATE players SET bankacc='%1' WHERE pid='%2'",_newBalance,_uid]
        } else {
            format ["UPDATE players SET cash='%1' WHERE pid='%2'",_newBalance,_uid]
        };
        [_query,1] call DB_fnc_asyncCall;

        private _audit = missionNamespace getVariable ['RHD_FinancialLedger',[]];
        _audit pushBack [diag_tickTime,_uid,_mode,_account,_amount,_oldBalance,_newBalance,_reason select [0,128]];
        if (count _audit > 5000) then {_audit deleteRange [0,count _audit - 5000];};
        missionNamespace setVariable ['RHD_FinancialLedger',_audit];

        [true,_mode,_account,_amount,_newBalance,_reason select [0,128]] remoteExecCall ['RHD_fnc_financialResult',owner _player];
    } else {
        [false,_mode,_account,_amount,_oldBalance,'Insufficient funds'] remoteExecCall ['RHD_fnc_financialResult',owner _player];
    };
};

_locks = missionNamespace getVariable ['RHD_FinancialLocks',createHashMap];
_locks deleteAt _uid;
missionNamespace setVariable ['RHD_FinancialLocks',_locks];
_ok
