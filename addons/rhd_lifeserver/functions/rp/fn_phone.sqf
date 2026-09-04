/* Server-side RP phone service.
   [caller,action,args] call RHD_fnc_phone
   Actions: REGISTER, CALL, MESSAGE.
*/
if (!isServer || {!isRemoteExecuted}) exitWith {false};
params [['_caller',objNull,[objNull]],['_action',''],['_args',[],[[]]]];
if (isNull _caller || {!alive _caller}) exitWith {false};
_action = toUpper _action;
private _uid = getPlayerUID _caller;
if (_uid isEqualTo '') exitWith {false};
private _phones = missionNamespace getVariable ['RHD_PhoneRegistry',createHashMap];
switch (_action) do {
    case 'REGISTER': {
        private _number = _phones getOrDefault [_uid,''];
        if (_number isEqualTo '') then {_number = format ['555-%1',floor (random 9000) + 1000]; _phones set [_uid,_number]; missionNamespace setVariable ['RHD_PhoneRegistry',_phones,true];};
        [['PHONE_NUMBER',_number]] remoteExecCall ['RHD_fnc_rpResult',owner _caller];
        true
    };
    case 'CALL': {
        private _targetNumber = _args param [0,''];
        private _targetUID = '';
        {if ((_phones getOrDefault [_x,'']) isEqualTo _targetNumber) exitWith {_targetUID = _x;};} forEach keys _phones;
        private _target = if (_targetUID isEqualTo '') then {objNull} else {allPlayers select {getPlayerUID _x isEqualTo _targetUID} param [0,objNull]};
        if (isNull _target) exitWith {[['PHONE_ERROR','Number unavailable.']] remoteExecCall ['RHD_fnc_rpResult',owner _caller]; false};
        ['PHONE_CALL',format ['Incoming call from %1',_phones getOrDefault [_uid,'UNKNOWN']]] remoteExecCall ['RHD_fnc_rpResult',owner _target];
        [['PHONE_CALL_SENT',_targetNumber]] remoteExecCall ['RHD_fnc_rpResult',owner _caller];
        true
    };
    case 'MESSAGE': {
        private _targetNumber = _args param [0,''];
        private _message = (_args param [1,'']) select [0,256];
        private _targetUID = '';
        {if ((_phones getOrDefault [_x,'']) isEqualTo _targetNumber) exitWith {_targetUID = _x;};} forEach keys _phones;
        private _target = if (_targetUID isEqualTo '') then {objNull} else {allPlayers select {getPlayerUID _x isEqualTo _targetUID} param [0,objNull]};
        if (isNull _target || {_message isEqualTo ''}) exitWith {false};
        [['PHONE_MESSAGE',_phones getOrDefault [_uid,'UNKNOWN'],_message]] remoteExecCall ['RHD_fnc_rpResult',owner _target];
        [['PHONE_MESSAGE_SENT',_targetNumber]] remoteExecCall ['RHD_fnc_rpResult',owner _caller];
        true
    };
    default {false};
};
