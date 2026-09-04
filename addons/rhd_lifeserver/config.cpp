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
        class Contracts { file = "RHD_LifeServer\functions\contracts"; class createContract {}; class completeContract {}; class contractCompleteAck {}; class contractResult {}; };
        class UI { file = "RHD_LifeServer\functions\ui"; class initMenus { postInit = 1; }; class menuAction {}; class findNearbyResource {}; };
        class Eden { file = "RHD_LifeServer\functions\eden"; class moduleInit {}; class applyConfig {}; };
        class Persistence { file = "RHD_LifeServer\functions\persistence"; class initPersistence {}; class loadState {}; class saveState {}; class persistenceLoop {}; };
        class RP {
            file = "RHD_LifeServer\functions\rp";
            class initRP {}; class dispatch {}; class dispatchAction {}; class dispatchResult {}; class createEvidence {}; class createWarrant {};
            class impoundVehicle {}; class releaseImpound {}; class releaseImpoundByVehicle {}; class getImpounds {}; class createServiceRequest {};
            class manageLicense {}; class getLicenses {}; class business {}; class businessCreate {}; class businessInfo {}; class businessTransaction {};
            class hospitalBill {}; class treatPlayer {}; class vehicleService {}; class rpResult {}; class financialTransaction {}; class financialResult {};
            class playerTransfer {}; class playerTransferResult {}; class taxTransaction {}; class governmentInfo {}; class courtCase {}; class phone {}; class marketplace {}; class marketplaceResult {};
            class worldEvents {}; class worldEventResult {}; class adminAudit {};
            class authorizeRole {}; class rpAction {}; class rpMaintenance {};
        };
    };
};
class CfgVehicles {
    class Logic; class Module_F : Logic { class AttributesBase { class Edit; class Checkbox; class Combo; class ModuleDescription; }; class ModuleDescription {}; };
    class RHD_Module_LifeCore : Module_F { scope=2; displayName="RHD LifeCore Configuration"; category="RHD_LifeCore"; function="RHD_fnc_moduleInit"; isGlobal=1; isTriggerActivated=0; is3DEN=0; };
    class RHD_Module_ResourceNode : Module_F { scope=2; displayName="RHD Resource Node"; category="RHD_LifeCore"; function="RHD_fnc_moduleInit"; isGlobal=1; isTriggerActivated=0; };
    class RHD_Module_ProcessStation : Module_F { scope=2; displayName="RHD Processing Station"; category="RHD_LifeCore"; function="RHD_fnc_moduleInit"; isGlobal=1; isTriggerActivated=0; };
};
class CfgEditorCategories { class RHD_LifeCore { displayName="RHD LifeCore"; }; };
#include "config\RHD_LifeServer.hpp"
#include "config\RHD_Resources.hpp"
#include "config\RHD_RP.hpp"
#include "config\RHD_Menus.hpp"
