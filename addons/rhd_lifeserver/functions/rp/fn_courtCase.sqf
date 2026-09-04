/* Server-authoritative court case registry.
   [caller,action,caseId,targetUID,charge] call RHD_fnc_courtCase
   Actions: CREATE, CLOSE. Police/admin may create; admin may close.
*/
if (!isServer || {!isRemoteExecuted}) exitWith {false};
params [['_caller',objNull,[objNull]],['_action',''],['_caseId',''],['_targetUID',''],['_charge','']];
if (isNull _caller || {!alive _caller}) exitWith {false};
_action = toUpper _action;
private _authorized = ['ADMIN',1] call RHD_fnc_authorizeRole;
if (!_authorized) then {_authorized = ['COP',2] call RHD_fnc_authorizeRole;};
if (!_authorized) exitWith {false};
private _cases = missionNamespace getVariable ['RHD_CourtCases',createHashMap];
if (_action isEqualTo 'CREATE') then {
    if (_targetUID isEqualTo '' || {count _targetUID != 17}) exitWith {false};
    private _safe = _targetUID select {(_x >= '0') && (_x <= '9')};
    if (_safe != _targetUID) exitWith {false};
    _charge = _charge select [0,256];
    if (_charge isEqualTo '') exitWith {false};
    private _id = format ['C-%1-%2',floor diag_tickTime,floor random 10000];
    _cases set [_id,[_id,_targetUID,_charge,'OPEN',diag_tickTime,getPlayerUID _caller]];
    missionNamespace setVariable ['RHD_CourtCases',_cases,true];
    [['COURT_CASE_CREATED',_id,_targetUID,_charge]] remoteExecCall ['RHD_fnc_rpResult',owner _caller];
    true
} else {
    if (_action isNotEqualTo 'CLOSE' || {_caseId isEqualTo ''}) exitWith {false};
    if !(['ADMIN',1] call RHD_fnc_authorizeRole) exitWith {false};
    private _case = _cases getOrDefault [_caseId,[]];
    if (_case isEqualTo [] || {count _case < 6}) exitWith {false};
    _case set [3,'CLOSED'];
    _case set [6,diag_tickTime];
    _cases set [_caseId,_case];
    missionNamespace setVariable ['RHD_CourtCases',_cases,true];
    [['COURT_CASE_CLOSED',_caseId]] remoteExecCall ['RHD_fnc_rpResult',owner _caller];
    true
};
