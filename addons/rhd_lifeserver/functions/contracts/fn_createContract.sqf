/*
    Creates one server-authoritative delivery contract for the requesting player.
    Contract state is keyed by Steam UID and intentionally held server-side.
*/
if (!isServer) exitWith {false};
params [['_player',objNull,[objNull]]];
if (isNull _player || {!isPlayer _player} || {!alive _player}) exitWith {false};

private _uid = getPlayerUID _player;
if (_uid isEqualTo '') exitWith {false};

private _contracts = missionNamespace getVariable ['RHD_ActiveContracts',createHashMap];
if !((_contracts getOrDefault [_uid,[]]) isEqualTo []) exitWith {
    ['RHD: You already have an active delivery contract.'] remoteExecCall ['RHD_fnc_contractResult',_player];
    false
};

private _choices = [
    ['apple','Apples',8,25],
    ['peach','Peaches',8,25],
    ['grape','Grapes',8,25],
    ['corn','Corn Cob',8,25],
    ['iron_unrefined','Iron Ore',10,40],
    ['copper_unrefined','Copper Ore',10,45],
    ['gold_ore','Gold Ore',4,55],
    ['diamond_uncut','Uncut Diamond',2,80],
    ['oil_sand','Oil Sand',8,35],
    ['cannabis','Cannabis Plant',4,65],
    ['coca_leaf','Coca Leaf',4,75]
];
private _choice = selectRandom _choices;
_choice params ['_item','_display','_min','_max'];
private _amount = _min + floor random ((_max - _min) + 1);
private _origin = getPosATL _player;
private _destination = [_origin,1500 + random 3500,random 360,8,0,0.5,0] call BIS_fnc_findSafePos;
if !(_destination isEqualType []) then {_destination = _origin;};
if (count _destination < 2) then {_destination = _origin;};

private _reward = round ((_amount * ([_item] call RHD_fnc_getPrice)) * 0.55);
_reward = (_reward max 500) min 50000;

private _contract = [
    _uid,
    diag_tickTime,
    _item,
    _display,
    _amount,
    _destination,
    _reward
];
_contracts set [_uid,_contract];
missionNamespace setVariable ['RHD_ActiveContracts',_contracts,true];

[_item,_amount] remoteExecCall ['RHD_fnc_contractResult',_player];
true
