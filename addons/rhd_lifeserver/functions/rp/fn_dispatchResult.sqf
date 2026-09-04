if (!hasInterface || {!isRemoteExecuted} || {remoteExecutedOwner != 2}) exitWith {false};
params ['_id','_type','_description','_position','_priority',['_status','OPEN']];
private _label = switch (toUpper _status) do {
    case 'ACK': {'ACKNOWLEDGED'};
    case 'CLOSED': {'CLOSED'};
    default {'OPEN'};
};
hint format ['RHD DISPATCH\n[%1] Priority %2\nStatus: %3\n%4\nGrid: %5',_type,_priority,_label,_description,mapGridPosition _position];
true
