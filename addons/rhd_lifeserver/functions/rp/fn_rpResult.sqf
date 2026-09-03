/*
    Client-side RP result bridge.
    Server-originated only.
*/
if (!hasInterface || {!isRemoteExecuted} || {remoteExecutedOwner != 2}) exitWith {false};
params ['_payload'];

if (_payload isEqualType [] && {count _payload > 0} && {(_payload select 0) isEqualType []}) then {
    private _licenses = _payload select 0;
    missionNamespace setVariable ['RHD_MyLicenses',_licenses];
    if (_licenses isEqualTo []) then {
        hint 'RHD LICENSES\n\nNo RHD licenses are currently registered.';
    } else {
        hint format ['RHD LICENSES\n\n%1',_licenses joinString '\n'];
    };
} else {
    hint format ['RHD: %1',_payload];
};
true
