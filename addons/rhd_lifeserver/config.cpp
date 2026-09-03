class CfgPatches {
    class RHD_LifeServer {
        name = "RHD LifeServer";
        author = "LT. Toad";
        requiredVersion = 2.14;
        requiredAddons[] = {"A3_Functions_F", "A3_Modules_F"};
        units[] = {"RHD_Module_LifeCore", "RHD_Module_ResourceNode", "RHD_Module_ProcessStation"};
        weapons[] = {};
    };
};

class CfgFactionClasses {
    class NO_CATEGORY;
    class RHD_LifeCore : NO_CATEGORY {
        displayName = "RHD LifeCore";
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

class CfgVehicles {
    class Logic;
    class Module_F : Logic {
        class AttributesBase {
            class Edit;
            class Checkbox;
            class Combo;
            class ModuleDescription;
        };
        class ModuleDescription {};
    };

    class RHD_Module_LifeCore : Module_F {
        scope = 2;
        displayName = "RHD LifeCore Configuration";
        category = "RHD_LifeCore";
        function = "RHD_fnc_moduleInit";
        isGlobal = 1;
        isTriggerActivated = 0;
        is3DEN = 0;

        class Attributes : AttributesBase {
            class farmingHarvestMin : Edit {
                property = "RHD_farmingHarvestMin";
                displayName = "Farming Minimum Harvest";
                tooltip = "Minimum quantity awarded from farming nodes.";
                defaultValue = "2";
                typeName = "NUMBER";
            };
            class farmingHarvestMax : Edit {
                property = "RHD_farmingHarvestMax";
                displayName = "Farming Maximum Harvest";
                tooltip = "Maximum quantity awarded from farming nodes.";
                defaultValue = "5";
                typeName = "NUMBER";
            };
            class miningHarvestMin : Edit {
                property = "RHD_miningHarvestMin";
                displayName = "Mining Minimum Harvest";
                tooltip = "Minimum quantity awarded from mining nodes.";
                defaultValue = "2";
                typeName = "NUMBER";
            };
            class miningHarvestMax : Edit {
                property = "RHD_miningHarvestMax";
                displayName = "Mining Maximum Harvest";
                tooltip = "Maximum quantity awarded from mining nodes.";
                defaultValue = "6";
                typeName = "NUMBER";
            };
            class civiliansAtOnePlayer : Edit {
                property = "RHD_civiliansAtOnePlayer";
                displayName = "Civilians at 1 Player";
                tooltip = "Target global civilian population when one player is active.";
                defaultValue = "115";
                typeName = "NUMBER";
            };
            class minimumCivilians : Edit {
                property = "RHD_minimumCivilians";
                displayName = "Minimum Civilians";
                tooltip = "Lowest global civilian population allowed as player count increases.";
                defaultValue = "60";
                typeName = "NUMBER";
            };
            class maximumCivilians : Edit {
                property = "RHD_maximumCivilians";
                displayName = "Maximum Civilians";
                tooltip = "Upper cap for the global civilian population.";
                defaultValue = "115";
                typeName = "NUMBER";
            };
            class populationScaleWithPlayers : Checkbox {
                property = "RHD_populationScaleWithPlayers";
                displayName = "Scale Civilians With Players";
                defaultValue = "true";
                typeName = "BOOL";
            };
            class harvestCooldown : Edit {
                property = "RHD_harvestCooldown";
                displayName = "Harvest Cooldown (seconds)";
                defaultValue = "2";
                typeName = "NUMBER";
            };
            class dynamicPricing : Checkbox {
                property = "RHD_dynamicPricing";
                displayName = "Enable Dynamic Pricing";
                defaultValue = "true";
                typeName = "BOOL";
            };
            class ModuleDescription : ModuleDescription {};
        };
        class ModuleDescription : ModuleDescription {
            description = "Place exactly one RHD LifeCore Configuration module. Configure farming/mining yields, global civilian population, harvest cooldown and dynamic pricing here.";
        };
    };

