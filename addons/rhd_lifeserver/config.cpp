class CfgPatches {
    class RHD_LifeServer {
        name = "RHD LifeServer";
        author = "LT. Toad";
        requiredVersion = 2.14;
        requiredAddons[] = {"A3_Functions_F", "A3_Modules_F", "sp_general", "sp_entities"};
        units[] = {"RHD_Module_LifeCore", "RHD_Module_ResourceNode", "RHD_Module_ProcessStation"};
        weapons[] = {};
    };
};

class CfgFactionClasses {
    class NO_CATEGORY;
    class RHD_LifeCore : NO_CATEGORY { displayName = "RHD LifeCore"; };
};

class CfgRemoteExec {
    class Functions {
        mode = 1;
        jip = 0;
        class RHD_fnc_harvestServer { allowedTargets = 2; jip = 0; };
        class RHD_fnc_refineServer { allowedTargets = 2; jip = 0; };
        class RHD_fnc_harvestResult { allowedTargets = 1; jip = 0; };
        class RHD_fnc_refineResult { allowedTargets = 1; jip = 0; };
        class RHD_fnc_jobResult { allowedTargets = 1; jip = 0; };
        class RHD_fnc_hcPopulationUpdate { allowedTargets = 1; jip = 0; };
        class RHD_fnc_createContract { allowedTargets = 2; jip = 0; };
        class RHD_fnc_completeContract { allowedTargets = 2; jip = 0; };
        class RHD_fnc_contractCompleteAck { allowedTargets = 2; jip = 0; };
        class RHD_fnc_contractResult { allowedTargets = 1; jip = 0; };
        class RHD_fnc_dispatch { allowedTargets = 2; jip = 0; };
        class RHD_fnc_dispatchResult { allowedTargets = 1; jip = 0; };
        class RHD_fnc_createServiceRequest { allowedTargets = 2; jip = 0; };
        class RHD_fnc_getLicenses { allowedTargets = 2; jip = 0; };
        class RHD_fnc_rpResult { allowedTargets = 1; jip = 0; };
        class RHD_fnc_financialResult { allowedTargets = 1; jip = 0; };
        class RHD_fnc_playerTransfer { allowedTargets = 2; jip = 0; };
        class RHD_fnc_playerTransferResult { allowedTargets = 1; jip = 0; };
        class RHD_fnc_shopTransaction { allowedTargets = 2; jip = 0; };
        class RHD_fnc_rpAction { allowedTargets = 2; jip = 0; };
        class RHD_fnc_phone { allowedTargets = 2; jip = 0; };
        class RHD_fnc_marketplace { allowedTargets = 2; jip = 0; };
        class RHD_fnc_marketplaceResult { allowedTargets = 1; jip = 0; };
        class RHD_fnc_governmentInfo { allowedTargets = 2; jip = 0; };
        class RHD_fnc_courtCase { allowedTargets = 2; jip = 0; };
        class RHD_fnc_worldEventResult { allowedTargets = 1; jip = 0; };
        class RHD_fnc_antistasiCall { allowedTargets = 2; jip = 0; };
    };
    class Commands { mode = 0; jip = 0; };
};

