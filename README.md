# RHD-LifeServer

A legacy-respect modernization and server/deployment layer for an Altis Life RP server built around the **AsYetUntitled Framework v5.X.X**.

## Respect for the Altis Life RP legacy

RHD-LifeServer is intentionally presented as a continuation of the long-running Altis Life RP tradition, not as a claim that RHD invented the framework or the genre.

Special credit and respect goes to **TAW_Tonic**, the original creator associated with the Altis Life RPG / ARMARPGLIFE lineage, and to **AsYetUntitled** and the many contributors who have maintained and advanced the upstream Framework. Their work is part of the foundation on which this legacy project is being modernized.

RHD-specific work is authored under the **LT. Toad / RHD-LifeServer** project identity. Upstream authors and contributors remain credited through the separate upstream repository and its license.

## Licensing and source boundaries

The upstream Framework is licensed under **CC BY-NC-ND 4.0**. RHD-LifeServer does not treat attribution as permission to alter and redistribute the upstream source. The Framework remains a separate Git submodule, while RHD functionality is implemented as an independent overlay and integration layer.

Upstream: https://github.com/AsYetUntitled/Framework/tree/v5.X.X

Upstream license: https://creativecommons.org/licenses/by-nc-nd/4.0/

## Server concept

**RHD-LifeServer** is designed as a modern Altis Life RP layer with:

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

## Steam Workshop dependencies

**SimplePersist is a required external Steam Workshop dependency.**

- Mod: **SimplePersist**
- Workshop ID: **3006691432**
- Workshop: https://steamcommunity.com/sharedfiles/filedetails/?id=3006691432
- Creator/copyright holder: **Tom Daykin / Toakan-Network**
- Source: https://github.com/Toakan-Network/SimplePersist

RHD does not copy or redistribute SimplePersist source. Install the published Workshop release separately and load it before RHD-LifeServer, for example:

```text
-mod=@SimplePersist;@RHD-LifeServer
```

SimplePersist is responsible for its supported player-state persistence. RHD remains responsible for its own economy, RP, contracts, businesses, jobs and database state. Do not duplicate or overwrite SimplePersist's player-state storage from RHD.

RHD supports a dependency manifest with **up to 25 Steam Workshop entries**. Only genuine runtime requirements should be marked required. Slots 2-25 are currently reserved.

See [`STEAM_WORKSHOP_DEPENDENCIES.md`](STEAM_WORKSHOP_DEPENDENCIES.md) and [`SETUP.txt`](SETUP.txt) for the complete dependency and installation procedure.

Antistasi Ultimate and other gameplay projects remain integration targets rather than mandatory dependencies of the base RHD addon.

## Repository layout

```text
RHD-LifeServer/
├── .gitmodules
├── README.md
├── SETUP.txt
├── STEAM_WORKSHOP_DEPENDENCIES.md
├── IMPLEMENTATION_STATUS.md
├── LICENSE-RHD.md
├── config/
├── database/
├── deployment/
├── addons/rhd_lifeserver/
└── custom/
```

## Framework setup

Clone with the upstream framework submodule:

```powershell
git clone --recurse-submodules https://github.com/heinrich4551-netizen/RHD-LifeServer.git
```

If already cloned:

```powershell
git submodule update --init --recursive
```

## RHD addon and local mod package

The `addons/rhd_lifeserver` directory is an independent overlay. It uses Arma 3 `CfgFunctions` initialization hooks so RHD systems can be developed without rewriting the upstream framework.

Current systems include dynamic economy, server-validated harvesting/refining, Eden configuration, adaptive civilian population, optional Headless Client population offload, contracts, legal/illegal progression, shop integration, persistence, authenticated RP registries/actions, and the Antistasi-specific compatibility bridge.

The Antistasi bridge is the only RHD component scoped to the Antistasi Independent faction. Ordinary RHD server/mod functionality remains available to every player.

## Building the PBO

Install Arma 3 Tools and run:

```powershell
.\deployment\build.ps1 -ArmaToolsPath "C:\Program Files (x86)\Steam\steamapps\common\Arma 3 Tools\AddonBuilder"
```

Copy `dist\RHD_LifeServer.pbo` into `@RHD-LifeServer\addons` on the dedicated server.

## Building the complete @RHD-LifeServer local mod

The repository includes `deployment\package-mod.ps1` to produce the standard local-mod directory and ZIP:

```powershell
.\deployment\package-mod.ps1 -ArmaToolsPath "C:\Program Files (x86)\Steam\steamapps\common\Arma 3 Tools\AddonBuilder"
```

Output:

```text
dist\@RHD-LifeServer\
├── addons\
│   └── RHD_LifeServer.pbo
├── keys\
│   └── README.txt
├── mod.cpp
├── README.md
├── SETUP.txt
├── LICENSE-RHD.md
├── THIRD_PARTY_CREDITS.md
└── PBO-Info.txt

dist\@RHD-LifeServer.zip
```

The package intentionally does not contain a fabricated `.bikey`. If signature enforcement is used, generate the real server key pair with Arma 3 DSCreateKey and keep the private `.biprivatekey` secret.

The mission and database configuration remain deployment components rather than being incorrectly embedded into the addon PBO.

## Recommended server stack

- Arma 3 Dedicated Server
- Altis
- AsYetUntitled Framework v5.X.X
- SimplePersist Workshop ID 3006691432
- MariaDB/MySQL-compatible database
- extDB3 or the database interface supported by the selected Framework build
- BattlEye

## Development principle

RHD will continue to use compatible upstream APIs where appropriate, while keeping new systems in the RHD layer. Where upstream code is licensed separately, the project will preserve its attribution, license boundary and legacy status rather than presenting inherited work as original RHD code.

## Security

Never commit database passwords, Steam Web API keys, RCON passwords, BattlEye RCon passwords, Discord bot tokens, signing private keys or other credentials.
