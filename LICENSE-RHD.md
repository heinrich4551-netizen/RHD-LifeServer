# RHD-LifeServer licensing and legacy attribution

## RHD project

Original RHD-LifeServer deployment, configuration, integration and new gameplay material is provided by the repository owner under the terms selected for the RHD project.

Project identity: **RHD-LifeServer**

Author / maintainer: **LT. Toad**

## Legacy Altis Life RP acknowledgement

RHD-LifeServer is a legacy-respect modernization project. It acknowledges the people and projects that established and maintained the Altis Life RP ecosystem rather than presenting inherited work as original RHD work.

Special respect is given to **TAW_Tonic**, associated with the original Altis Life RPG / ARMARPGLIFE lineage, and to **AsYetUntitled** and the contributors to the upstream Framework.

These acknowledgements do not change the copyright or license of upstream material.

## Upstream Framework

The AsYetUntitled Framework is a separate upstream project and is licensed under:

**Creative Commons Attribution-NonCommercial-NoDerivs 4.0 International (CC BY-NC-ND 4.0)**

Upstream project:
https://github.com/AsYetUntitled/Framework

Upstream branch used by RHD:
https://github.com/AsYetUntitled/Framework/tree/v5.X.X

License:
https://creativecommons.org/licenses/by-nc-nd/4.0/

RHD keeps this Framework as a Git submodule rather than copying its source into the RHD implementation. Users distributing or using the upstream Framework must comply with its own license and attribution requirements.

## SimplePersist dependency

RHD-LifeServer requires **SimplePersist** as an external Steam Workshop dependency for player-state persistence.

- Project: **SimplePersist**
- Creator / copyright holder: **Tom Daykin / Toakan-Network**
- Steam Workshop ID: **3006691432**
- Workshop: https://steamcommunity.com/sharedfiles/filedetails/?id=3006691432
- Source: https://github.com/Toakan-Network/SimplePersist
- License: https://github.com/Toakan-Network/SimplePersist/blob/main/LICENSE

RHD does **not** copy, bundle, rehost, or redistribute SimplePersist source. The published Workshop release must be installed separately by the server owner. Its own license and distribution terms remain applicable.

SimplePersist and RHD have separate responsibilities. RHD must not present SimplePersist code as RHD code or duplicate/overwrite SimplePersist's supported player-state persistence.

## Contributor recognition

Using an upstream dependency does not make its authors RHD authors. Conversely, RHD integration and new code does not claim ownership of the upstream Framework or SimplePersist.

The repository therefore separates:

- **Upstream legacy/framework work:** TAW_Tonic, AsYetUntitled and applicable upstream contributors.
- **Player persistence dependency:** Tom Daykin / Toakan-Network / SimplePersist.
- **RHD modernization/integration:** LT. Toad / RHD-LifeServer contributors.

## Steam Workshop dependencies

SimplePersist is currently the only mandatory third-party Steam Workshop dependency. Future Workshop dependencies must be explicitly listed in `STEAM_WORKSHOP_DEPENDENCIES.md` and must remain subject to the respective creator's license and distribution terms.

See [`SETUP.txt`](SETUP.txt) for the complete server-owner setup checklist.
