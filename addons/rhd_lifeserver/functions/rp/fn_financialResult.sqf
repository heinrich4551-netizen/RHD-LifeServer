/*
    Client-side financial synchronization bridge.
    Only the dedicated server may invoke this function.
*/
if (!hasInterface || {!isRemoteExecuted} || {remoteExecutedOwner != 2}) exitWith {false};
params [['_success',false,[true]],['_mode',''],['_account','CASH'],['_amount',0,[0]],['_balance',0,[0]],['_reason','']];
if !(_account in ['CASH','BANK']) exitWith {false};
_balance = (_balance max 0) min 2000000000;

if (_success) then {
    if (_account isEqualTo 'BANK') then {
        life_atmbank = _balance;
    } else {
        life_cash = _balance;
    };
    private _action = if (_mode isEqualTo 'CHARGE') then {'charged'} else {'credited'};
    hint format ['RHD FINANCE\n\n$%1 %2 from %3.\nBalance: $%4',_amount,_action,_account,_balance];
} else {
    hint format ['RHD FINANCE\n\nTransaction denied.\n%1\nCurrent %2 balance: $%3',_reason,_account,_balance];
};
true
