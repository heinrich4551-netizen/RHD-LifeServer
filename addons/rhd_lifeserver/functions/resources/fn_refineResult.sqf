/*
    Client-side inventory bridge for RHD refining.
    Only accepts execution originating from the dedicated server.
*/
if (!hasInterface || {!isRemoteExecuted} || {remoteExecutedOwner != 2}) exitWith {false};
params ["_input", "_output", ["_amount", 1]];
if (_input isEqualTo "" || {_output isEqualTo ""}) exitWith {false};
private _take = (_amount max 1) min 50;
if !([false, _input, _take] call life_fnc_handleInv) exitWith {
    hint format ["RHD: Not enough %1 or not enough carrying capacity.", _input];
    false
};
if !([true, _output, _take] call life_fnc_handleInv) exitWith {
    [true, _input, _take] call life_fnc_handleInv;
    hint "RHD: Processing failed; your input was returned.";
    false
};
hint format ["RHD: Refined %1 x%2 into %3.", _input, _take, _output];
true
