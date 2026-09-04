/*
    Authenticated server-side impound release by target vehicle.
    [caller,vehicle] call RHD_fnc_releaseImpoundByVehicle
    The server resolves the impound ID from its own registry.
*/
if (!isServer) exitWith {false};
params [['_caller',objNull,[objNull]],['_vehicle',objNull,[objNull]]];
if (isNull _caller || {!alive _caller}) exitWith {false};
if (isNull _vehicle || {!(_vehicle isKindOf 'LandVehicle')}) exitWith {false};
if (_caller distance _vehicle > 15) exitWith {false};
private _impounds = missionNamespace getVariable ['RHD_Impounds',createHashMap];
private _netId = netId _vehicle;
if (_netId isEqualTo '') exitWith {false};
private _foundId = '';
{
    private _entry = _impounds getOrDefault [_x,[]];
    if !(_entry isEqualTo [] || {count _entry < 8}) then {
        if ((_entry param [1,'']) isEqualTo _netId && {(_entry param [6,2]) isEqualTo 2}) exitWith {_foundId = _x;};
    };
} forEach keys _impounds;
if (_foundId isEqualTo '') exitWith {false};
[_caller,_foundId,_vehicle] call RHD_fnc_releaseImpound
