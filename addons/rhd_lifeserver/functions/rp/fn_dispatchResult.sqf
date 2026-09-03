if (!hasInterface || {!isRemoteExecuted} || {remoteExecutedOwner != 2}) exitWith {false};
params ['_id','_type','_description','_position','_priority'];
hint format ['RHD DISPATCH\n[%1] Priority %2\n%3\nGrid: %4',_type,_priority,_description,mapGridPosition _position];
true
