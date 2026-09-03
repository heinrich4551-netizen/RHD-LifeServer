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
            class harvest {};
            class refine {};
        };
        class Contracts {
            file = "RHD_LifeServer\functions\contracts";
            class createContract {};
            class completeContract {};
        };
    };
};
