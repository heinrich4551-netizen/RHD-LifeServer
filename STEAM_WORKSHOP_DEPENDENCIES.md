# RHD-LifeServer Steam Workshop Dependencies

## Dependency policy

RHD-LifeServer uses Steam Workshop dependencies only when a feature has a genuine runtime requirement. The dependency list supports up to **25 Steam Workshop entries**.

## Required Workshop dependencies

| Slot | Mod | Steam Workshop ID | Required | Purpose |
|---:|---|---:|:---:|---|
| 1 | **SimplePersist** | **3006691432** | **Yes** | Player persistence integration: loadout, health and position |

Workshop page: https://steamcommunity.com/sharedfiles/filedetails/?id=3006691432

## SimplePersist attribution and license

RHD-LifeServer integrates with **SimplePersist** by **Tom Daykin / Toakan-Network**. The upstream project describes SimplePersist as a self-contained server-side Arma 3 persistence mod that stores player information including loadout, health and position. RHD uses it as an external Workshop dependency rather than copying its source into this repository.

Source: https://github.com/Toakan-Network/SimplePersist

Copyright holder: **Tom Daykin**

SimplePersist license: https://github.com/Toakan-Network/SimplePersist/blob/main/LICENSE

The SimplePersist repository's current license permits viewing, studying, forking and modifying the source for learning and contributing improvements back to the original project, while prohibiting redistribution, rehosting, commercial use and sublicensing without prior written permission. RHD-LifeServer therefore does **not** redistribute SimplePersist source code and instead requires the published Steam Workshop mod to be installed separately.

## Optional Workshop dependencies

| Slot | Mod | Steam Workshop ID | Required |
|---:|---|---:|:---:|
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

## RHD integration rule

RHD-LifeServer does not call or redistribute SimplePersist's internal source functions. The dependency is loaded by the Arma 3 server/client startup configuration, and RHD remains responsible for its own economy, RP, contracts, businesses, jobs and database state.

This separation preserves SimplePersist's licensing terms while allowing RHD to use the published Workshop release as an external persistence component.

## Other dependencies

The upstream **AsYetUntitled Framework v5.X.X** remains a separate Git submodule/mission dependency and is not counted as a Steam Workshop dependency.

**Antistasi Ultimate** remains an integration target rather than a mandatory dependency of the base RHD-LifeServer package.

Only dependencies marked **Required = Yes** should be included in the production server's mandatory `-mod=`/launcher configuration.
