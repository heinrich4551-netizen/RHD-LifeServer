/* Client bridge for validated RHD job progression. */
if (!hasInterface || {!isRemoteExecuted} || {remoteExecutedOwner != 2}) exitWith {false};
params [['_jobType','FARMING'],['_illegal',false],['_legalXP',0],['_illegalXP',0],['_legalLevel',1],['_illegalLevel',1],['_reward',0],['_leveled',false]];

missionNamespace setVariable ['RHD_MyJobProgress',[_legalXP,_illegalXP,_legalLevel,_illegalLevel]];

if (_reward > 0) then {
    life_cash = life_cash + _reward;
    [0] call SOCK_fnc_updatePartial;
};

if (_leveled) then {
    private _level = if (_illegal) then {_illegalLevel} else {_legalLevel};
    hint format ['RHD JOB PROGRESSION\n\n%1 Level %2\nXP: %3\n\nProgression reward: $%4',_jobType,_level,if (_illegal) then {_illegalXP} else {_legalXP},_reward];
} else {
    if (_reward > 0) then {
        hint format ['RHD JOB BONUS\n\n$%1 progression bonus awarded.',_reward];
    };
};
true
