private _lastPersistence = diag_tickTime;
private _saveMinutes = getNumber (missionConfigFile >> 'RHD_LifeServer' >> 'Persistence' >> 'saveIntervalMinutes');
if (_saveMinutes <= 0) then {_saveMinutes = 5;};
private _perfCfg = missionConfigFile >> 'RHD_LifeServer' >> 'Performance';
private _perfEnabled = getNumber (_perfCfg >> 'enabled') > 0;
private _logLoop = getNumber (_perfCfg >> 'logServerLoop') > 0;
private _logSlow = getNumber (_perfCfg >> 'logSlowSection') > 0;
private _slowMs = getNumber (_perfCfg >> 'slowSectionMilliseconds');
if (_slowMs <= 0) then {_slowMs = 50;};

while {true} do {
    private _loopStart = diag_tickTime;
    if (missionNamespace getVariable ['RHD_LifeServer_Enabled',true]) then {
        private _sectionStart = diag_tickTime;
        [] call RHD_fnc_updatePopulation;
        private _populationMs = (diag_tickTime - _sectionStart) * 1000;

        _sectionStart = diag_tickTime;
        [] call RHD_fnc_economyLoop;
        private _economyMs = (diag_tickTime - _sectionStart) * 1000;

        _sectionStart = diag_tickTime;
        [] call RHD_fnc_rpMaintenance;
        private _rpMs = (diag_tickTime - _sectionStart) * 1000;

        _sectionStart = diag_tickTime;
        [] call RHD_fnc_worldEvents;
        private _eventsMs = (diag_tickTime - _sectionStart) * 1000;

        private _contractsStart = diag_tickTime;
        private _contracts = missionNamespace getVariable ['RHD_ActiveContracts',createHashMap];
        private _expired = [];
        {
            private _contract = _contracts get _x;
            if !(_contract isEqualTo []) then {
                private _created = _contract param [1,diag_tickTime];
                if ((diag_tickTime - _created) > 3600) then {_expired pushBack _x;};
            };
        } forEach keys _contracts;
        {_contracts deleteAt _x;} forEach _expired;
        if (count _expired > 0) then {
            missionNamespace setVariable ['RHD_ActiveContracts',_contracts,true];
        };
        private _contractsMs = (diag_tickTime - _contractsStart) * 1000;

        private _persistenceMs = 0;
        if (missionNamespace getVariable ['RHD_PersistenceEnabled',false]) then {
            if ((diag_tickTime - _lastPersistence) >= (_saveMinutes * 60)) then {
                _sectionStart = diag_tickTime;
                [] call RHD_fnc_persistenceLoop;
                _persistenceMs = (diag_tickTime - _sectionStart) * 1000;
                _lastPersistence = diag_tickTime;
            };
        };

        private _loopMs = (diag_tickTime - _loopStart) * 1000;
        if (_perfEnabled) then {
            missionNamespace setVariable ['RHD_PerformanceLast',[round _loopMs,round _populationMs,round _economyMs,round _rpMs,round _eventsMs,round _contractsMs,round _persistenceMs],true];
            if (_logSlow) then {
                if (_populationMs >= _slowMs) then {diag_log format ['[RHD-PERF] population %.1f ms',_populationMs];};
                if (_economyMs >= _slowMs) then {diag_log format ['[RHD-PERF] economy %.1f ms',_economyMs];};
                if (_rpMs >= _slowMs) then {diag_log format ['[RHD-PERF] rpMaintenance %.1f ms',_rpMs];};
                if (_eventsMs >= _slowMs) then {diag_log format ['[RHD-PERF] worldEvents %.1f ms',_eventsMs];};
                if (_contractsMs >= _slowMs) then {diag_log format ['[RHD-PERF] contracts %.1f ms',_contractsMs];};
                if (_persistenceMs >= _slowMs) then {diag_log format ['[RHD-PERF] persistence %.1f ms',_persistenceMs];};
            };
            if (_logLoop) then {
                diag_log format ['[RHD-PERF] serverLoop %.1f ms | pop %.1f | economy %.1f | rp %.1f | events %.1f | contracts %.1f | persistence %.1f',_loopMs,_populationMs,_economyMs,_rpMs,_eventsMs,_contractsMs,_persistenceMs];
            };
        };
    };
    sleep 60;
};
