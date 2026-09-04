/*
    Server-side vehicle service / inspection registry.
    [caller,vehicle,serviceType,fee] call RHD_fnc_vehicleService

    serviceType: INSPECTION, REPAIR, OIL, TIRES, FULL
*/
if (!isServer) exitWith {false};
params [['_caller',objNull,[objNull]],['_vehicle',objNull,[objNull]],['_service','INSPECTION',['']],['_fee',0,[0]]];
if (isNull _caller || {!alive _caller}) exitWith {false};
if (isNull _vehicle || {!(_vehicle isKindOf 'LandVehicle')}) exitWith {false};
_service = toUpper _service;
if !(_service in ['INSPECTION','REPAIR','OIL','TIRES','FULL']) exitWith {false};
if (_caller distance _vehicle > 15) exitWith {false};

private _uid = getPlayerUID _caller;
if (_uid isEqualTo '') exitWith {false};
private _netId = netId _vehicle;
if (_netId isEqualTo '') exitWith {false};

private _services = missionNamespace getVariable ['RHD_VehicleServices',createHashMap];
private _charge = round ((_fee max 0) min 100000);
private _entry = [_netId,_uid,_service,_charge,diag_tickTime,getPosATL _vehicle,damage _vehicle];
_services set [_netId,_entry];
missionNamespace setVariable ['RHD_VehicleServices',_services,true];

if (_service in ['REPAIR','FULL']) then {_vehicle setDamage 0;};
[_netId,_service,_charge,damage _vehicle] remoteExecCall ['RHD_fnc_rpResult',owner _caller];
true
