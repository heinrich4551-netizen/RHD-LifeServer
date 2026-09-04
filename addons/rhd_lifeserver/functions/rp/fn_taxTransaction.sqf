/*
    Server-authoritative tax transaction.
    [player,taxType,taxableAmount,source] call RHD_fnc_taxTransaction
*/
if (!isServer) exitWith {false};
params [['_player',objNull,[objNull]],['_taxType','SALES'],['_taxableAmount',0,[0]],['_source','RHD transaction']];
if (isNull _player || {!alive _player}) exitWith {false};
_taxType = toUpper _taxType;
if !(_taxType in ['SALES','BUSINESS','INCOME']) exitWith {false};
_taxableAmount = round ((_taxableAmount max 0) min 100000000);
if (_taxableAmount <= 0) exitWith {true};
private _cfg = missionConfigFile >> 'RHD_RP' >> 'Taxes';
if (getNumber (_cfg >> 'enabled') <= 0) exitWith {true};
private _rate = switch (_taxType) do {
    case 'BUSINESS': {getNumber (_cfg >> 'businessRate')};
    case 'INCOME': {getNumber (_cfg >> 'incomeRate')};
    default {getNumber (_cfg >> 'salesRate')};
};
_rate = (_rate max 0) min 1;
private _tax = floor (_taxableAmount * _rate);
private _minimum = round ((getNumber (_cfg >> 'minimumCharge')) max 0);
if (_taxableAmount < getNumber (_cfg >> 'transactionMinimum')) exitWith {true};
if (_tax < _minimum) then {_tax = _minimum;};
if (_tax <= 0) exitWith {true};

/* Keep audit text SQL-safe without accepting arbitrary quote characters. */
private _sourceChars = toArray (_source select [0,128]);
_sourceChars = _sourceChars select {(_x in [32,45,46,47,58,95]) || {_x >= 48 && {_x <= 57}} || {_x >= 65 && {_x <= 90}} || {_x >= 97 && {_x <= 122}}};
_source = toString _sourceChars;
if (_source isEqualTo '') then {_source = 'RHD transaction';};

private _uid = getPlayerUID _player;
if (_uid isEqualTo '') exitWith {false};
private _ok = [_player,'CHARGE','CASH',_tax,format ['%1 tax',_taxType]] call RHD_fnc_financialTransaction;
if (!_ok) exitWith {false};
if !(isNil 'DB_fnc_asyncCall') then {
    [format ["INSERT INTO rhd_tax_transactions (uid,tax_type,taxable_amount,tax_amount,source) VALUES ('%1','%2','%3','%4','%5')",_uid,_taxType,_taxableAmount,_tax,_source],1] call DB_fnc_asyncCall;
    [format ["INSERT INTO rhd_government_ledger (transaction_type,uid,amount,description) VALUES ('TAX','%1','%2','%3')",_uid,_tax,format ['%1 tax',_taxType]],1] call DB_fnc_asyncCall;
};
private _gov = missionNamespace getVariable ['RHD_Government',createHashMap];
private _revenue = _gov getOrDefault ['taxRevenue',0];
_gov set ['taxRevenue',_revenue + _tax];
missionNamespace setVariable ['RHD_Government',_gov,true];
[['TAX_CHARGED',_taxType,_taxableAmount,_tax]] remoteExecCall ['RHD_fnc_rpResult',owner _player];
true
