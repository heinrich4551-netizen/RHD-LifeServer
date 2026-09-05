# RHD-LifeServer — Antistasi Ultimate Integration

## Integration rule

RHD-LifeServer is the primary RP/economy/server layer. Its normal systems remain available to **every player and every faction**.

The Antistasi Ultimate compatibility layer is separate. Only the Antistasi-specific functions routed through `RHD_fnc_antistasiCall` are restricted to the **Independent** faction.

The check is:

- player/unit side must be `independent`;
- when Antistasi's `teamPlayer` variable exists, it must also be `independent`;
- server-side remote calls are resolved against the actual remote owner rather than trusting a player-supplied unit.

Changing faction causes the Antistasi integration access flag to update automatically. This does **not** disable RHD shops, economy, jobs, resources, RP, persistence, menus, or other RHD functionality.

## Antistasi functions exposed by the bridge

RHD consumes Antistasi Ultimate's installed A3A/A3U functions rather than modifying the Antistasi source. The bridge deliberately uses a whitelist instead of exposing an arbitrary client-controlled function executor.

The current compatibility whitelist is:

- `A3A_fnc_createUnit`
- `A3A_fnc_spawnGroup`
- `A3A_fnc_spawnVehicle`
- `A3A_fnc_revealToPlayer`
- `A3A_fnc_getVehicleSellPrice`
- `A3A_fnc_getAggroLevelString`
- `A3U_fnc_canInteract`
- `A3U_fnc_revealZone`
- `A3U_fnc_revealZones`
- `A3U_fnc_hasAddon`

`A3A_fnc_createUnit`, `A3A_fnc_spawnGroup`, and `A3A_fnc_spawnVehicle` are server-authoritative through the bridge. Their requested group/side/owner is validated as Independent before the original Antistasi function is called.

The bridge intentionally does **not** expose a generic `call`/function-name executor and does not expose internal Antistasi administration, economy, AI-control, persistence, or server-management functions.

## Standalone behavior

Antistasi Ultimate is optional from the RHD PBO's `CfgPatches` dependency list. If Antistasi is not loaded, RHD-LifeServer continues to operate normally and the Antistasi bridge remains unavailable.

## Attribution and licensing

The Antistasi integration is intended to respect the original project and its license. Antistasi Ultimate, Antistasi Plus, and Antistasi Community Edition components retain their original authorship and licensing. RHD does not claim those projects or their source as RHD work.

Where an Antistasi component has a separate license, that license remains controlling for that component. RHD's compatibility layer does not modify those source files.

Antistasi Ultimate is credited to the Antistasi Ultimate Team. The upstream lineage also credits Socrates, Barbolani, and the Official Antistasi Community.

## RHD principle

**RHD functionality: everyone.**

**Antistasi-specific integration: Independent only.**
