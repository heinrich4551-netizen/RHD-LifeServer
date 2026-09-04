/* Server-authoritative player business registration. */
if (!isServer) exitWith {false};
params [['_caller',objNull,[objNull]],['_businessType','GENERAL'],['_name',''],['_position',[0,0,0]]];
if (isNull _caller || {!alive _caller}) exitWith {false};
private _uid = getPlayerUID _caller;
if (_uid isEqualTo '' || {count _uid != 17}) exitWith {false};
private _safeUID = _uid select {(_x >= '0') && (_x <= '9')};
if (_safeUID != _uid) exitWith {false};
private _chars = toArray (_name select [0,64]);
_chars = _chars select {(_x in [32,45,46]) || {_x >= 48 && {_x <= 57}} || {_x >= 65 && {_x <= 90}} || {_x >= 97 && {_x <= 122}}};
_name = toString _chars;
if (_name isEqualTo '') exitWith {false};
_businessType = toUpper _businessType;
if !(_businessType in ['GENERAL','FARMING','MINING','MECHANIC','TAXI','MEDICAL','RETAIL']) then {_businessType = 'GENERAL';};
private _businesses = missionNamespace getVariable ['RHD_Businesses',createHashMap];
private _owned = keys _businesses select {private _b=_businesses getOrDefault [_x,[]]; !(_b isEqualTo []) && {(_b param [1,'']) isEqualTo _uid}};
if (count _owned >= 3) exitWith {false};

private _feeCfg = missionConfigFile >> 'RHD_RP' >> 'Fees' >> 'businessStartup';
private _startupFee = round ((getNumber _feeCfg) max 0);
private _feePaid = true;
if (_startupFee > 0) then {
    _feePaid = [_caller,'CHARGE','CASH',_startupFee,'Business startup fee'] call RHD_fnc_financialTransaction;
};
if (!_feePaid) exitWith {
    [['BUSINESS_CREATE_DENIED',_name,_startupFee]] remoteExecCall ['RHD_fnc_rpResult',owner _caller];
    false
};

private _id = format ['B-%1-%2',_uid,floor (diag_tickTime * 10)];
private _safePos = getPosATL _caller;
_businesses set [_id,[_id,_uid,_name,_safePos,[],diag_tickTime]];
missionNamespace setVariable ['RHD_Businesses',_businesses,true];

private _dbCreated = true;
if !(isNil 'DB_fnc_asyncCall') then {
    [format ["INSERT INTO rhd_business_accounts (business_key,owner_uid,business_name,balance,active) VALUES ('%1','%2','%3','0','1')",_id,_uid,_name],1] call DB_fnc_asyncCall;
} else {
    _dbCreated = false;
};

if (!_dbCreated) then {
    _businesses deleteAt _id;
    missionNamespace setVariable ['RHD_Businesses',_businesses,true];
    if (_startupFee > 0) then {[_caller,'REWARD','CASH',_startupFee,'Business startup refund'] call RHD_fnc_financialTransaction;};
    [['BUSINESS_CREATE_DENIED',_name,_startupFee]] remoteExecCall ['RHD_fnc_rpResult',owner _caller];
    false
} else {
    [['BUSINESS_CREATED',_id,_name,_businessType,_startupFee]] remoteExecCall ['RHD_fnc_rpResult',owner _caller];
    true
};
