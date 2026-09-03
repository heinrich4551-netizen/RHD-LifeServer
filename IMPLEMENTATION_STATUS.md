# RHD-LifeServer Implementation Status

A feature is marked implemented only when its code and integration path exist. Production readiness still requires an actual dedicated-server/in-game validation pass.

## Phase 1 — Core
- [ ] Upstream Framework deployment verified
- [ ] Production database configuration externalized
- [ ] Server identity, mission rotation and BattlEye validated
- [ ] Police/civilian/medic integration validated
- [ ] Persistence, banking, inventory and shops validated

## Phase 2 — RHD Economy
- [x] Farming and mining node framework
- [x] Eden-configurable resource yields
- [x] Requested resource definitions: apples, peaches, grapes, corn, cannabis, coca leaf, iron ore, copper ore, gold ore, diamonds and oil sand
- [x] Refining/processing framework
- [x] Dynamic supply/demand pricing engine
- [x] Delivery contract generation/completion framework
- [ ] Legal/illegal job progression
- [ ] Full economy shop price integration
- [ ] Persistent economy telemetry

## Phase 3 — RP Systems
- [ ] Police dispatch
- [ ] Evidence
- [ ] Warrants
- [ ] Impounds
- [ ] EMS dispatch
- [ ] Treatment/rescue
- [ ] Hospital billing
- [ ] Player businesses/employees
- [ ] Licenses
- [ ] Vehicle services/inspections
- [ ] Courts/government/taxes
- [ ] RHD phone
- [ ] Marketplace
- [ ] Service requests

## Phase 4 — Live Operations
- [ ] Scheduled world events
- [ ] Economy telemetry
- [ ] Automated backups/restart notices
- [ ] Admin tools/audit logs
- [ ] Performance profiling
- [ ] Headless Client support

## Current implementation notes

The RHD addon is an independent overlay around the upstream AsYetUntitled Framework. The upstream framework remains a separate submodule and is not copied or modified by RHD.

Additional RHD-only virtual items are supplied in `custom/RHD_vItems.hpp`, and additional processing recipes are supplied in `custom/RHD_ProcessAction.hpp`. These fragments must be included by the actual Altis Life mission configuration because the Framework inventory system reads `missionConfigFile`.

The F6/F7/F8 UI is wired to server-side harvesting, processing and delivery-contract requests. Resource and processing requests validate the player, location, configured node/station and cooldown on the dedicated server before returning inventory changes to the client.
