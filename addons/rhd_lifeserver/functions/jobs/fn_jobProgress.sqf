/*
    Server-authoritative legal/illegal job progression.
    Called internally after a validated resource harvest.
    [player,jobType,illegal,amount] call RHD_fnc_jobProgress
*/
if (!isServer || {isRemoteExecuted}) exitWith {false};
params [['_player',objNull,[objNull]],['_jobType','FARMING'],['_illegal',false,[true]],['_amount',1,[0]]];
if (isNull _player || {!isPlayer _player} || {_amount <= 0}) exitWith {false};

private _uid = getPlayerUID _player;
if (_uid isEqualTo '') exitWith {false};

private _jobs = missionNamespace getVariable ['RHD_JobProgress',createHashMap];
private _state = _jobs getOrDefault [_uid,[0,0,0,0,0]];
_state params ['_legalXP','_illegalXP','_legalLevel','_illegalLevel','_harvests'];

private _xp = (_amount max 1) * if (_illegal) then {2} else {1};
if (_illegal) then {_illegalXP = _illegalXP + _xp;} else {_legalXP = _legalXP + _xp;};
_harvests = _harvests + 1;

private _newLegalLevel = 1 + floor (_legalXP / 100);
private _newIllegalLevel = 1 + floor (_illegalXP / 100);
private _leveled = (_newLegalLevel > _legalLevel) || {_newIllegalLevel > _illegalLevel};
_legalLevel = _newLegalLevel;
_illegalLevel = _newIllegalLevel;
_jobs set [_uid,[_legalXP,_illegalXP,_legalLevel,_illegalLevel,_harvests]];
missionNamespace setVariable ['RHD_JobProgress',_jobs,true];

/* Small progression payout. The upstream Framework remains responsible for
   persistence of the player's normal cash/bank fields. */
private _reward = 0;
if ((_harvests mod 10) isEqualTo 0) then {
    private _level = if (_illegal) then {_illegalLevel} else {_legalLevel};
    _reward = 250 + ((_level max 1) * 50);
};

[_jobType,_illegal,_legalXP,_illegalXP,_legalLevel,_illegalLevel,_reward,_leveled] remoteExecCall ['RHD_fnc_jobResult',_player];
true
