# RHD LifeServer Addon

Author: LT. Toad

This directory is the RHD gameplay overlay. It is intentionally separate from the upstream AsYetUntitled Framework.

## F6 / F7 / F8

- **F6** — civilian resource actions. Harvest and processing requests are sent to the dedicated server for validation.
- **F7** — farming, mining, deliveries, contracts and businesses entry points.
- **F8** — vehicle services, licenses, dispatch, marketplace and emergency-service entry points.

## Resource markers

Create map markers in the Altis Life mission using the naming format:

`rhd_resource_<virtualItem>_<id>`

Examples:

- `rhd_resource_apple_1`
- `rhd_resource_peach_1`
- `rhd_resource_cannabis_1`
- `rhd_resource_cocaine_unprocessed_1`
- `rhd_resource_iron_unrefined_1`
- `rhd_resource_copper_unrefined_1`
- `rhd_resource_diamond_uncut_1`
- `rhd_resource_oil_unprocessed_1`

The server scans these markers during startup and exposes them through `RHD_ResourceNodes`.

## Processing markers

Use:

`rhd_process_<ProcessActionClass>_<id>`

Examples:

- `rhd_process_iron_1`
- `rhd_process_copper_1`
- `rhd_process_diamond_1`
- `rhd_process_oil_1`
- `rhd_process_cocaine_1`
- `rhd_process_marijuana_1`

The RHD server reads the mission's upstream `ProcessAction` recipes and does not maintain a parallel recipe database.

## Framework inventory

Harvest and refining use the upstream Altis Life `life_fnc_handleInv` API on the client after a server-authorized request. The corresponding item must exist in the mission's `VirtualItems` configuration.

## Current systems

- Server-authoritative harvesting with range validation, cooldowns and configured quantity ranges.
- Framework-backed refining using upstream `ProcessAction` recipes.
- Dynamic economy price registry.
- Civilian population scaling with player count.
- Framework-independent initialization hooks.
- Remote execution whitelist for RHD server functions.
