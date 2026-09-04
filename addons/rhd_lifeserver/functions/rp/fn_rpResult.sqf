/*
    Client-side RP result bridge.
    Server-originated only.
*/
if (!hasInterface || {!isRemoteExecuted} || {remoteExecutedOwner != 2}) exitWith {false};
params ['_payload'];

if (_payload isEqualType [] && {count _payload > 0} && {(_payload select 0) isEqualType []}) then {
    private _rows = _payload;
    if (_rows isEqualTo []) exitWith {
        missionNamespace setVariable ['RHD_MyLicenses',[]];
        hint 'RHD LICENSES / IMPOUNDS\n\nNo records were returned.';
        true
    };

    private _first = _rows select 0;
    if (_first isEqualType '' || {_first isEqualType 0}) then {
        missionNamespace setVariable ['RHD_MyLicenses',_rows];
        hint format ['RHD LICENSES\n\n%1',_rows joinString '\n'];
    } else {
        missionNamespace setVariable ['RHD_VisibleImpounds',_rows];
        private _lines = ['RHD POLICE IMPOUNDS',''];
        {
            _lines pushBack format ['%1 | Fee $%2 | %3 | %4',_x param [0,''],_x param [3,0],_x param [2,''],if ((_x param [4,0]) isEqualTo 3) then {'RELEASED'} else {'IMPOUNDED'}];
        } forEach _rows;
        hint (_lines joinString '\n');
    };
} else {
    hint format ['RHD: %1',_payload];
};
true
