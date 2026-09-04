/*
    Server-side police impound registry read.
    Called by RHD_fnc_rpAction after role authorization.
*/
if (!isServer || {!isRemoteExecuted}) exitWith {false};
params [['_caller',objNull,[objNull]]];
if (isNull _caller || {!alive _caller}) exitWith {false};

private _impounds = missionNamespace getVariable ['RHD_Impounds',createHashMap];
private _result = [];
{
    private _entry = _impounds getOrDefault [_x,[]];
    if !(_entry isEqualTo [] || {count _entry < 8}) then {
        private _status = _entry param [6,2];
        if (_status in [2,3]) then {
            _result pushBack [
                _entry param [0,''],
                _entry param [1,''],
                _entry param [3,''],
                _entry param [4,0],
                _status,
                _entry param [5,0]
            ];
        };
    };
} forEach keys _impounds;

_result sort true;
[_result] remoteExecCall ['RHD_fnc_rpResult',owner _caller];
true
