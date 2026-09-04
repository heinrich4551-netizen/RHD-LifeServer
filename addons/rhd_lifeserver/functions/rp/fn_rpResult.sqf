/* Client-side RP result bridge. Server-originated only. */
if (!hasInterface || {!isRemoteExecuted} || {remoteExecutedOwner != 2}) exitWith {false};
params ['_payload'];
if (_payload isEqualType [] && {count _payload > 0} && {(_payload select 0) isEqualType []}) then {
    private _rows = _payload;
    if (_rows isEqualTo []) exitWith {missionNamespace setVariable ['RHD_MyLicenses',[]]; missionNamespace setVariable ['RHD_VisibleImpounds',[]]; missionNamespace setVariable ['RHD_MyBusinesses',[]]; hint 'RHD: No records were returned.'; true};
    private _first = _rows select 0;
    if (_first isEqualType '' || {_first isEqualType 0}) then {missionNamespace setVariable ['RHD_MyLicenses',_rows]; hint format ['RHD LICENSES\n\n%1',_rows joinString '\n'];} else {
        private _isBusiness = (count _first isEqualTo 3) && {((_first param [0,'']) isEqualType '')} && {((_first param [0,'']) find 'B-') isEqualTo 0};
        private _isMarketplace = (count _first isEqualTo 5) && {(_first param [0,'']) isEqualType ''} && {((_first param [0,'']) find 'M-') isEqualTo 0};
        if (_isBusiness) then {
            missionNamespace setVariable ['RHD_MyBusinesses',_rows];
            private _lines=['RHD BUSINESSES',''];
            {_lines pushBack format ['%1 | Balance: $%2 | ID: %3',_x param [1,'Business'],round (_x param [2,0]),_x param [0,'']];} forEach _rows;
            hint (_lines joinString '\n');
        } else {
            if (_isMarketplace) then {
                missionNamespace setVariable ['RHD_MarketListings',_rows];
                private _lines=['RHD MARKETPLACE',''];
                {_lines pushBack format ['%1 | %2 x%3 | $%4 each | Seller %5',_x param [0,''],_x param [2,''],_x param [3,0],_x param [4,0],_x param [1,'']];} forEach _rows;
                hint (_lines joinString '\n');
            } else {
                missionNamespace setVariable ['RHD_VisibleImpounds',_rows];
                private _lines=['RHD POLICE IMPOUNDS',''];
                {_lines pushBack format ['%1 | Fee $%2 | %3 | %4',_x param [0,''],_x param [3,0],_x param [2,''],if ((_x param [4,0]) isEqualTo 3) then {'RELEASED'} else {'IMPOUNDED'}];} forEach _rows;
                hint (_lines joinString '\n');
            };
        };
    };
} else {
    private _type = _payload param [0,''];
    switch (_type) do {
        case 'LICENSE_UPDATED': {hint format ['RHD DMV\n\nLicense: %1\nStatus: %2',_payload param [1,''],if (_payload param [2,false]) then {'GRANTED'} else {'REVOKED'}];};
        case 'IMPOUNDED': {hint format ['RHD POLICE\n\nVehicle impounded.\nImpound ID: %1\nRelease fee: $%2',_payload param [1,''],_payload param [3,0]];};
        case 'IMPOUND_RELEASED': {hint format ['RHD IMPOUND\n\n%1 released.\nFee: $%2',_payload param [1,''],_payload param [2,0]];};
        case 'IMPOUND_PAYMENT_DENIED': {hint format ['RHD IMPOUND\n\nRelease denied.\nRequired fee: $%2',_payload param [1,''],_payload param [2,0]];};
        case 'HOSPITAL_BILL': {hint format ['RHD EMS\n\nHospital bill charged: $%1.',_payload param [1,0]];};
        case 'HOSPITAL_BILL_DENIED': {hint format ['RHD EMS\n\nHospital billing denied.\nAmount: $%1',_payload param [1,0]];};
        case 'TREATMENT': {hint format ['RHD EMS\n\nTreatment completed.\nRecorded charge: $%1',_payload param [1,0]];};
        case 'TREATMENT_DENIED': {hint format ['RHD EMS\n\nTreatment denied.\nCharge required: $%1',_payload param [1,0]];};
        case 'VEHICLE_SERVICE': {hint format ['RHD VEHICLE SERVICE\n\n%1 completed.\nCharge: $%3\nDamage after service: %4',_payload param [2,'Service'],_payload param [1,''],_payload param [3,0],_payload param [4,0]];};
        case 'VEHICLE_SERVICE_DENIED': {hint format ['RHD VEHICLE SERVICE\n\nService denied.\nCharge required: $%3',_payload param [2,'Service'],_payload param [1,''],_payload param [3,0]];};
        case 'BUSINESS_CREATED': {hint format ['RHD BUSINESS\n\nBusiness created.\nName: %2\nID: %1\nType: %3\nStartup fee: $%4',_payload param [1,''],_payload param [2,'Business'],_payload param [3,'GENERAL'],_payload param [4,0]];};
        case 'BUSINESS_CREATE_DENIED': {hint format ['RHD BUSINESS\n\nBusiness creation failed.\nStartup fee attempted: $%2',_payload param [1,'Business'],_payload param [2,0]];};
        case 'BUSINESS_TRANSACTION': {hint format ['RHD BUSINESS ACCOUNT\n\n%2: $%3\nNew business balance: $%4',_payload param [1,''],_payload param [2,'TRANSACTION'],_payload param [3,0],_payload param [4,0]];};
        case 'BUSINESS_TRANSACTION_DENIED': {hint format ['RHD BUSINESS ACCOUNT\n\nTransaction denied.\n%2 $%3\nCurrent business balance: $%4',_payload param [1,''],_payload param [2,'TRANSACTION'],_payload param [3,0],_payload param [4,0]];};
        case 'GOVERNMENT_SUMMARY': {hint format ['RHD GOVERNMENT\n\nSession tax revenue: $%1\nRecorded tax revenue: $%2\nTax transactions: %3',_payload param [1,0],_payload param [2,0],_payload param [3,0]];};
        case 'COURT_CASE_CREATED': {hint format ['RHD COURT\n\nCase opened: %1\nDefendant UID: %2\nCharge: %3',_payload param [1,''],_payload param [2,''],_payload param [3,'']];};
        case 'COURT_CASE_CLOSED': {hint format ['RHD COURT\n\nCase closed: %1',_payload param [1,'']];};
        case 'PHONE_NUMBER': {missionNamespace setVariable ['RHD_MyPhoneNumber',_payload param [1,'']]; hint format ['RHD PHONE\n\nYour number: %1',_payload param [1,'']];};
        case 'PHONE_CALL': {hint format ['RHD PHONE\n\n%1',_payload param [1,'Incoming call']];};
        case 'PHONE_CALL_SENT': {hint format ['RHD PHONE\n\nCalling %1...',_payload param [1,'']];};
        case 'PHONE_MESSAGE': {hint format ['RHD SMS\n\nFrom: %1\n\n%2',_payload param [1,'Unknown'],_payload param [2,'']];};
        case 'PHONE_MESSAGE_SENT': {hint format ['RHD SMS\n\nMessage sent to %1.',_payload param [1,'']];};
        case 'PHONE_ERROR': {hint format ['RHD PHONE\n\n%1',_payload param [1,'Phone error']];};
        case 'MARKET_LISTED': {hint format ['RHD MARKETPLACE\n\nListing created.\n%1 x%2\n$%3 each\nListing: %4',_payload param [2,''],_payload param [3,0],_payload param [4,0],_payload param [1,'']];};
        case 'MARKET_LIST_FAILED': {hint format ['RHD MARKETPLACE\n\nListing failed.\n%1',_payload param [2,'Unable to reserve inventory.']];};
        case 'MARKET_CANCELLED': {hint format ['RHD MARKETPLACE\n\nListing cancelled: %1',_payload param [1,'']];};
        case 'MARKET_CANCEL_FAILED': {hint format ['RHD MARKETPLACE\n\nCancellation failed.\n%1',_payload param [2,'Reserved inventory could not be returned.']];};
        case 'MARKET_BUY_FAILED': {hint format ['RHD MARKETPLACE\n\nPurchase failed.\n%1',_payload param [2,'Transaction failed.']];};
        case 'MARKET_COMPLETE': {hint format ['RHD MARKETPLACE\n\nPurchase complete.\n%1 x%2\nTotal paid: $%3\nListing: %4',_payload param [2,''],_payload param [3,0],_payload param [4,0],_payload param [1,'']];};
        case 'MARKET_SOLD': {hint format ['RHD MARKETPLACE\n\nListing sold.\n%1 x%2\nRevenue: $%3\nListing: %4',_payload param [2,''],_payload param [3,0],_payload param [4,0],_payload param [1,'']];};
        case 'ECONOMY_DASHBOARD': {
            private _summary = _payload param [1,[]];
            private _count = _summary param [0,0];
            private _eventMultiplier = _summary param [1,1];
            private _event = _summary param [2,[]];
            private _rows = _summary param [3,[]];
            private _eventName = if (_event isEqualType [] && {count _event > 0}) then {format ['%1',_event param [0,'NONE']]} else {'NONE'};
            private _lines = [format ['RHD ECONOMY DASHBOARD | %1 tracked items | Event: %2 | Market x%3',_count,_eventName,_eventMultiplier],''];
            {
                _lines pushBack format ['%1 | Base $%2 | Current $%3 | Demand %4 | Supply %5',_x param [0,''],_x param [1,0],_x param [2,0],_x param [3,1],_x param [4,1]];
            } forEach _rows;
            hint (_lines joinString '\n');
        };
        default {hint format ['RHD: %1',_payload];};
    };
};
true
