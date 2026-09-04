/*
    Client-side inventory bridge for RHD harvesting.
    Only accepts execution originating from the dedicated server.
*/
if (!hasInterface || {!isRemoteExecuted} || {remoteExecutedOwner != 2}) exitWith {false};
params [['_item',''],['_amount',1,[0]],['_jobType',''],['_illegal',false],['_legalXP',0],['_illegalXP',0],['_legalLevel',1],['_illegalLevel',1],['_reward',0],['_leveled',false]];
if (_item isEqualTo '') exitWith {false};

private _give = (_amount max 1) min 50;
if !([true, _item, _give] call life_fnc_handleInv) exitWith {
    hint format ['RHD: You cannot carry any more %1.',_item];
    false
};

missionNamespace setVariable ['RHD_MyJobProgress',[_legalXP,_illegalXP,_legalLevel,_illegalLevel]];

if (_reward > 0) then {
    life_cash = life_cash + _reward;
    [0] call SOCK_fnc_updatePartial;
};

private _harvestText = format ['RHD: Harvested %1 x%2.',_item,_give];
if (_leveled) then {
    private _level = if (_illegal) then {_illegalLevel} else {_legalLevel};
    _harvestText = _harvestText + format ['\n\n%1 job level increased to %2.',_jobType,_level];
};
if (_reward > 0) then {
    _harvestText = _harvestText + format ['\nProgression bonus: $%1',_reward];
};
hint _harvestText;
true
