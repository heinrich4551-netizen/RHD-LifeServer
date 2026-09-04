/*
    Creates one server-authoritative delivery contract for the requesting player.
    Contract state is keyed by Steam UID and held server-side.
*/
if (!isServer || {!isRemoteExecuted}) exitWith {false};
params [['_player',objNull,[objNull]]];
private _caller = allPlayers select {owner _x isEqualTo remoteExecutedOwner} param [0,objNull];
if (isNull _caller || {_player isNotEqualTo _caller}) exitWith {false};
_player = _caller;
if (!isPlayer _player || {!alive _player}) exitWith {false};

private _uid = getPlayerUID _player;
if (_uid isEqualTo '') exitWith {false};

private _contracts = missionNamespace getVariable ['RHD_ActiveContracts',createHashMap];
if !((_contracts getOrDefault [_uid,[]]) isEqualTo []) exitWith {
    ['message','','',0,'You already have an active delivery contract.'] remoteExecCall ['RHD_fnc_contractResult',_player];
    false
};

private _choices = [
    ['apple','Apples',8,25],['peach','Peaches',8,25],['grape','Grapes',8,25],['corn','Corn Cob',8,25],
    ['iron_unrefined','Iron Ore',10,40],['copper_unrefined','Copper Ore',10,45],['gold_ore','Gold Ore',4,55],
    ['diamond_uncut','Uncut Diamond',2,80],['oil_sand','Oil Sand',8,35],['cannabis','Cannabis Plant',4,65],['coca_leaf','Coca Leaf',4,75]
];
private _choice = selectRandom _choices;
_choice params ['_item','_display','_min','_max'];
private _amount = _min + floor random ((_max - _min) + 1);
private _origin = getPosATL _player;
private _destination = [_origin,1500 + random 3500,random 360,8,0,0.5,0] call BIS_fnc_findSafePos;
if !(_destination isEqualType []) then {_destination = _origin;};
if (count _destination < 2) then {_destination = _origin;};

private _price = [_item] call RHD_fnc_getPrice;
if (_price <= 0) then {_price = 100;};
private _reward = round ((_amount * _price) * 0.55);
_reward = (_reward max 500) min 50000;

private _contract = [_uid,diag_tickTime,_item,_display,_amount,_destination,_reward];
_contracts set [_uid,_contract];
missionNamespace setVariable ['RHD_ActiveContracts',_contracts,true];

['new',_item,_amount,_reward,_display,_destination] remoteExecCall ['RHD_fnc_contractResult',_player];
true
