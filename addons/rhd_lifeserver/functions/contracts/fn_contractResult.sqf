/*
    Client bridge for RHD delivery contracts.
    Only the dedicated server may invoke this function.
*/
if (!hasInterface || {!isRemoteExecuted} || {remoteExecutedOwner != 2}) exitWith {false};
params [['_mode','', ['']],['_item','', ['']],['_amount',0,[0]],['_reward',0,[0]],['_display','', ['']],['_destination',[],[[]]]];

switch (_mode) do {
    case 'new': {
        if (_item isEqualTo '' || {_amount <= 0} || {count _destination < 2}) exitWith {false};
        if !([true,_item,_amount] call life_fnc_handleInv) exitWith {
            hint 'RHD: You do not have enough carrying capacity for this contract cargo.';
            false
        };
        player setVariable ['RHD_ContractDestination',_destination,false];
        hint format ['RHD CONTRACT\n\nDeliver %1 x%2.\nReward: $%3.\n\nDestination has been marked on your map.',_display,_amount,_reward];
        private _markerName = 'RHD_ContractDestination';
        deleteMarkerLocal _markerName;
        private _marker = createMarkerLocal [_markerName,_destination];
        _marker setMarkerTypeLocal 'mil_end';
        _marker setMarkerTextLocal format ['RHD Delivery: %1',_display];
        true
    };
    case 'complete': {
        if (_item isEqualTo '' || {_amount <= 0}) exitWith {false};
        if !([false,_item,_amount] call life_fnc_handleInv) exitWith {
            hint format ['RHD: You do not have the required %1 x%2.',_display,_amount];
            false
        };
        life_cash = life_cash + (_reward max 0);
        deleteMarkerLocal 'RHD_ContractDestination';
        player setVariable ['RHD_ContractDestination',nil,false];
        hint format ['RHD CONTRACT COMPLETE\n\nDelivered %1 x%2.\nPayment: $%3',_display,_amount,_reward];
        true
    };
    default {
        hint _mode;
        false
    };
};
