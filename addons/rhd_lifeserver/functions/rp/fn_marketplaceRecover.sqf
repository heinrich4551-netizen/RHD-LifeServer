/*
    Recover seller-side marketplace escrow after a reconnect.

    The upstream Framework virtual inventory is client-managed, so RHD cannot
    verify reserved inventory from the server. To prevent a persisted OPEN
    listing from becoming permanently stranded after a restart, the server
    sends a one-time recovery instruction to the seller and marks the listing
    RECOVERY_SENT. The client must acknowledge the inventory return.

    This path intentionally never refunds or credits money. It only returns
    inventory that was previously removed when the listing was created.
*/
if (!isServer || {!isRemoteExecuted}) exitWith {false};

private _owner = remoteExecutedOwner;
private _caller = allPlayers select {owner _x isEqualTo _owner} param [0,objNull];
if (isNull _caller || {!alive _caller}) exitWith {false};

private _uid = getPlayerUID _caller;
if (_uid isEqualTo '' || {count _uid != 17}) exitWith {false};

private _market = missionNamespace getVariable ['RHD_Marketplace',createHashMap];
private _sent = false;

{
    private _id = _x;
    private _e = _market getOrDefault [_id,[]];
    if !(_e isEqualTo []) then {
        private _sellerUID = _e param [1,''];
        private _status = _e param [5,'CLOSED'];
        if (_sellerUID isEqualTo _uid && {_status in ['OPEN','PENDING_CANCEL']}) then {
            _e set [5,'RECOVERY_SENT'];
            _e set [7,_owner];
            _market set [_id,_e];
            [_id,_e param [2,''],_e param [3,0],-2,''] remoteExecCall ['RHD_fnc_marketplaceResult',_owner];
            _sent = true;
        };
    };
} forEach keys _market;

if (_sent) then {
    missionNamespace setVariable ['RHD_Marketplace',_market,true];
};
true
