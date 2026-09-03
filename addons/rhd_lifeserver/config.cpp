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
        class RHD_fnc_setPrice { allowedTargets = 2; jip = 0; };
    };
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
            class harvestServer {};
            class harvestResult {};
            class refineServer {};
        };
        class Contracts {
            file = "RHD_LifeServer\functions\contracts";
            class createContract {};
            class completeContract {};
        };
        class UI {
            file = "RHD_LifeServer\functions\ui";
            class initMenus { postInit = 1; };
        };
    };
};

#include "config\RHD_Resources.hpp"
#include "config\RHD_Menus.hpp"
