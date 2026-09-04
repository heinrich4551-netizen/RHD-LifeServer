# RHD custom layer

Keep new gameplay code here instead of editing `framework/AsYetUntitled-Framework` directly.

## Mission configuration integration

RHD-LifeServer is an addon overlay. The upstream Framework remains a separate submodule. For the additional RHD virtual items and processing recipes, add these fragments to the **mission** configuration used by your Altis Life Framework mission:

```cpp
// Config_vItems.hpp
#include "..\..\custom\RHD_vItems.hpp"

// Config_Process.hpp
#include "..\..\custom\RHD_ProcessAction.hpp"
```

Adjust the relative path to match your mission folder layout. The files must ultimately be inside the mission or otherwise be available to the Arma preprocessor; an addon PBO cannot make new classes appear in `missionConfigFile` after the mission has already been compiled.

The additional RHD item classes are:

- `grape` — Grapes
- `corn` — Corn Cob
- `coca_leaf` — Coca Leaf
- `gold_ore` — Gold Ore
- `gold` — Gold
- `oil_sand` — Oil Sand

Existing upstream items such as `apple`, `peach`, `cannabis`, `iron_unrefined`, `copper_unrefined` and `diamond_uncut` remain upstream-owned.

## Implemented RHD systems

- `farming` — apples, peaches, grapes, corn, cannabis and coca harvesting
- `mining` — iron, copper, gold ore, diamonds and oil sand
- `refining` — iron, copper, cannabis, coca, gold ore and oil-sand processing
- `economy` — bounded dynamic pricing
- `shop integration` — the standard Framework virtual-shop callbacks are replaced at runtime by RHD market-aware buy, sell and list handlers without modifying the upstream submodule
- `contracts` — server-generated delivery contracts
- `population` — adaptive civilian density
- `services` — RHD integration points for vehicle and emergency systems

## Dynamic shop integration

The standard Framework shop dialog remains in use. RHD installs its handlers from `functions/core/fn_clientInit.sqf` after the Framework shop functions are available.

- Buy prices use the live RHD market price for tracked resources.
- Sell prices use the live RHD market price multiplied by `shopSellMultiplier`.
- Non-RHD virtual items fall back to their normal `VirtualItems` prices.
- Buy transactions add demand telemetry.
- Sell transactions add supply telemetry.
- Shop lists display the current effective prices.

Default economy settings are:

```cpp
shopBuyMultiplier = 1.00;
shopSellMultiplier = 0.80;
```

These values are configured in `config/RHD_LifeServer.hpp`.

## 3DEN

Use the **RHD LifeCore** category:

1. Place one **RHD LifeCore Configuration** module.
2. Place **RHD Resource Node** modules at farming/mining locations.
3. Set each node's resource, yield, radius, illegal flag and enabled state.
4. Place **RHD Processing Station** modules at processing facilities.
5. Set the station's exact `ProcessAction` class.

No RHD map markers are required. Legacy `rhd_resource_*` and `rhd_process_*` markers remain supported.
