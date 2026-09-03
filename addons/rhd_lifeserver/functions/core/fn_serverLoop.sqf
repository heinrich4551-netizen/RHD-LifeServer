while {true} do {
    if (missionNamespace getVariable ['RHD_LifeServer_Enabled',true]) then {
        [] call RHD_fnc_updatePopulation;
        [] call RHD_fnc_economyLoop;

        private _contracts = missionNamespace getVariable ['RHD_ActiveContracts',createHashMap];
        private _expired = [];
        {
            private _contract = _contracts get _x;
            if !(_contract isEqualTo []) then {
                private _created = _contract param [1,diag_tickTime];
                if ((diag_tickTime - _created) > 3600) then {_expired pushBack _x;};
            };
        } forEach keys _contracts;
        {
            _contracts deleteAt _x;
        } forEach _expired;
        if (count _expired > 0) then {
            missionNamespace setVariable ['RHD_ActiveContracts',_contracts,true];
        };
    };
    sleep 60;
};