class CfgFunctions {
    class RHD {
        tag = "RHD";
        class Core { file = "RHD_LifeServer\functions\core"; class preInit { preInit = 1; }; class postInit { postInit = 1; }; class serverLoop {}; class clientInit {}; class log {}; };
        class Economy { file = "RHD_LifeServer\functions\economy"; class economyLoop {}; class getPrice {}; class shopPrice {}; class setPrice {}; class initPrices {}; class recordMarket {}; class shopTransaction {}; class validateShopTransaction {}; class virtBuy {}; class virtSell {}; class virtUpdate {}; class economyDashboard {}; };
        class Population { file = "RHD_LifeServer\functions\population"; class populationLoop {}; class updatePopulation {}; class cleanupPopulation {}; };
        class Resources { file = "RHD_LifeServer\functions\resources"; class registerNodes {}; class getResourceConfig {}; class harvestServer {}; class harvestResult {}; class refineServer {}; class refineResult {}; };
        class Jobs { file = "RHD_LifeServer\functions\jobs"; class jobProgress {}; class jobResult {}; };
        class HeadlessClient { file = "RHD_LifeServer\functions\headless"; class hcInit { postInit = 1; }; class hcPopulationUpdate {}; };
        class Contracts { file = "RHD_LifeServer\functions\contracts"; class createContract {}; class completeContract {}; class contractCompleteAck {}; class contractResult {}; };
        class UI { file = "RHD_LifeServer\functions\ui"; class initMenus { postInit = 1; }; class menuAction {}; class findNearbyResource {}; };
        class Eden { file = "RHD_LifeServer\functions\eden"; class moduleInit {}; class applyConfig {}; };
        class Persistence { file = "RHD_LifeServer\functions\persistence"; class initPersistence {}; class loadState {}; class saveState {}; class persistenceLoop {}; };
        class Antistasi { file = "RHD_LifeServer\functions\antistasi"; class antistasiInit { postInit = 1; }; class antistasiCall {}; };
        class RP {
            file = "RHD_LifeServer\functions\rp";
            class initRP {}; class dispatch {}; class dispatchAction {}; class dispatchResult {}; class createEvidence {}; class createWarrant {};
            class impoundVehicle {}; class releaseImpound {}; class releaseImpoundByVehicle {}; class getImpounds {}; class createServiceRequest {};
            class manageLicense {}; class getLicenses {}; class business {}; class businessCreate {}; class businessInfo {}; class businessTransaction {};
            class hospitalBill {}; class treatPlayer {}; class vehicleService {}; class rpResult {}; class financialTransaction {}; class financialResult {};
            class playerTransfer {}; class playerTransferResult {}; class taxTransaction {}; class governmentInfo {}; class courtCase {}; class phone {}; class marketplace {}; class marketplaceRecover {}; class marketplaceResult {};
            class worldEvents {}; class worldEventResult {}; class adminAudit {};
            class authorizeRole {}; class rpAction {}; class rpMaintenance {};
        };
    };
};

class CfgVehicles {
    class Logic;
    class Module_F : Logic {
        class AttributesBase {
            class Edit {};
            class Checkbox {};
            class Combo {};
            class ModuleDescription {};
        };
        class ModuleDescription {};
    };

