/* Client bridge for validated RHD job progression. */
if (!hasInterface || {!isRemoteExecuted} || {remoteExecutedOwner != 2}) exitWith {false};
params [['_jobType','FARMING'],['_illegal',false],['_legalXP',0],['_illegalXP',0],['_legalLevel',1],['_illegalLevel',1],['_reward',0],['_leveled',false]];

/* Rewards are now committed server-side by RHD_fnc_financialTransaction.
   The client receives only the authoritative progression state and UI data. */
missionNamespace setVariable ['RHD_MyJobProgress',[_legalXP,_illegalXP,_legalLevel,_illegalLevel]];

if (_leveled) then {
    private _level = if (_illegal) then {_illegalLevel} else {_legalLevel};
    hint format ['RHD JOB PROGRESSION\n\n%1 Level %2\nXP: %3',_jobType,_level,if (_illegal) then {_illegalXP} else {_legalXP}];
};
true
