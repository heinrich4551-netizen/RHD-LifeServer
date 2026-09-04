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
- [x] Legal/illegal job progression
- [x] Full economy shop price integration
- [x] Persistent economy telemetry/state
- [x] Shop transaction caller/price/rate validation

## Phase 3 — RP Systems
- [x] Police/EMS dispatch registry and lifecycle state
- [x] Authenticated dispatch acknowledge/close actions
- [x] Evidence registry foundation
- [x] Warrant registry foundation
- [x] Impound registry foundation
- [x] EMS/service request foundation
- [ ] Treatment/rescue
- [x] Hospital billing registry foundation
- [x] Player business registry foundation
- [x] License registry foundation
- [ ] Vehicle services/inspections
- [ ] Courts/government/taxes
- [ ] RHD phone
- [ ] Marketplace
- [x] Authenticated police/EMS RP action router

## Phase 4 — Live Operations
- [ ] Scheduled world events
- [ ] Economy telemetry dashboard
- [ ] Automated backups/restart notices
- [ ] Admin tools/audit logs
- [ ] Performance profiling
- [ ] Headless Client support

## Steam Workshop dependencies

The base RHD addon currently has **zero mandatory third-party Steam Workshop dependencies**. A manifest supports up to 25 dependency slots so future integrations can be declared explicitly without making unrelated mods mandatory.

## Legacy project and attribution

RHD-LifeServer is a legacy-respect modernization project. It preserves attribution to the Altis Life RP lineage, including TAW_Tonic and the AsYetUntitled Framework contributors, while keeping upstream code as a separate dependency. RHD-specific implementation remains under the LT. Toad / RHD-LifeServer project identity.

## Current implementation notes

The RHD addon is an independent overlay around the upstream AsYetUntitled Framework. The upstream framework remains a separate submodule and is not copied or modified by RHD.

Additional RHD-only virtual items are supplied in `custom/RHD_vItems.hpp`, and additional processing recipes are supplied in `custom/RHD_ProcessAction.hpp`. These fragments must be included by the actual Altis Life mission configuration because the Framework inventory system reads `missionConfigFile`.

The F6/F7/F8 UI is wired to server-side harvesting, processing and delivery-contract requests. Resource and processing requests validate the player, location, configured node/station and cooldown on the dedicated server before returning inventory changes to the client.

Legal and illegal resource activity maintains per-player progression with separate XP/levels. Harvesting contributes progression server-side, with periodic progression bonuses returned through the existing Framework cash/persistence mechanism.

RHD state persistence includes economy state, contracts, RP registries and job progression through the upstream Framework database adapter. The server scheduler performs persistence according to the configured save interval.

The standard Framework virtual shop dialog is intercepted at runtime by RHD without changing the upstream submodule. Buy and sell transactions use the live RHD market price for tracked resources, display effective prices in the normal shop lists, and send completed transaction telemetry through a server-side validation endpoint. The endpoint binds the request to the actual remote caller UID, verifies the reported total against the current RHD price, validates tracked items and rate-limits telemetry. Direct client access to the lower-level market mutation function is no longer whitelisted.

Dispatch records now carry an explicit lifecycle status (`OPEN`, `ACK`, `CLOSED`) and authenticated police/EMS state transitions are routed through `RHD_fnc_rpAction`. Direct remote execution of the lower-level dispatch state function is not whitelisted.

The RP layer uses server-side authorization against the upstream `players` table for privileged actions. Client-side rank variables are not trusted for authorization.

The remaining production gate is still an actual Arma 3 dedicated-server/PBO/in-game validation pass, including database connectivity and the complete upstream mission integration.
