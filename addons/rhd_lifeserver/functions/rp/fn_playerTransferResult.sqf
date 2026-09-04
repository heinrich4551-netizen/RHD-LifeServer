/* Client-side result for an RHD player transfer. */
if (!hasInterface || {!isRemoteExecuted} || {remoteExecutedOwner != 2}) exitWith {false};
params [['_success',false,[true]],['_type',''],['_amount',0,[0]],['_account','CASH'],['_balance',0,[0]],['_otherUID','']];
if !(_account in ['CASH','BANK']) exitWith {false};
_balance = (_balance max 0) min 2000000000;
if (_success) then {
    if (_account isEqualTo 'BANK') then {life_atmbank = _balance;} else {life_cash = _balance;};
    if (_type isEqualTo 'TRANSFER_RECEIVED') then {
        hint format ['RHD MARKETPLACE\n\nReceived $%1 in %2.\nNew balance: $%3',_amount,_account,_balance];
    } else {
        hint format ['RHD MARKETPLACE\n\nSent $%1 from %2.\nNew balance: $%3',_amount,_account,_balance];
    };
} else {
    hint format ['RHD MARKETPLACE\n\nTransfer denied.\n%1',_otherUID];
};
true