    class RHD_Module_LifeCore : Module_F {
        scope = 2;
        scopeCurator = 2;
        displayName = "RHD LifeCore Configuration";
        icon = "iconObject_circle";
        category = "RHD_LifeCore";
        function = "RHD_fnc_moduleInit";
        functionPriority = 1;
        isGlobal = 1;
        isTriggerActivated = 0;
        isDisposable = 0;
        is3DEN = 1;
        class Attributes : AttributesBase {
            class RHD_farmingEnabled : Checkbox {
                property = "RHD_farmingEnabled";
                displayName = "Farming Enabled";
                tooltip = "Enable RHD farming resource harvesting.";
                typeName = "BOOL";
                defaultValue = "true";
                expression = "_this setVariable ['RHD_farmingEnabled',_value,true]";
            };
            class RHD_farmingHarvestMin : Edit {
                property = "RHD_farmingHarvestMin";
                displayName = "Farming Minimum Yield";
                tooltip = "Minimum amount awarded from farming nodes.";
                typeName = "NUMBER";
                defaultValue = "2";
                expression = "_this setVariable ['RHD_farmingHarvestMin',_value,true]";
            };
            class RHD_farmingHarvestMax : Edit {
                property = "RHD_farmingHarvestMax";
                displayName = "Farming Maximum Yield";
                tooltip = "Maximum amount awarded from farming nodes.";
                typeName = "NUMBER";
                defaultValue = "5";
                expression = "_this setVariable ['RHD_farmingHarvestMax',_value,true]";
            };
            class RHD_miningEnabled : Checkbox {
                property = "RHD_miningEnabled";
                displayName = "Mining Enabled";
                tooltip = "Enable RHD mining resource harvesting.";
                typeName = "BOOL";
                defaultValue = "true";
                expression = "_this setVariable ['RHD_miningEnabled',_value,true]";
            };
            class RHD_miningHarvestMin : Edit {
                property = "RHD_miningHarvestMin";
                displayName = "Mining Minimum Yield";
                tooltip = "Minimum amount awarded from mining nodes.";
                typeName = "NUMBER";
                defaultValue = "2";
                expression = "_this setVariable ['RHD_miningHarvestMin',_value,true]";
            };
            class RHD_miningHarvestMax : Edit {
                property = "RHD_miningHarvestMax";
                displayName = "Mining Maximum Yield";
                tooltip = "Maximum amount awarded from mining nodes.";
                typeName = "NUMBER";
                defaultValue = "6";
                expression = "_this setVariable ['RHD_miningHarvestMax',_value,true]";
            };
            class RHD_harvestCooldown : Edit {
                property = "RHD_harvestCooldown";
                displayName = "Harvest Cooldown (seconds)";
                tooltip = "Minimum delay between successful harvest actions.";
                typeName = "NUMBER";
                defaultValue = "2";
                expression = "_this setVariable ['RHD_harvestCooldown',_value,true]";
            };
            class RHD_civiliansAtOnePlayer : Edit {
                property = "RHD_civiliansAtOnePlayer";
                displayName = "Civilians at 1 Player";
                tooltip = "Target global civilian population with one active player.";
                typeName = "NUMBER";
                defaultValue = "115";
                expression = "_this setVariable ['RHD_civiliansAtOnePlayer',_value,true]";
            };
            class RHD_minimumCivilians : Edit {
                property = "RHD_minimumCivilians";
                displayName = "Minimum Civilians";
                tooltip = "Lowest global civilian population target.";
                typeName = "NUMBER";
                defaultValue = "60";
                expression = "_this setVariable ['RHD_minimumCivilians',_value,true]";
            };
            class RHD_maximumCivilians : Edit {
                property = "RHD_maximumCivilians";
                displayName = "Maximum Civilians";
                tooltip = "Highest global civilian population target.";
                typeName = "NUMBER";
                defaultValue = "115";
                expression = "_this setVariable ['RHD_maximumCivilians',_value,true]";
            };
            class RHD_populationScaleWithPlayers : Checkbox {
                property = "RHD_populationScaleWithPlayers";
                displayName = "Scale Population With Players";
                tooltip = "Reduce the civilian target as more players become active.";
                typeName = "BOOL";
                defaultValue = "true";
                expression = "_this setVariable ['RHD_populationScaleWithPlayers',_value,true]";
            };
            class RHD_useHeadlessClient : Checkbox {
                property = "RHD_useHeadlessClient";
                displayName = "Use Headless Client for Civilians";
                tooltip = "Route civilian population management to a connected Headless Client when available.";
                typeName = "BOOL";
                defaultValue = "true";
                expression = "_this setVariable ['RHD_useHeadlessClient',_value,true]";
            };
            class RHD_hcSpawnBatch : Edit {
                property = "RHD_hcSpawnBatch";
                displayName = "HC Population Spawn Batch";
                tooltip = "Maximum civilian spawn batch sent to the Headless Client per population update.";
                typeName = "NUMBER";
                defaultValue = "12";
                expression = "_this setVariable ['RHD_hcSpawnBatch',_value,true]";
            };
            class RHD_civilianDespawnDistance : Edit {
                property = "RHD_civilianDespawnDistance";
                displayName = "Civilian Despawn Distance";
                tooltip = "Distance used by the civilian population manager when cleaning up agents.";
                typeName = "NUMBER";
                defaultValue = "2500";
                expression = "_this setVariable ['RHD_civilianDespawnDistance',_value,true]";
            };
            class RHD_dynamicPricing : Checkbox {
                property = "RHD_dynamicPricing";
                displayName = "Dynamic Pricing";
                tooltip = "Enable RHD dynamic market pricing.";
                typeName = "BOOL";
                defaultValue = "true";
                expression = "_this setVariable ['RHD_dynamicPricing',_value,true]";
            };
            class RHD_persistenceEnabled : Checkbox {
                property = "RHD_persistenceEnabled";
                displayName = "Persistence Enabled";
                tooltip = "Enable RHD persistent state integration.";
                typeName = "BOOL";
                defaultValue = "true";
                expression = "_this setVariable ['RHD_persistenceEnabled',_value,true]";
            };
            class RHD_worldEventsEnabled : Checkbox {
                property = "RHD_worldEventsEnabled";
                displayName = "World Events Enabled";
                tooltip = "Enable RHD random world events such as market booms and civilian alerts.";
                typeName = "BOOL";
                defaultValue = "true";
                expression = "_this setVariable ['RHD_worldEventsEnabled',_value,true]";
            };
        };
        class ModuleDescription : ModuleDescription {};
    };

