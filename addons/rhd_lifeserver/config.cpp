class CfgPatches {
    class RHD_LifeServer {
        name = "RHD LifeServer";
        author = "LT. Toad";
        requiredVersion = 2.14;
        requiredAddons[] = {"A3_Functions_F"};
        units[] = {};
        weapons[] = {};
    };
};

class CfgRemoteExec {
    class Functions {
        mode = 1;
        jip = 0;
        class RHD_fnc_harvestServer { allowedTargets = 2; jip = 0; };
        class RHD_fnc_refineServer { allowedTargets = 2; jip = 0; };
        class RHD_fnc_harvestResult { allowedTargets = 1; jip = 0; };
        class RHD_fnc_refineResult { allowedTargets = 1; jip = 0; };
        class RHD_fnc_setPrice { allowedTargets = 2; jip = 0; };
    };
    class Commands { mode = 0; jip = 0; };
};

class CfgFunctions {
    class RHD {
        tag = "RHD";
        class Core {
            file = "RHD_LifeServer\functions\core";
            class preInit { preInit = 1; };
            class postInit { postInit = 1; };
            class serverLoop {};
            class clientInit {};
            class log {};
        };
        class Economy {
            file = "RHD_LifeServer\functions\economy";
            class economyLoop {};
            class getPrice {};
            class setPrice {};
            class initPrices {};
        };
        class Population {
            file = "RHD_LifeServer\functions\population";
            class populationLoop {};
            class updatePopulation {};
            class cleanupPopulation {};
        };
        class Resources {
            file = "RHD_LifeServer\functions\resources";
            class registerNodes {};
            class getResourceConfig {};
            class harvestServer {};
            class harvestResult {};
            class refineServer {};
            class refineResult {};
        };
        class Contracts {
            file = "RHD_LifeServer\functions\contracts";
            class createContract {};
            class completeContract {};
        };
        class UI {
            file = "RHD_LifeServer\functions\ui";
            class initMenus { postInit = 1; };
            class menuAction {};
            class findNearbyResource {};
        };
        class Eden {
            file = "RHD_LifeServer\functions\eden";
            class moduleInit {};
            class applyConfig {};
        };
    };
};

class Cfg3DEN {
    class Mission {
        class Scenario {
            class RHD_LifeCore {
                displayName = "RHD LifeCore Configuration";
                class Attributes {
                    class farmingHarvestMin { displayName="Farming minimum harvest"; typeName="NUMBER"; defaultValue=2; expression="_this setVariable ['farmingHarvestMin',_value,true]"; };
                    class farmingHarvestMax { displayName="Farming maximum harvest"; typeName="NUMBER"; defaultValue=5; expression="_this setVariable ['farmingHarvestMax',_value,true]"; };
                    class miningHarvestMin { displayName="Mining minimum harvest"; typeName="NUMBER"; defaultValue=2; expression="_this setVariable ['miningHarvestMin',_value,true]"; };
                    class miningHarvestMax { displayName="Mining maximum harvest"; typeName="NUMBER"; defaultValue=6; expression="_this setVariable ['miningHarvestMax',_value,true]"; };
                    class civiliansAtOnePlayer { displayName="Civilians at one player"; typeName="NUMBER"; defaultValue=115; expression="_this setVariable ['civiliansAtOnePlayer',_value,true]"; };
                    class minimumCivilians { displayName="Minimum civilian population"; typeName="NUMBER"; defaultValue=60; expression="_this setVariable ['minimumCivilians',_value,true]"; };
                    class maximumCivilians { displayName="Maximum civilian population"; typeName="NUMBER"; defaultValue=115; expression="_this setVariable ['maximumCivilians',_value,true]"; };
                    class populationScaleWithPlayers { displayName="Scale civilians with players"; typeName="BOOL"; defaultValue=1; expression="_this setVariable ['populationScaleWithPlayers',_value,true]"; };
                    class harvestCooldown { displayName="Harvest cooldown (seconds)"; typeName="NUMBER"; defaultValue=2; expression="_this setVariable ['harvestCooldown',_value,true]"; };
                    class dynamicPricing { displayName="Enable dynamic pricing"; typeName="BOOL"; defaultValue=1; expression="_this setVariable ['dynamicPricing',_value,true]"; };
                };
            };
        };
    };
};

#include "config\RHD_Resources.hpp"
#include "config\RHD_Menus.hpp"
