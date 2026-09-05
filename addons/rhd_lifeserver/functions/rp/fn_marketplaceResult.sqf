/* Client-side marketplace inventory bridge. */
if (!hasInterface || {!isRemoteExecuted} || {remoteExecutedOwner != 2}) exitWith {false};

params [['_id',''],['_value',''],['_amount',0],['_total',0],['_sellerUID','']];
if (_id isEqualTo '') exitWith {false};

/* -1 = normal cancellation/refund, -2 = reconnect/server-restart escrow recovery. */
if (_total in [-1,-2]) exitWith {
    private _item = _value;
    private _qty = _amount max 0;
    if (_item isEqualTo '' || {_qty < 1}) exitWith {false};
    private _returned = [true,_item,_qty] call life_fnc_handleInv;
    private _action = if (_total isEqualTo -2) then {'RECOVERY_ACK'} else {'CANCEL_ACK'};
    [_action,[_id,_returned]] remoteExecCall ['RHD_fnc_marketplace',2];
    if (_returned) then {
        hint format ['RHD MARKETPLACE\nReturned %1 x%2 from escrow.',_item,_qty];
    } else {
        hint 'RHD MARKETPLACE\nReserved items could not be restored. The server has kept the recovery record for review.';
    };
    true
};

/* Four arguments = listing request: remove the listed quantity, then ACK. */
if (_sellerUID isEqualTo '') then {
    private _item = _value;
    private _qty = _amount max 0;
    if (_item isEqualTo '' || {_qty < 1}) exitWith {false};
    private _removed = [false,_item,_qty] call life_fnc_handleInv;
    ['LIST_ACK',[_id,_removed]] remoteExecCall ['RHD_fnc_marketplace',2];
    if (_removed) then {
        hint format ['RHD MARKETPLACE\nListed %1 x%2. The items are reserved until sold or the listing is cancelled.',_item,_qty];
    } else {
        hint 'RHD MARKETPLACE\nYou do not have enough of that item to create the listing.';
    };
    true
} else {
    /* Five arguments = purchase request: add the purchased quantity, then ACK. */
    private _item = _value;
    private _qty = _amount max 0;
    if (_item isEqualTo '' || {_qty < 1}) exitWith {false};
    private _added = [true,_item,_qty] call life_fnc_handleInv;
    ['BUY_ACK',[_id,_added]] remoteExecCall ['RHD_fnc_marketplace',2];
    if (_added) then {
        hint format ['RHD MARKETPLACE\nReceived %1 x%2 for $%3.',_item,_qty,_total];
    } else {
        hint 'RHD MARKETPLACE\nInventory could not accept the purchased items. Payment will be returned.';
    };
    true
};
