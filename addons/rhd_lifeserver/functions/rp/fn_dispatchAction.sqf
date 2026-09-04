/*
    Authenticated dispatch state transition.
    Called only by RHD_fnc_rpAction after server-side role authorization.
    [dispatchId, action, authenticatedUID] call RHD_fnc_dispatchAction
    action: ACK or CLOSE
*/
if (!isServer) exitWith {false};
params [['_id',''],['_action',''],['_uid','']];
_action = toUpper _action;
if (_id isEqualTo '' || {!(_action in ['ACK','CLOSE'])}) exitWith {false};
if (_uid isEqualTo '' || {count _uid != 17}) exitWith {false};
private _safeUid = _uid select {(_x >= '0') && (_x <= '9')};
if (_safeUid != _uid) exitWith {false};

private _calls = missionNamespace getVariable ['RHD_DispatchCalls',createHashMap];
private _entry = _calls getOrDefault [_id,[]];
if (_entry isEqualTo []) exitWith {false};

private _status = _entry param [7,'OPEN'];
if (_action isEqualTo 'ACK' && {!(_status isEqualTo 'OPEN')}) exitWith {false};
if (_action isEqualTo 'CLOSE' && {!(_status in ['OPEN','ACK'])}) exitWith {false};

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
