/*
    Authenticated dispatch state transition.
    [dispatchId, action] call RHD_fnc_dispatchAction
    action: ACK or CLOSE
*/
if (!isServer || {!isRemoteExecuted}) exitWith {false};
params [['_id',''],['_action','']];
_action = toUpper _action;
if (_id isEqualTo '' || {!(_action in ['ACK','CLOSE'])}) exitWith {false};

private _calls = missionNamespace getVariable ['RHD_DispatchCalls',createHashMap];
private _entry = _calls getOrDefault [_id,[]];
if (_entry isEqualTo []) exitWith {false};

private _status = _entry param [7,'OPEN'];
if (_action isEqualTo 'ACK' && {!(_status isEqualTo 'OPEN')}) exitWith {false};
if (_action isEqualTo 'CLOSE' && {!(_status in ['OPEN','ACK'])}) exitWith {false};

private _caller = allPlayers select {owner _x isEqualTo remoteExecutedOwner} param [0,objNull];
if (isNull _caller) exitWith {false};
private _uid = getPlayerUID _caller;
if (_uid isEqualTo '') exitWith {false};

_entry set [7,if (_action isEqualTo 'ACK') then {'ACK'} else {'CLOSED'}];
_entry set [8,_uid];
_entry set [9,diag_tickTime];
_calls set [_id,_entry];
missionNamespace setVariable ['RHD_DispatchCalls',_calls,true];

private _type = _entry param [2,'GENERAL'];
private _description = _entry param [3,''];
private _position = _entry param [4,[0,0,0]];
private _priority = _entry param [5,2];
private _newStatus = _entry param [7,'OPEN'];
[_id,_type,_description,_position,_priority,_newStatus] remoteExecCall ['RHD_fnc_dispatchResult',-2];
true
