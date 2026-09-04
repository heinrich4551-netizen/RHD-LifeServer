/*
    Authenticated server-side impound registration.
    [caller,vehicle,reason] call RHD_fnc_impoundVehicle
*/
if (!isServer) exitWith {false};
params [['_caller',objNull,[objNull]],['_vehicle',objNull,[objNull]],['_reason','']];
if (isNull _caller || {!alive _caller}) exitWith {false};
if (isNull _vehicle || {!(_vehicle isKindOf 'LandVehicle')}) exitWith {false};
if (_reason isEqualTo '') exitWith {false};
if (_caller distance _vehicle > 15) exitWith {false};
private _executorUID = getPlayerUID _caller;
if (_executorUID isEqualTo '') exitWith {false};
private _netId = netId _vehicle;
if (_netId isEqualTo '') exitWith {false};
_reason = _reason select [0,256];
private _feeSafe = round (getNumber (missionConfigFile >> 'RHD_RP' >> 'Fees' >> 'impoundRelease'));
_feeSafe = (_feeSafe max 0) min 1000000;
private _owners = _vehicle getVariable ['vehicle_info_owners',[]];
private _impounds = missionNamespace getVariable ['RHD_Impounds',createHashMap];
private _existing = false;
{
    private _e = _impounds getOrDefault [_x,[]];
    if !(_e isEqualTo [] || {count _e < 8}) then {
        if ((_e param [1,'']) isEqualTo _netId && {(_e param [6,2]) in [1,2]}) exitWith {_existing = true;};
    };
} forEach keys _impounds;
if (_existing) exitWith {false};
private _id = format ['I-%1-%2',floor diag_tickTime,floor random 10000];
_impounds set [_id,[_id,_netId,_owners,_reason,_feeSafe,diag_tickTime,2,_executorUID]];
_vehicle setVariable ['RHD_Impounded',true,true];
missionNamespace setVariable ['RHD_Impounds',_impounds,true];
[['IMPOUNDED',_id,_netId,_feeSafe]] remoteExecCall ['RHD_fnc_rpResult',owner _caller];
true
