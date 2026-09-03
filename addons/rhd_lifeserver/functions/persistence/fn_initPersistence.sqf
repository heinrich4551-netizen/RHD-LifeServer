/*
    Restore RHD server registries from the persistent state table.
    The upstream Framework remains responsible for player/banking persistence.
*/
if (!isServer) exitWith {false};

private _cfg = missionConfigFile >> 'RHD_LifeServer' >> 'Persistence';
if (isClass _cfg && {getNumber (_cfg >> 'enabled') isEqualTo 0}) exitWith {
    missionNamespace setVariable ['RHD_PersistenceEnabled',false,true];
    true
};

waitUntil {time > 0 && {!isNil 'DB_fnc_asyncCall'}};
missionNamespace setVariable ['RHD_PersistenceEnabled',true,true];

private _stateMap = [
    ['economy', 'RHD_EconomyPrices', createHashMap],
    ['dispatch', 'RHD_DispatchCalls', createHashMap],
    ['evidence', 'RHD_Evidence', createHashMap],
    ['warrants', 'RHD_Warrants', createHashMap],
    ['impounds', 'RHD_Impounds', createHashMap],
    ['licenses', 'RHD_Licenses', createHashMap],
    ['businesses', 'RHD_Businesses', createHashMap],
    ['services', 'RHD_ServiceRequests', createHashMap],
    ['hospitalBills', 'RHD_HospitalBills', createHashMap],
    ['government', 'RHD_Government', createHashMap]
];

{
    _x params ['_key','_variable','_default'];
    private _value = [_key,_default] call RHD_fnc_loadState;
    if (!isNil '_value') then {
        missionNamespace setVariable [_variable,_value,true];
    };
} forEach _stateMap;

['RHD persistent state restored.'] call RHD_fnc_log;
true
