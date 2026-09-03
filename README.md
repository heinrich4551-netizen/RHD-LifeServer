# RHD-LifeServer

A server/deployment layer for an Altis Life RP server built around the **AsYetUntitled Framework v5.X.X**.

## Important licensing note

The upstream framework is licensed under CC BY-NC-ND 4.0. RHD-LifeServer therefore does **not** copy, modify, or redistribute the upstream framework source in this repository. The framework is referenced as a Git submodule so it remains a separate upstream work.

Upstream: https://github.com/AsYetUntitled/Framework/tree/v5.X.X

## Server concept

**RHD-LifeServer** is designed as a modern Altis Life server layer with:

- Police, civilian and medic RP
- Banking and persistent player economy
- Virtual-item economy
- Shops, vehicles, clothing and weapons
- Housing and persistent wanted gameplay
- Farming, mining and refining economy
- Dynamic supply/demand pricing
- Dynamic civilian population
- Legal and illegal jobs
- Player businesses and faction progression
- Contracts and logistics
- Dispatch, emergency and event systems
- Vehicle services and licensing
- Government/court gameplay
- Admin/moderation hooks
- BattlEye-friendly configuration

The upstream framework supplies the core Altis Life gameplay. RHD-LifeServer supplies deployment, server configuration and an isolated customization addon.

## Repository layout

```text
RHD-LifeServer/
├── .gitmodules
├── README.md
├── LICENSE-RHD.md
├── config/
│   ├── server.cfg
│   ├── basic.cfg
│   └── RHD_LifeServer.hpp
├── database/
│   └── rhd_extensions.sql
├── deployment/
│   ├── install.ps1
│   └── build.ps1
├── addons/
│   └── rhd_lifeserver/
│       ├── config.cpp
│       ├── mod.cpp
│       ├── README.md
│       └── functions/
└── custom/
    ├── README.md
    └── RHD_features.hpp
```

## Framework setup

Clone with the upstream framework submodule:

```powershell
git clone --recurse-submodules https://github.com/heinrich4551-netizen/RHD-LifeServer.git
```

If you already cloned the repository:

```powershell
git submodule update --init --recursive
```

The submodule is pinned to the upstream `v5.X.X` branch.

## RHD addon

The `addons/rhd_lifeserver` directory is an independent overlay. It uses Arma 3 `CfgFunctions` preInit/postInit hooks, so the RHD systems can be updated without rewriting the upstream framework.

Current implemented systems:

- Dynamic economy price registry with bounded price movement.
- Server-authoritative resource harvesting with cooldown/quantity validation.
- Refining recipes: iron ore → iron, copper ore → copper, gold ore → gold, oil sand → fuel.
- Dynamic civilian population controller targeting 115 civilians at one player and scaling toward a 60-civilian floor as player count rises.
- Marker-based resource registration.
- RHD remote-execution whitelist.

### Resource markers

Place markers in the Altis Life mission using:

```text
rhd_resource_<item>_<id>
```

Examples:

```text
rhd_resource_apple_1
rhd_resource_grape_1
rhd_resource_cannabis_1
rhd_resource_coca_1
rhd_resource_corn_1
rhd_resource_peach_1
rhd_resource_iron_1
rhd_resource_copper_1
rhd_resource_gold_1
rhd_resource_diamond_1
rhd_resource_oil_1
```

The RHD addon discovers these at server startup and exposes them through `RHD_ResourceNodes`.

### Building the PBO

Install the Arma 3 Tools package and run:

```powershell
.\deployment\build.ps1 -ArmaToolsPath "C:\Program Files (x86)\Steam\steamapps\common\Arma 3 Tools\AddonBuilder"
```

Copy the resulting `RHD_LifeServer.pbo` into the server's `@RHD-LifeServer\addons` directory.

## Recommended server stack

- Arma 3 Dedicated Server
- Altis map
- AsYetUntitled Framework v5.X.X
- MariaDB/MySQL compatible database
- extDB3 or the database interface supported by your selected framework build
- BattlEye

## Suggested roadmap

### Phase 1 — Core

1. Deploy the upstream framework.
2. Configure database credentials outside source control.
3. Configure server identity, mission rotation and BattlEye.
4. Validate police, civilian and medic roles.
5. Validate persistence, banking, inventory and shops.

### Phase 2 — RHD economy

1. Farming and mining nodes.
2. Refining/processing chains.
3. Dynamic supply/demand pricing.
4. Legal/illegal job progression.
5. Logistics and delivery contracts.

### Phase 3 — RP systems

1. Police dispatch, evidence, warrants and impounds.
2. EMS dispatch, treatment, hospital billing and rescue.
3. Player businesses and employees.
4. Licenses, vehicle services and inspections.
5. Courts, government and taxes.
6. RHD phone, marketplace and service requests.

### Phase 4 — Live operations

1. Scheduled world events.
2. Economy telemetry and balancing.
3. Automated backups/restart notices.
4. Admin tools and audit logs.
5. Performance profiling and Headless Client support.

## Security

Never commit database passwords, Steam Web API keys, RCON passwords, BattlEye RCon passwords, Discord bot tokens or other credentials.
