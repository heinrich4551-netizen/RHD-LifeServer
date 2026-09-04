/* Server-authoritative government summary. [caller] call RHD_fnc_governmentInfo */
if (!isServer || {!isRemoteExecuted}) exitWith {false};
params [['_caller',objNull,[objNull]]];
if (isNull _caller || {!alive _caller}) exitWith {false};
if !(['ADMIN',1] call RHD_fnc_authorizeRole) exitWith {false};
private _gov = missionNamespace getVariable ['RHD_Government',createHashMap];
private _revenue = _gov getOrDefault ['taxRevenue',0];
private _taxCount = 0;
private _taxTotal = 0;
if !(isNil 'DB_fnc_asyncCall') then {
    private _r = ['SELECT COUNT(*), COALESCE(SUM(tax_amount),0) FROM rhd_tax_transactions',2] call DB_fnc_asyncCall;
    if (_r isEqualType [] && {count _r >= 2}) then {
        _taxCount = _r param [0,0];
        _taxTotal = _r param [1,0];
        if (_taxCount isEqualType '') then {_taxCount = parseNumber _taxCount;};
        if (_taxTotal isEqualType '') then {_taxTotal = parseNumber _taxTotal;};
    };
};
[['GOVERNMENT_SUMMARY',round _revenue,round _taxTotal,round _taxCount]] remoteExecCall ['RHD_fnc_rpResult',owner _caller];
true
