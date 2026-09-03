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
- Expandable farming, mining and refining economy
- Dynamic civilian population
- Legal and illegal jobs
- Player businesses and faction progression
- Server events and economy sinks
- Admin/moderation hooks
- BattlEye-friendly configuration

The upstream framework supplies the core Altis Life gameplay. RHD-LifeServer supplies deployment, server configuration, documentation and an isolated customization layer.

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
│   └── install.ps1
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

## Recommended server stack

- Arma 3 Dedicated Server
- Altis map
- AsYetUntitled Framework v5.X.X
- MariaDB/MySQL compatible database
- extDB3 or the database interface supported by your selected framework build
- BattlEye
- CBA/Ace only if separately desired by your server design

## Design principle

RHD customizations should remain isolated from upstream framework files whenever possible. This makes framework updates easier and avoids creating a hard-to-maintain fork.

## Suggested roadmap

### Phase 1 — Core

1. Deploy the upstream framework.
2. Configure database credentials outside source control.
3. Configure server identity, mission rotation and BattlEye.
4. Validate police, civilian and medic roles.
5. Validate persistence, banking, inventory and shops.

### Phase 2 — RHD economy

Add farming, mining, refining, processing and dynamic pricing as isolated extensions.

### Phase 3 — RP systems

Add businesses, licenses, contracts, dispatch, courts, vehicle services, player housing upgrades and faction progression.

### Phase 4 — Live operations

Add scheduled events, economy telemetry, restart announcements, automated backups and admin tooling.

## Security

Never commit database passwords, Steam Web API keys, RCON passwords, BattlEye RCon passwords, Discord bot tokens or other credentials.
