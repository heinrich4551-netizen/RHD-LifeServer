/*
    Periodically persist RHD registries. Upstream player/banking persistence is
    intentionally left to the Framework's existing database layer.
*/
if (!isServer) exitWith {false};
if !(missionNamespace getVariable ['RHD_PersistenceEnabled',false]) exitWith {false};

private _states = [
    ['economy','RHD_EconomyPrices'],
    ['dispatch','RHD_DispatchCalls'],
    ['evidence','RHD_Evidence'],
    ['warrants','RHD_Warrants'],
    ['impounds','RHD_Impounds'],
    ['licenses','RHD_Licenses'],
    ['businesses','RHD_Businesses'],
    ['services','RHD_ServiceRequests'],
    ['hospitalBills','RHD_HospitalBills'],
    ['government','RHD_Government'],
    ['contracts','RHD_ActiveContracts']
];

{
    _x params ['_key','_variable'];
    private _value = missionNamespace getVariable [_variable,createHashMap];
    [_key,_value] call RHD_fnc_saveState;
} forEach _states;

missionNamespace setVariable ['RHD_LastPersistenceSave',diag_tickTime,true];
true
