/* RHD RP state bootstrap. Server authoritative; persistence adapter can consume these registries. */
if (!isServer) exitWith {};

private _registries = [
    'RHD_DispatchCalls',
    'RHD_Evidence',
    'RHD_Warrants',
    'RHD_Impounds',
    'RHD_Licenses',
    'RHD_Businesses',
    'RHD_ServiceRequests',
    'RHD_HospitalBills',
    'RHD_Government',
    'RHD_CourtCases',
    'RHD_PhoneRegistry',
    'RHD_Marketplace'
];
{
    if (isNil {missionNamespace getVariable _x}) then {
        missionNamespace setVariable [_x,createHashMap,true];
    };
} forEach _registries;

['RHD RP registries initialized.'] call RHD_fnc_log;
true
