/* Client-side world-event notification. */
if (!hasInterface || {!isRemoteExecuted} || {remoteExecutedOwner != 2}) exitWith {false};
params [['_type',''],['_message','']];
if (_type isEqualTo '' || {_message isEqualTo ''}) exitWith {false};
hint format ['RHD WORLD EVENT\n\n%1',_message];
true
