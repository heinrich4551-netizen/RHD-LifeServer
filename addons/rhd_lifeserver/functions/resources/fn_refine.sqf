/*
    Compatibility wrapper for older RHD callers.
    All refining is handled by the authoritative server routine.
*/
if (!isServer) exitWith {false};
params ["_unit", "_input", "_output", ["_ratio", 1]];
[_unit, _input, _output, _ratio] call RHD_fnc_refineServer
