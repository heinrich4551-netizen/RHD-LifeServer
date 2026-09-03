# RHD database layer

RHD-LifeServer adds its own tables alongside the upstream Altis Life schema. It does **not** replace or duplicate the upstream `players`, `vehicles`, housing, gang, wanted or inventory persistence tables.

## Install

1. Install the upstream Framework `altislife.sql` into the database used by your Altis Life mission.
2. Apply `database/rhd_extensions.sql` to the same database.
3. Ensure the upstream Framework's extDB3 configuration points at that database.
4. Start the dedicated server with the upstream `life_server` and the RHD addon loaded.

The RHD persistence adapter uses the upstream `DB_fnc_asyncCall` function rather than opening a second database connection. This keeps RHD compatible with the Framework's existing extDB3 connection/session handling.

## RHD state table

`rhd_state` stores serialized server-side RHD registries. Current persisted state includes:

- economy prices
- active delivery contracts
- dispatch calls
- evidence
- warrants
- impounds
- licenses
- businesses
- service requests
- hospital bills
- government state

RHD player cash, bank balance and inventory are intentionally **not** stored here; those remain owned by the upstream Framework persistence layer.

## Important

Run the SQL before enabling production persistence. If the upstream `DB_fnc_asyncCall` adapter is unavailable at startup, RHD will log the condition and continue without RHD persistence rather than blocking the mission indefinitely.
