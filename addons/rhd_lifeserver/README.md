# RHD LifeServer Addon

Author: LT. Toad

This directory is the RHD gameplay overlay. It is intentionally separate from the upstream AsYetUntitled Framework.

## 3DEN setup — no manual markers required

RHD LifeServer is now configured directly from Eden.

### 1. Place one `RHD LifeCore Configuration` module

Find **RHD LifeCore** in the Eden Modules list and place one configuration module anywhere on the map.

Configure:

- Farming minimum / maximum harvest
- Mining minimum / maximum harvest
- Civilians at 1 player — default **115**
- Minimum civilians — default **60**
- Maximum civilians — default **115**
- Civilian scaling with players
- Harvest cooldown
- Dynamic pricing

The population system preserves 115 civilians at one active player and reduces the target by 10 for each additional active player until the configured minimum is reached. With the defaults this reaches 60 at 7+ active players.

### 2. Place `RHD Resource Node` modules

Place a Resource Node directly at every farming or mining location. The module position is the actual interaction location; no map marker is required.

Select the resource and configure:

- Resource type
- Minimum yield
- Maximum yield
- Interaction radius
- Illegal flag
- Enabled/disabled

Supported node resources currently map to the upstream virtual item names for apples, peaches, cannabis, coca leaf, iron ore, copper ore, gold, uncut diamond and unprocessed oil.

### 3. Place `RHD Processing Station` modules

Place one at each processing facility. Enter the exact upstream `ProcessAction` class, for example:

- `iron`
- `copper`
- `diamond`
- `oil`
- `cocaine`
- `marijuana`

Set the interaction radius and enabled state.

The server validates the station, recipe, input and output before authorizing inventory changes. RHD does not duplicate the upstream `ProcessAction` recipe database.

## F6 / F7 / F8

- **F6** — civilian resource actions. Harvest and processing requests are sent to the dedicated server for validation.
- **F7** — farming, mining, deliveries, contracts and businesses entry points.
- **F8** — vehicle services, licenses, dispatch, marketplace and emergency-service entry points.

## Legacy marker compatibility

Existing missions can continue using:

`rhd_resource_<virtualItem>_<id>`

and:

`rhd_process_<ProcessActionClass>_<id>`

RHD converts those markers into the same runtime registry used by the Eden modules. New missions should use the Eden modules instead.

## Framework inventory

Harvest and refining use the upstream Altis Life `life_fnc_handleInv` API on the client after a server-authorized request. The corresponding item must exist in the mission's `VirtualItems` configuration.

## Current systems

- Server-authoritative harvesting with range validation, cooldowns and configured quantity ranges.
- 3DEN-configured resource nodes and processing stations.
- Framework-backed refining using upstream `ProcessAction` recipes.
- Dynamic economy price registry.
- Configurable civilian population scaling.
- Framework-independent initialization hooks.
- Remote execution whitelist for RHD server functions.
