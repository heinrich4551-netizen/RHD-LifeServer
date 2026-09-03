/* RHD RP state bootstrap. Server authoritative; persistence adapter can consume these registries. */
if (!isServer) exitWith {};
missionNamespace setVariable ['RHD_DispatchCalls',createHashMap,true];
missionNamespace setVariable ['RHD_Evidence',createHashMap,true];
missionNamespace setVariable ['RHD_Warrants',createHashMap,true];
missionNamespace setVariable ['RHD_Impounds',createHashMap,true];
missionNamespace setVariable ['RHD_Licenses',createHashMap,true];
missionNamespace setVariable ['RHD_Businesses',createHashMap,true];
missionNamespace setVariable ['RHD_ServiceRequests',createHashMap,true];
missionNamespace setVariable ['RHD_HospitalBills',createHashMap,true];
missionNamespace setVariable ['RHD_Government',createHashMap,true];
['RHD RP registries initialized.'] call RHD_fnc_log;
true
