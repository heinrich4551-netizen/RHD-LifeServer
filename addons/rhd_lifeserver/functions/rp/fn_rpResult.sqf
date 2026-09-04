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
        missionNamespace setVariable ['RHD_VisibleImpounds',[]];
        missionNamespace setVariable ['RHD_MyBusinesses',[]];
        hint 'RHD LICENSES / IMPOUNDS / BUSINESSES\n\nNo records were returned.';
        true
    };

    private _first = _rows select 0;
    if (_first isEqualType '' || {_first isEqualType 0}) then {
        missionNamespace setVariable ['RHD_MyLicenses',_rows];
        hint format ['RHD LICENSES\n\n%1',_rows joinString '\n'];
    } else {
        private _isBusiness = (count _first isEqualTo 3) && {((_first param [0,'']) isEqualType '')} && {((_first param [0,'']) find 'B-') isEqualTo 0};
        if (_isBusiness) then {
            missionNamespace setVariable ['RHD_MyBusinesses',_rows];
            private _lines = ['RHD BUSINESSES',''];
            { _lines pushBack format ['%1 | Balance: $%2 | ID: %3',_x param [1,'Business'],round (_x param [2,0]),_x param [0,'']]; } forEach _rows;
            hint (_lines joinString '\n');
        } else {
            missionNamespace setVariable ['RHD_VisibleImpounds',_rows];
            private _lines = ['RHD POLICE IMPOUNDS',''];
            { _lines pushBack format ['%1 | Fee $%2 | %3 | %4',_x param [0,''],_x param [3,0],_x param [2,''],if ((_x param [4,0]) isEqualTo 3) then {'RELEASED'} else {'IMPOUNDED'}]; } forEach _rows;
            hint (_lines joinString '\n');
        };
    };
} else {
    private _type = _payload param [0,''];
    switch (_type) do {
        case 'LICENSE_UPDATED': {hint format ['RHD DMV\n\nLicense: %1\nStatus: %2',_payload param [1,''],if (_payload param [2,false]) then {'GRANTED'} else {'REVOKED'}];};
        case 'IMPOUNDED': {hint format ['RHD POLICE\n\nVehicle impounded.\nImpound ID: %1\nRelease fee: $%2',_payload param [1,''],_payload param [3,0]];};
        case 'IMPOUND_RELEASED': {hint format ['RHD IMPOUND\n\n%1 released.\nFee: $%2',_payload param [1,''],_payload param [2,0]];};
        case 'IMPOUND_PAYMENT_DENIED': {hint format ['RHD IMPOUND\n\nRelease denied.\nRequired fee: $%2\nThe vehicle owner must have sufficient cash and be online.',_payload param [1,''],_payload param [2,0]];};
        case 'HOSPITAL_BILL': {hint format ['RHD EMS\n\nHospital bill charged: $%1.',_payload param [1,0]];};
        case 'HOSPITAL_BILL_DENIED': {hint format ['RHD EMS\n\nHospital billing denied.\nAmount: $%1',_payload param [1,0]];};
        case 'TREATMENT': {hint format ['RHD EMS\n\nTreatment completed.\nRecorded charge: $%1',_payload param [1,0]];};
        case 'TREATMENT_DENIED': {hint format ['RHD EMS\n\nTreatment denied.\nCharge required: $%1',_payload param [1,0]];};
        case 'VEHICLE_SERVICE': {hint format ['RHD VEHICLE SERVICE\n\n%1 completed.\nCharge: $%3\nDamage after service: %4',_payload param [2,'Service'],_payload param [1,''],_payload param [3,0],_payload param [4,0]];};
        case 'VEHICLE_SERVICE_DENIED': {hint format ['RHD VEHICLE SERVICE\n\nService denied.\nCharge required: $%3',_payload param [2,'Service'],_payload param [1,''],_payload param [3,0]];};
        case 'BUSINESS_CREATED': {hint format ['RHD BUSINESS\n\nBusiness created.\nName: %2\nID: %1\nType: %3\nStartup fee: $%4',_payload param [1,''],_payload param [2,'Business'],_payload param [3,'GENERAL'],_payload param [4,0]];};
        case 'BUSINESS_CREATE_DENIED': {hint format ['RHD BUSINESS\n\nBusiness creation failed.\nStartup fee attempted: $%2\nCheck your cash balance and database connection.',_payload param [1,'Business'],_payload param [2,0]];};
        case 'BUSINESS_TRANSACTION': {hint format ['RHD BUSINESS ACCOUNT\n\n%2: $%3\nNew business balance: $%4',_payload param [1,''],_payload param [2,'TRANSACTION'],_payload param [3,0],_payload param [4,0]];};
        case 'BUSINESS_TRANSACTION_DENIED': {hint format ['RHD BUSINESS ACCOUNT\n\nTransaction denied.\n%2 $%3\nCurrent business balance: $%4',_payload param [1,''],_payload param [2,'TRANSACTION'],_payload param [3,0],_payload param [4,0]];};
        default {hint format ['RHD: %1',_payload];};
    };
};
true
