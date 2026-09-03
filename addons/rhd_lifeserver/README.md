# RHD LifeServer Addon

This directory is the RHD gameplay overlay. It is intentionally separate from the upstream AsYetUntitled Framework.

## Resource markers

Create map markers in the Altis Life mission using the naming format:

`rhd_resource_<item>_<id>`

Examples:

- `rhd_resource_apple_1`
- `rhd_resource_grape_1`
- `rhd_resource_iron_1`
- `rhd_resource_copper_1`
- `rhd_resource_gold_1`
- `rhd_resource_diamond_1`
- `rhd_resource_oil_1`

The server scans these markers during startup and exposes them through `RHD_ResourceNodes`.

## Current systems

- Server-authoritative harvesting with cooldown and quantity caps.
- Refining recipes for iron, copper, gold and oil sand/fuel.
- Dynamic economy price registry.
- Civilian population scaling with player count.
- Framework-independent initialization hooks.
- Remote execution whitelist for RHD server functions.

## Planned systems

Police dispatch/evidence, EMS dispatch/treatment, player businesses, contracts, logistics, licenses, vehicle services, government, events and the RHD phone/UI should be layered on top of these APIs.
