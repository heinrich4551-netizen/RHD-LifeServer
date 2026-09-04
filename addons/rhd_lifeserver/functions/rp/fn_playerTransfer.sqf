/*
    Server-authoritative player-to-player transfer.
    [caller,target,amount,account] call RHD_fnc_playerTransfer
    account: CASH or BANK
    Both balances are read from the Framework database; client balances are never trusted.
*/
if (!isServer) exitWith {false};
params [['_caller',objNull,[objNull]],['_target',objNull,[objNull]],['_amount',0,[0]],['_account','CASH']];
if (isNull _caller || {!alive _caller} || {isNull _target} || {!alive _target}) exitWith {false};
if (_caller isEqualTo _target) exitWith {false};
_account = toUpper _account;
if !(_account in ['CASH','BANK']) exitWith {false};
_amount = round ((_amount max 1) min 100000000);
private _senderUID = getPlayerUID _caller;
private _receiverUID = getPlayerUID _target;
if (_senderUID isEqualTo '' || {_receiverUID isEqualTo ''} || {count _senderUID != 17} || {count _receiverUID != 17}) exitWith {false};
private _safeSender = _senderUID select {(_x >= '0') && (_x <= '9')};
private _safeReceiver = _receiverUID select {(_x >= '0') && (_x <= '9')};
if (_safeSender != _senderUID || {_safeReceiver != _receiverUID}) exitWith {false};
if (isNil 'DB_fnc_asyncCall') exitWith {false};

private _locks = missionNamespace getVariable ['RHD_TransferLocks',createHashMap];
if (_locks getOrDefault [_senderUID,false]) exitWith {false};
_locks set [_senderUID,true];
missionNamespace setVariable ['RHD_TransferLocks',_locks];
private _ok = false;
private _senderBefore = 0;
private _receiverBefore = 0;
private _senderAfter = 0;
private _receiverAfter = 0;
private _column = if (_account isEqualTo 'BANK') then {'bankacc'} else {'cash'};
private _senderResult = [format ["SELECT %1 FROM players WHERE pid='%2' LIMIT 1",_column,_senderUID],2] call DB_fnc_asyncCall;
private _receiverResult = [format ["SELECT %1 FROM players WHERE pid='%2' LIMIT 1",_column,_receiverUID],2] call DB_fnc_asyncCall;
if (_senderResult isEqualType [] && {count _senderResult > 0} && {_receiverResult isEqualType []} && {count _receiverResult > 0}) then {
    _senderBefore = _senderResult param [0,0];
    _receiverBefore = _receiverResult param [0,0];
    if (_senderBefore isEqualType '') then {_senderBefore = parseNumber _senderBefore;};
    if (_receiverBefore isEqualType '') then {_receiverBefore = parseNumber _receiverBefore;};
    _senderBefore = (_senderBefore max 0) min 2000000000;
    _receiverBefore = (_receiverBefore max 0) min 2000000000;
    if (_senderBefore >= _amount && {(_receiverBefore + _amount) <= 2000000000}) then {
        _senderAfter = _senderBefore - _amount;
        _receiverAfter = _receiverBefore + _amount;
        [format ["UPDATE players SET %1='%2' WHERE pid='%3'",_column,_senderAfter,_senderUID],1] call DB_fnc_asyncCall;
        [format ["UPDATE players SET %1='%2' WHERE pid='%3'",_column,_receiverAfter,_receiverUID],1] call DB_fnc_asyncCall;
        _ok = true;
    };
};

if (_ok) then {
    [format ["INSERT INTO rhd_player_transfers (sender_uid,receiver_uid,account_type,amount,sender_before,sender_after,receiver_before,receiver_after) VALUES ('%1','%2','%3','%4','%5','%6','%7','%8')",_senderUID,_receiverUID,_account,_amount,_senderBefore,_senderAfter,_receiverBefore,_receiverAfter],1] call DB_fnc_asyncCall;
    [true,'TRANSFER_SENT',_amount,_account,_senderAfter,_receiverUID] remoteExecCall ['RHD_fnc_financialResult',owner _caller];
    [true,'TRANSFER_RECEIVED',_amount,_account,_receiverAfter,_senderUID] remoteExecCall ['RHD_fnc_financialResult',owner _target];
} else {
    [false,'TRANSFER_DENIED',_amount,_account,_senderBefore,'Insufficient funds or transfer unavailable'] remoteExecCall ['RHD_fnc_financialResult',owner _caller];
};
_locks = missionNamespace getVariable ['RHD_TransferLocks',createHashMap];
_locks deleteAt _senderUID;
missionNamespace setVariable ['RHD_TransferLocks',_locks];
_ok