    class RHD_Module_ResourceNode : Module_F {
        scope = 2;
        scopeCurator = 2;
        displayName = "RHD Resource Node";
        icon = "iconObject_circle";
        category = "RHD_LifeCore";
        function = "RHD_fnc_moduleInit";
        functionPriority = 2;
        isGlobal = 1;
        isTriggerActivated = 0;
        isDisposable = 0;
        is3DEN = 1;
        class Attributes : AttributesBase {
            class RHD_resourceType : Combo {
                property = "RHD_resourceType";
                displayName = "Resource Type";
                tooltip = "Select the resource harvested at this node.";
                typeName = "NUMBER";
                defaultValue = "0";
                expression = "_this setVariable ['RHD_resourceType',_value,true]";
                class values {
                    class Apples { name = "Apples"; value = 0; };
                    class Peaches { name = "Peaches"; value = 1; };
                    class Grapes { name = "Grapes"; value = 2; };
                    class CornCob { name = "Corn Cob"; value = 3; };
                    class CannabisPlant { name = "Cannabis Plant"; value = 4; };
                    class CocaLeaf { name = "Coca Leaf"; value = 5; };
                    class IronOre { name = "Iron Ore"; value = 6; };
                    class CopperOre { name = "Copper Ore"; value = 7; };
                    class GoldOre { name = "Gold Ore"; value = 8; };
                    class Diamond { name = "Diamond"; value = 9; };
                    class OilSand { name = "Oil Sand"; value = 10; };
                };
            };
            class RHD_minimumYield : Edit {
                property = "RHD_minimumYield";
                displayName = "Minimum Yield";
                tooltip = "Minimum amount awarded by this node.";
                typeName = "NUMBER";
                defaultValue = "2";
                expression = "_this setVariable ['RHD_minimumYield',_value,true]";
            };
            class RHD_maximumYield : Edit {
                property = "RHD_maximumYield";
                displayName = "Maximum Yield";
                tooltip = "Maximum amount awarded by this node.";
                typeName = "NUMBER";
                defaultValue = "5";
                expression = "_this setVariable ['RHD_maximumYield',_value,true]";
            };
            class RHD_nodeRadius : Edit {
                property = "RHD_nodeRadius";
                displayName = "Node Radius";
                tooltip = "Interaction radius around this resource node.";
                typeName = "NUMBER";
                defaultValue = "12";
                expression = "_this setVariable ['RHD_nodeRadius',_value,true]";
            };
            class RHD_illegal : Checkbox {
                property = "RHD_illegal";
                displayName = "Illegal Resource";
                tooltip = "Mark this resource as illegal for RP enforcement and job logic.";
                typeName = "BOOL";
                defaultValue = "false";
                expression = "_this setVariable ['RHD_illegal',_value,true]";
            };
            class RHD_enabled : Checkbox {
                property = "RHD_enabled";
                displayName = "Enabled";
                tooltip = "Enable this resource node in the mission.";
                typeName = "BOOL";
                defaultValue = "true";
                expression = "_this setVariable ['RHD_enabled',_value,true]";
            };
        };
        class ModuleDescription : ModuleDescription {};
    };

    class RHD_Module_ProcessStation : Module_F {
        scope = 2;
        scopeCurator = 2;
        displayName = "RHD Processing Station";
        icon = "iconObject_circle";
        category = "RHD_LifeCore";
        function = "RHD_fnc_moduleInit";
        functionPriority = 3;
        isGlobal = 1;
        isTriggerActivated = 0;
        isDisposable = 0;
        is3DEN = 1;
        class Attributes : AttributesBase {
            class RHD_processClass : Combo {
                property = "RHD_processClass";
                displayName = "Process Class";
                tooltip = "Select the material processed at this station.";
                typeName = "STRING";
                defaultValue = "\"iron\"";
                expression = "_this setVariable ['RHD_processClass',_value,true]";
                class values {
                    class Iron { name = "Iron Ore -> Iron"; value = "iron"; };
                    class Copper { name = "Copper Ore -> Copper"; value = "copper"; };
                    class Gold { name = "Gold Ore -> Gold"; value = "gold"; };
                    class Oil { name = "Oil Sand -> Fuel/Oil"; value = "oil"; };
                    class Diamond { name = "Uncut Diamond -> Diamond"; value = "diamond"; };
                    class Cannabis { name = "Cannabis -> Marijuana"; value = "cannabis"; };
                };
            };
            class RHD_stationRadius : Edit {
                property = "RHD_stationRadius";
                displayName = "Station Radius";
                tooltip = "Interaction radius around this processing station.";
                typeName = "NUMBER";
                defaultValue = "12";
                expression = "_this setVariable ['RHD_stationRadius',_value,true]";
            };
            class RHD_enabled : Checkbox {
                property = "RHD_enabled";
                displayName = "Enabled";
                tooltip = "Enable this processing station in the mission.";
                typeName = "BOOL";
                defaultValue = "true";
                expression = "_this setVariable ['RHD_enabled',_value,true]";
            };
        };
        class ModuleDescription : ModuleDescription {};
    };
};

class CfgEditorCategories {
    class RHD_LifeCore {
        displayName = "RHD LifeCore";
    };
};

#include "config\RHD_LifeServer.hpp"
#include "config\RHD_Resources.hpp"
#include "config\RHD_RP.hpp"
#include "config\RHD_Menus.hpp"
