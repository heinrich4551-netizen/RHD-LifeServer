# RHD-LifeServer Steam Workshop Dependencies

## Dependency policy

RHD-LifeServer is designed to run with **no mandatory third-party Steam Workshop mod dependency**. Its required runtime components are Arma 3 itself, the Altis map, the upstream AsYetUntitled Framework mission/submodule, and the database adapter used by that mission.

The upstream Framework is a separate Git submodule and is **not** a Steam Workshop dependency.

This manifest supports up to **25 Steam Workshop dependencies** so future RHD integrations can declare dependencies without changing the deployment format.

## Required Workshop dependencies

| Slot | Mod | Steam Workshop ID | Required |
|---:|---|---|---|
| 1 | None | — | No |

## Optional Workshop dependencies

| Slot | Mod | Steam Workshop ID | Required |
|---:|---|---|---|
| 1 | Reserved | — | No |
| 2 | Reserved | — | No |
| 3 | Reserved | — | No |
| 4 | Reserved | — | No |
| 5 | Reserved | — | No |
| 6 | Reserved | — | No |
| 7 | Reserved | — | No |
| 8 | Reserved | — | No |
| 9 | Reserved | — | No |
| 10 | Reserved | — | No |
| 11 | Reserved | — | No |
| 12 | Reserved | — | No |
| 13 | Reserved | — | No |
| 14 | Reserved | — | No |
| 15 | Reserved | — | No |
| 16 | Reserved | — | No |
| 17 | Reserved | — | No |
| 18 | Reserved | — | No |
| 19 | Reserved | — | No |
| 20 | Reserved | — | No |
| 21 | Reserved | — | No |
| 22 | Reserved | — | No |
| 23 | Reserved | — | No |
| 24 | Reserved | — | No |
| 25 | Reserved | — | No |

## Why the list is currently empty

The current RHD addon only declares Arma 3 engine dependencies through `CfgPatches` (`A3_Functions_F` and `A3_Modules_F`). Adding unrelated Workshop mods would turn optional integrations into unnecessary server requirements.

When a future RHD feature genuinely requires a Workshop mod, add the exact Workshop item name and numeric ID here and update the server/client startup documentation at the same time.

## Antistasi Ultimate

Antistasi Ultimate is treated as a mission/gameplay integration rather than a mandatory RHD Workshop dependency. RHD should remain loadable without Antistasi so Altis Life RP and Antistasi deployments can share the same RHD overlay where the integration path supports it.

## Installation rule

Only dependencies marked **Required = Yes** should be placed in a production server's mandatory `-mod=`/launcher dependency set. Optional integrations must not be hard requirements for the base RHD-LifeServer addon.
