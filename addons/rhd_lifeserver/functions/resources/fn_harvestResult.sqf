/*
    Client-side inventory bridge for RHD harvesting.
    Only accepts execution originating from the dedicated server.
*/
if (!hasInterface || {!isRemoteExecuted} || {remoteExecutedOwner != 2}) exitWith {false};
params ["_item", ["_amount", 1]];
if (_item isEqualTo "") exitWith {false};
private _give = (_amount max 1) min 50;
if !([true, _item, _give] call life_fnc_handleInv) exitWith {
    hint format ["RHD: You cannot carry any more %1.", _item];
    false
};
hint format ["RHD: Harvested %1 x%2.", _give, _item];
true
