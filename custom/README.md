# RHD custom layer

Keep new gameplay code here instead of editing `framework/AsYetUntitled-Framework` directly.

## Planned modules

- `farming` — harvestable crops, tools, yields, licenses and seasonal demand
- `mining` — iron, copper, gold, diamond and oil-sand extraction
- `refining` — ore-to-material processing chains
- `economy` — dynamic pricing, supply/demand and money sinks
- `businesses` — player-owned stores and service companies
- `contracts` — legal and faction contracts
- `dispatch` — police/medic/civilian incident routing
- `events` — server-wide dynamic events
- `population` — adaptive civilian density
- `services` — towing, repair, fuel and impound gameplay

Each module should expose a small configuration surface and avoid changing upstream framework files unless there is no supported integration point.
