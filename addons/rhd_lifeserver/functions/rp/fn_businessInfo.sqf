/* Return the caller's server-authoritative business accounts. */
if (!isServer) exitWith {false};
params [['_caller',objNull,[objNull]]];
if (isNull _caller || {!alive _caller}) exitWith {false};
private _uid = getPlayerUID _caller;
if (_uid isEqualTo '') exitWith {false};
private _businesses = missionNamespace getVariable ['RHD_Businesses',createHashMap];
private _rows = [];
{
    private _b = _businesses getOrDefault [_x,[]];
    if !(_b isEqualTo [] || {count _b < 4}) then {
        if ((_b param [1,'']) isEqualTo _uid) then {
            private _balance = 0;
            if !(isNil 'DB_fnc_asyncCall') then {
                private _r = [format ["SELECT balance FROM rhd_business_accounts WHERE business_key='%1' AND owner_uid='%2' LIMIT 1",_x,_uid],2] call DB_fnc_asyncCall;
                if (_r isEqualType [] && {count _r > 0}) then {
                    _balance = _r param [0,0];
                    if (_balance isEqualType '') then {_balance = parseNumber _balance;};
                };
            };
            _rows pushBack [_x,_b param [2,'Business'],_balance max 0];
        };
    };
} forEach keys _businesses;
[_rows] remoteExecCall ['RHD_fnc_rpResult',owner _caller];
true
