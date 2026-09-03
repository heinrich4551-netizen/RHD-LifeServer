/* Client result handler. The temporary carry store is intentionally isolated from upstream inventory until the exact framework inventory API is selected. */
params ["_player","_resource","_amount"];
if (!hasInterface || {player != _player}) exitWith {};
private _key = format ["RHD_Carry_%1",_resource];
player setVariable [_key, player getVariable [_key,0] + _amount, true];
hint format ["RHD: Harvested %1 x%2",_amount,_resource];
