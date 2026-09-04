# RHD-LifeServer Implementation Status

A feature is marked implemented only when its code and integration path exist. Production readiness still requires an actual dedicated-server/in-game validation pass.

## Phase 1 — Core
- [ ] Upstream Framework deployment verified
- [ ] Production database configuration externalized
- [ ] Server identity, mission rotation and BattlEye validated
- [ ] Police/civilian/medic integration validated
- [ ] Persistence, banking, inventory and shops validated
- [x] SimplePersist dependency documented and deployment-integrated as an external Workshop requirement

## Phase 2 — RHD Economy
- [x] Farming and mining node framework
- [x] Eden-configurable resource yields
- [x] Requested resource definitions: apples, peaches, grapes, corn, cannabis, coca leaf, iron ore, copper ore, gold ore, diamonds and oil sand
- [x] Refining/processing framework
- [x] Dynamic supply/demand pricing engine
- [x] Delivery contract generation/completion framework
- [x] Server-side Framework cash rewards for completed delivery contracts
- [x] Legal/illegal job progression
- [x] Full economy shop price integration
- [x] Persistent economy telemetry/state
- [x] Shop transaction caller/price/rate validation
- [x] Player business registry
- [x] Persistent business accounts
- [x] Server-authoritative business deposits/withdrawals
- [x] Business transaction audit ledger
- [x] Player-to-player cash/bank transfer foundation with audit ledger

## Phase 3 — RP Systems
- [x] Police/EMS dispatch registry and lifecycle state
- [x] Authenticated dispatch acknowledge/close actions
- [x] Evidence registry foundation
- [x] Warrant registry foundation
- [x] Impound registry foundation
- [x] Authenticated impound release with owner fee handling
- [x] EMS/service request foundation
- [x] EMS treatment action with server-side distance/role validation
- [x] Framework cash charging for EMS treatment
- [x] Hospital billing registry and Framework cash charging
- [x] Player business registry and account foundation
- [x] License registry foundation
- [x] Vehicle services/inspections with Framework cash charging
- [x] Courts/government/taxes foundation
- [x] Government tax ledger and administrator summary
- [x] Court case registry with authenticated police/admin creation and admin closure
- [x] RHD phone foundation: registration, calls and SMS
- [ ] Marketplace
- [x] Authenticated police/EMS RP action router

## Phase 4 — Live Operations
- [x] Scheduled world events with active gameplay effects
- [ ] Economy telemetry dashboard
- [ ] Automated backups/restart notices
- [x] Admin tools/audit logs
- [ ] Performance profiling
- [ ] Headless Client support

## Steam Workshop dependencies

The base RHD deployment currently has **one mandatory third-party Steam Workshop dependency**:

- **SimplePersist** — Workshop ID **3006691432** — required for the external player-state persistence component.

SimplePersist is installed separately from its published Workshop release. RHD does not copy or redistribute its source. Slots 2-25 remain reserved for future genuine runtime dependencies.

See `STEAM_WORKSHOP_DEPENDENCIES.md` and `SETUP.txt` for installation details and attribution.

## Legacy project and attribution

RHD-LifeServer is a legacy-respect modernization project. It preserves attribution to the Altis Life RP lineage, including TAW_Tonic and the AsYetUntitled Framework contributors, while keeping upstream code as a separate dependency. RHD-specific implementation remains under the LT. Toad / RHD-LifeServer project identity.

SimplePersist remains credited to Tom Daykin / Toakan-Network and is kept as a separate external dependency under its own license.

## Current implementation notes

The RHD addon is an independent overlay around the upstream AsYetUntitled Framework. The upstream framework remains a separate submodule and is not copied or modified by RHD.

Additional RHD-only virtual items are supplied in `custom/RHD_vItems.hpp`, and additional processing recipes are supplied in `custom/RHD_ProcessAction.hpp`. These fragments must be included by the actual Altis Life mission configuration because the Framework inventory system reads `missionConfigFile`.

The F6/F7/F8 UI is wired to server-side harvesting, processing and delivery-contract requests. Resource and processing requests validate the player, location, configured node/station and cooldown on the dedicated server before returning inventory changes to the client.

Legal and illegal resource activity maintains per-player progression with separate XP/levels. Harvesting contributes progression server-side, with periodic progression bonuses returned through the existing Framework cash/persistence mechanism.

RHD state persistence includes economy state, contracts, RP registries and job progression through the upstream Framework database adapter. The server scheduler performs persistence according to the configured save interval. SimplePersist remains responsible for its supported player-state persistence and is loaded separately.

The standard Framework virtual shop dialog is intercepted at runtime by RHD without changing the upstream submodule. Buy and sell transactions use the live RHD market price for tracked resources, display effective prices in the normal shop lists, and send completed transaction telemetry through a server-side validation endpoint. The endpoint binds the request to the actual remote caller UID, verifies the reported total against the current RHD price, validates tracked items and rate-limits telemetry. Direct client access to the lower-level market mutation function is no longer whitelisted.

The RHD financial adapter reads the selected player's Framework `cash` or `bankacc` balance through the existing database adapter, applies bounded charges/rewards server-side, writes the resulting balance to the upstream `players` table, records an RHD transaction audit row, and synchronizes the resulting account balance to the online client. It is used for EMS treatment, hospital bills, vehicle services, impound release fees, delivery contract rewards and player transfers. This deliberately does not modify the upstream Framework source.

Player businesses now have a server-owned registry and persistent business account table. Business owners can use authenticated server transactions to deposit or withdraw cash from their business account, with transaction audit rows and server-side owner validation. Business creation uses the configured startup fee before registration. The F7 Businesses action retrieves the owner's current business accounts. Business creation and account operations remain behind the authenticated RP router; no client-supplied owner UID or business balance is trusted.

Government taxation now has configurable sales, business and income rates, minimum-charge controls, a server-side tax transaction function, tax audit records and a government revenue ledger. Authorized administrators can request a government tax summary. Court cases have a server-owned registry with authenticated police creation and administrator closure. The RHD phone foundation assigns persistent-in-session numbers and supports authenticated player calls and SMS. Marketplace listings have a server-owned listing registry with owner-controlled cancellation; final item ownership transfer remains gated because the upstream virtual inventory is client-managed and must not be falsely represented as server-verified.

Delivery contract completion uses a pending server state and a client cargo-removal acknowledgement before the server awards the contract reward, reducing the previous client-side reward duplication path.

Dispatch records carry an explicit lifecycle status (`OPEN`, `ACK`, `CLOSED`) and authenticated police/EMS state transitions are routed through `RHD_fnc_rpAction`. Direct remote execution of the lower-level dispatch state function is not whitelisted.

Scheduled world events run from the dedicated-server scheduler and now apply bounded effects for their duration: DOUBLE_HARVEST doubles server-calculated harvest quantities, MARKET_BOOM applies a temporary 15% shop-price multiplier, and CIVIL_ALERT increases the civilian population target up to the configured maximum. Event timing and duration are configurable in `config/RHD_LifeServer.hpp`.

Authenticated administrator audit summaries now expose bounded recent financial activity and current dispatch, business, marketplace and world-event registry counts through the RP result channel.

The RP layer uses server-side authorization against the upstream `players` table for privileged actions. Client-side rank variables are not trusted for authorization.

The new `SETUP.txt` is the primary server-owner deployment checklist and collects required manual configuration, dependency installation, database setup, mission configuration, 3DEN setup, startup order, first-run tests, security checks and troubleshooting.

The remaining production gate is still an actual Arma 3 dedicated-server/PBO/in-game validation pass, including database connectivity, the complete upstream mission integration and the selected SimplePersist release.
