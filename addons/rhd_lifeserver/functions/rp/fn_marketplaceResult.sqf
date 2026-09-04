/* Client-side marketplace purchase acknowledgement. */
if (!hasInterface || {!isRemoteExecuted} || {remoteExecutedOwner != 2}) exitWith {false};
params [['_listingId',''],['_item',''],['_amount',0],['_total',0],['_sellerUID','']];
if (_listingId isEqualTo '' || {_item isEqualTo ''} || {_amount < 1}) exitWith {false};
private _added = [true,_item,_amount] call life_fnc_handleInv;
[_listingId,_added] remoteExecCall ['RHD_fnc_marketplace',2];
if (_added) then {
    hint format ['RHD MARKETPLACE\nReceived %1 x%2 for $%3.',_item,_amount,_total];
} else {
    hint 'RHD MARKETPLACE\nInventory could not accept the purchased items. Payment will be returned.';
};
true
