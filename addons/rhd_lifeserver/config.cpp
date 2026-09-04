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
class CfgFactionClasses { class NO_CATEGORY; class RHD_LifeCore : NO_CATEGORY { displayName = "RHD LifeCore"; }; };
class CfgRemoteExec {
    class Functions {
        mode = 1; jip = 0;
        class RHD_fnc_harvestServer { allowedTargets = 2; jip = 0; };
        class RHD_fnc_refineServer { allowedTargets = 2; jip = 0; };
        class RHD_fnc_harvestResult { allowedTargets = 1; jip = 0; };
        class RHD_fnc_refineResult { allowedTargets = 1; jip = 0; };
        class RHD_fnc_setPrice { allowedTargets = 2; jip = 0; };
        class RHD_fnc_createContract { allowedTargets = 2; jip = 0; };
        class RHD_fnc_completeContract { allowedTargets = 2; jip = 0; };
        class RHD_fnc_contractResult { allowedTargets = 1; jip = 0; };
        class RHD_fnc_dispatch { allowedTargets = 2; jip = 0; };
        class RHD_fnc_dispatchResult { allowedTargets = 1; jip = 0; };
        class RHD_fnc_createEvidence { allowedTargets = 2; jip = 0; };
        class RHD_fnc_createWarrant { allowedTargets = 2; jip = 0; };
        class RHD_fnc_impoundVehicle { allowedTargets = 2; jip = 0; };
        class RHD_fnc_releaseImpound { allowedTargets = 2; jip = 0; };
        class RHD_fnc_createServiceRequest { allowedTargets = 2; jip = 0; };
        class RHD_fnc_manageLicense { allowedTargets = 2; jip = 0; };
        class RHD_fnc_getLicenses { allowedTargets = 2; jip = 0; };
        class RHD_fnc_business { allowedTargets = 2; jip = 0; };
        class RHD_fnc_hospitalBill { allowedTargets = 2; jip = 0; };
        class RHD_fnc_treatPlayer { allowedTargets = 2; jip = 0; };
        class RHD_fnc_vehicleService { allowedTargets = 2; jip = 0; };
        class RHD_fnc_rpResult { allowedTargets = 1; jip = 0; };
        class RHD_fnc_shopTransaction { allowedTargets = 2; jip = 0; };
        class RHD_fnc_rpAction { allowedTargets = 2; jip = 0; };
    };
    class Commands { mode = 0; jip = 0; };
};
class CfgFunctions {
    class RHD {
        tag = "RHD";
        class Core { file = "RHD_LifeServer\functions\core"; class preInit { preInit = 1; }; class postInit { postInit = 1; }; class serverLoop {}; class clientInit {}; class log {}; };
        class Economy { file = "RHD_LifeServer\functions\economy"; class economyLoop {}; class getPrice {}; class shopPrice {}; class setPrice {}; class initPrices {}; class recordMarket {}; class shopTransaction {}; class validateShopTransaction {}; class virtBuy {}; class virtSell {}; class virtUpdate {}; };
        class Population { file = "RHD_LifeServer\functions\population"; class populationLoop {}; class updatePopulation {}; class cleanupPopulation {}; };
        class Resources { file = "RHD_LifeServer\functions\resources"; class registerNodes {}; class getResourceConfig {}; class harvestServer {}; class harvestResult {}; class refineServer {}; class refineResult {}; };
        class Contracts { file = "RHD_LifeServer\functions\contracts"; class createContract {}; class completeContract {}; class contractResult {}; };
        class UI { file = "RHD_LifeServer\functions\ui"; class initMenus { postInit = 1; }; class menuAction {}; class findNearbyResource {}; };
        class Eden { file = "RHD_LifeServer\functions\eden"; class moduleInit {}; class applyConfig {}; };
        class Persistence { file = "RHD_LifeServer\functions\persistence"; class initPersistence {}; class loadState {}; class saveState {}; class persistenceLoop {}; };
        class RP { file = "RHD_LifeServer\functions\rp"; class initRP {}; class dispatch {}; class dispatchAction {}; class dispatchResult {}; class createEvidence {}; class createWarrant {}; class impoundVehicle {}; class releaseImpound {}; class createServiceRequest {}; class manageLicense {}; class getLicenses {}; class business {}; class hospitalBill {}; class treatPlayer {}; class vehicleService {}; class rpResult {}; class authorizeRole {}; class rpAction {}; class rpMaintenance {}; };
    };
};
class CfgVehicles {
    class Logic; class Module_F : Logic { class AttributesBase { class Edit; class Checkbox; class Combo; class ModuleDescription; }; class ModuleDescription {}; };
    class RHD_Module_LifeCore : Module_F {
        scope=2; displayName="RHD LifeCore Configuration"; category="RHD_LifeCore"; function="RHD_fnc_moduleInit"; isGlobal=1; isTriggerActivated=0; is3DEN=0;
        class Attributes : AttributesBase {
            class farmingHarvestMin : Edit { property="RHD_farmingHarvestMin"; displayName="Farming Minimum Harvest"; defaultValue="2"; typeName="NUMBER"; };
            class farmingHarvestMax : Edit { property="RHD_farmingHarvestMax"; displayName="Farming Maximum Harvest"; defaultValue="5"; typeName="NUMBER"; };
            class miningHarvestMin : Edit { property="RHD_miningHarvestMin"; displayName="Mining Minimum Harvest"; defaultValue="2"; typeName="NUMBER"; };
            class miningHarvestMax : Edit { property="RHD_miningHarvestMax"; displayName="Mining Maximum Harvest"; defaultValue="6"; typeName="NUMBER"; };
            class civiliansAtOnePlayer : Edit { property="RHD_civiliansAtOnePlayer"; displayName="Civilians at 1 Player"; defaultValue="115"; typeName="NUMBER"; };
            class minimumCivilians : Edit { property="RHD_minimumCivilians"; displayName="Minimum Civilians"; defaultValue="60"; typeName="NUMBER"; };
            class maximumCivilians : Edit { property="RHD_maximumCivilians"; displayName="Maximum Civilians"; defaultValue="115"; typeName="NUMBER"; };
            class populationScaleWithPlayers : Checkbox { property="RHD_populationScaleWithPlayers"; displayName="Scale Civilians With Players"; defaultValue="true"; typeName="BOOL"; };
            class harvestCooldown : Edit { property="RHD_harvestCooldown"; displayName="Harvest Cooldown (seconds)"; defaultValue="2"; typeName="NUMBER"; };
            class dynamicPricing : Checkbox { property="RHD_dynamicPricing"; displayName="Enable Dynamic Pricing"; defaultValue="true"; typeName="BOOL"; };
            class ModuleDescription : ModuleDescription {};
        };
        class ModuleDescription : ModuleDescription { description="Place exactly one RHD LifeCore Configuration module."; };
    };
    class RHD_Module_ResourceNode : Module_F {
        scope=2; displayName="RHD Resource Node"; category="RHD_LifeCore"; function="RHD_fnc_moduleInit"; isGlobal=1; isTriggerActivated=0; is3DEN=0;
        class Attributes : AttributesBase {
            class resourceType : Combo { property="RHD_resourceType"; displayName="Resource"; defaultValue="0"; typeName="NUMBER"; class values { class Apple {name="Apples";value=0;default=1;}; class Peach {name="Peaches";value=1;}; class Grape {name="Grapes";value=2;}; class Corn {name="Corn Cob";value=3;}; class Cannabis {name="Cannabis Plant";value=4;}; class Coca {name="Coca Leaf";value=5;}; class Iron {name="Iron Ore";value=6;}; class Copper {name="Copper Ore";value=7;}; class GoldOre {name="Gold Ore";value=8;}; class Diamond {name="Uncut Diamond";value=9;}; class OilSand {name="Oil Sand";value=10;}; }; };
            class minimumYield : Edit { property="RHD_minimumYield"; displayName="Minimum Yield"; defaultValue="2"; typeName="NUMBER"; };
            class maximumYield : Edit { property="RHD_maximumYield"; displayName="Maximum Yield"; defaultValue="5"; typeName="NUMBER"; };
            class nodeRadius : Edit { property="RHD_nodeRadius"; displayName="Interaction Radius (m)"; defaultValue="12"; typeName="NUMBER"; };
            class illegal : Checkbox { property="RHD_illegal"; displayName="Illegal Resource"; defaultValue="false"; typeName="BOOL"; };
            class enabled : Checkbox { property="RHD_enabled"; displayName="Enabled"; defaultValue="true"; typeName="BOOL"; };
            class ModuleDescription : ModuleDescription {};
        };
        class ModuleDescription : ModuleDescription { description="Place at a farming or mining location."; };
    };
    class RHD_Module_ProcessStation : Module_F {
        scope=2; displayName="RHD Processing Station"; category="RHD_LifeCore"; function="RHD_fnc_moduleInit"; isGlobal=1; isTriggerActivated=0; is3DEN=0;
        class Attributes : AttributesBase {
            class processClass : Edit { property="RHD_processClass"; displayName="ProcessAction Class"; defaultValue="iron"; typeName="STRING"; };
            class stationRadius : Edit { property="RHD_stationRadius"; displayName="Interaction Radius (m)"; defaultValue="12"; typeName="NUMBER"; };
            class enabled : Checkbox { property="RHD_enabled"; displayName="Enabled"; defaultValue="true"; typeName="BOOL"; };
            class ModuleDescription : ModuleDescription {};
        };
        class ModuleDescription : ModuleDescription { description="Place at a processing facility and enter the exact ProcessAction class."; };
    };
};
class CfgEditorCategories { class RHD_LifeCore { displayName="RHD LifeCore"; }; };
#include "config\RHD_LifeServer.hpp"
#include "config\RHD_Resources.hpp"
#include "config\RHD_RP.hpp"
#include "config\RHD_Menus.hpp"
