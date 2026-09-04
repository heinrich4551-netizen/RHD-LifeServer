/*
    Server-authoritative RHD audit summary.
    [caller] call RHD_fnc_adminAudit
*/
if (!isServer || {!isRemoteExecuted}) exitWith {false};
params [['_caller',objNull,[objNull]]];
if (isNull _caller || {!alive _caller}) exitWith {false};
if !(['ADMIN',1] call RHD_fnc_authorizeRole) exitWith {false};

private _financial = missionNamespace getVariable ['RHD_FinancialLedger',[]];
private _recent = if (count _financial > 20) then {_financial select [count _financial - 20,20]} else {+_financial};
private _dispatch = count keys (missionNamespace getVariable ['RHD_DispatchCalls',createHashMap]);
private _businesses = count keys (missionNamespace getVariable ['RHD_Businesses',createHashMap]);
private _market = count keys (missionNamespace getVariable ['RHD_Marketplace',createHashMap]);
private _event = missionNamespace getVariable ['RHD_CurrentWorldEvent',['NONE',0]];
[['ADMIN_AUDIT',_dispatch,_businesses,_market,_event,_recent]] remoteExecCall ['RHD_fnc_rpResult',owner _caller];
true
