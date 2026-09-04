/*
    Client bridge for RHD delivery contracts.
    Only the dedicated server may invoke this function.
*/
if (!hasInterface || {!isRemoteExecuted} || {remoteExecutedOwner != 2}) exitWith {false};
params [['_mode','', ['']],['_item','', ['']],['_amount',0,[0]],['_reward',0,[0]],['_display','', ['']],['_destination',[],[[]]],['_contractId','',['']]];

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
        if (_item isEqualTo '' || {_amount <= 0} || {_contractId isEqualTo ''}) exitWith {false};
        if !([false,_item,_amount] call life_fnc_handleInv) exitWith {
            hint format ['RHD: You do not have the required %1 x%2.',_display,_amount];
            false
        };
        deleteMarkerLocal 'RHD_ContractDestination';
        player setVariable ['RHD_ContractDestination',nil,false];
        [_contractId] remoteExecCall ['RHD_fnc_contractCompleteAck',2];
        hint format ['RHD CONTRACT\n\nDelivered %1 x%2.\nPayment is being processed by the server.',_display,_amount];
        true
    };
    case 'paid': {
        hint format ['RHD CONTRACT COMPLETE\n\nContract payment received: $%1.',_reward];
        true
    };
    case 'message': {
        hint _display;
        false
    };
    default {
        hint _mode;
        false
    };
};