    class RHD_Module_ResourceNode : Module_F {
        scope = 2;
        displayName = "RHD Resource Node";
        category = "RHD_LifeCore";
        function = "RHD_fnc_moduleInit";
        isGlobal = 1;
        isTriggerActivated = 0;
        is3DEN = 0;
        icon = "\A3\ui_f\data\map\markers\military\unknown_ca.paa";

        class Attributes : AttributesBase {
            class resourceType : Combo {
                property = "RHD_resourceType";
                displayName = "Resource";
                tooltip = "Virtual item produced by this node.";
                defaultValue = "0";
                typeName = "NUMBER";
                class values {
                    class Apple {name="Apples"; value=0; default=1;};
                    class Peach {name="Peaches"; value=1;};
                    class Cannabis {name="Cannabis Plant"; value=2;};
                    class Coca {name="Coca Leaf"; value=3;};
                    class Iron {name="Iron Ore"; value=4;};
                    class Copper {name="Copper Ore"; value=5;};
                    class Gold {name="Gold"; value=6;};
                    class Diamond {name="Uncut Diamond"; value=7;};
                    class Oil {name="Oil Sand / Unprocessed Oil"; value=8;};
                };
            };
            class minimumYield : Edit {
                property = "RHD_minimumYield";
                displayName = "Minimum Yield";
                defaultValue = "2";
                typeName = "NUMBER";
            };
            class maximumYield : Edit {
                property = "RHD_maximumYield";
                displayName = "Maximum Yield";
                defaultValue = "5";
                typeName = "NUMBER";
            };
            class nodeRadius : Edit {
                property = "RHD_nodeRadius";
                displayName = "Interaction Radius (m)";
                defaultValue = "12";
                typeName = "NUMBER";
            };
            class illegal : Checkbox {
                property = "RHD_illegal";
                displayName = "Illegal Resource";
                defaultValue = "false";
                typeName = "BOOL";
            };
            class enabled : Checkbox {
                property = "RHD_enabled";
                displayName = "Enabled";
                defaultValue = "true";
                typeName = "BOOL";
            };
            class ModuleDescription : ModuleDescription {};
        };
        class ModuleDescription : ModuleDescription {
            description = "Place this directly at a farming or mining location. No map marker is required. The module position becomes the server-authoritative harvest node.";
        };
    };

    class RHD_Module_ProcessStation : Module_F {
        scope = 2;
        displayName = "RHD Processing Station";
        category = "RHD_LifeCore";
        function = "RHD_fnc_moduleInit";
        isGlobal = 1;
        isTriggerActivated = 0;
        is3DEN = 0;
        icon = "\A3\ui_f\data\map\markers\military\unknown_ca.paa";

        class Attributes : AttributesBase {
            class processClass : Edit {
                property = "RHD_processClass";
                displayName = "ProcessAction Class";
                tooltip = "Exact ProcessAction class from the mission, e.g. iron, copper, diamond, oil, marijuana or cocaine.";
                defaultValue = "iron";
                typeName = "STRING";
            };
            class stationRadius : Edit {
                property = "RHD_stationRadius";
                displayName = "Interaction Radius (m)";
                defaultValue = "12";
                typeName = "NUMBER";
            };
            class enabled : Checkbox {
                property = "RHD_enabled";
                displayName = "Enabled";
                defaultValue = "true";
                typeName = "BOOL";
            };
            class ModuleDescription : ModuleDescription {};
        };
        class ModuleDescription : ModuleDescription {
            description = "Place this at a processing facility and enter the exact ProcessAction class. Processing is validated server-side against the mission recipe.";
        };
    };
};

class CfgEditorCategories {
    class RHD_LifeCore {
        displayName = "RHD LifeCore";
    };
};

#include "config\RHD_Resources.hpp"
#include "config\RHD_Menus.hpp"
