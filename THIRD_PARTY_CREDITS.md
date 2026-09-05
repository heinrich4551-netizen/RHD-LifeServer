# Third-Party Credits

## Antistasi Ultimate

RHD-LifeServer includes a compatibility/integration layer for **Antistasi Ultimate** and is designed to use the Antistasi Ultimate functions supplied by the separately installed Antistasi Ultimate package.

Credits:
- **Antistasi Ultimate Team** — Antistasi Ultimate
- **Socrates** — Antistasi Plus
- **Barbolani & The Official Antistasi Community** — Antistasi Community Edition

The applicable Antistasi Ultimate, Antistasi Plus and Antistasi Community Edition components are MIT licensed as identified by their distributed license file.

The separately licensed StreetArtist and Håkon Rydland Garage components retain their original licenses and are not modified by RHD's compatibility layer.

## AsYetUntitled Framework

RHD-LifeServer uses the supplied Framework 5.X.X source as its upstream Altis Life roleplay framework and preserves its original attribution and license notices.

The Framework identifies **TAW_Tonic** as its original creator and **AsYetUntitled** as the current project. See the supplied Framework license and README for the complete attribution.

## Integration Rule

The RHD compatibility layer does not disable RHD-LifeServer itself for any faction.

Only the **Antistasi-specific integration calls exposed by RHD** require:

- `side player == independent`
- and, when available, `teamPlayer == independent`

This keeps the RHD framework, economy, jobs, persistence, menus and server services available to all players while restricting only the Antistasi integration to the Independent/rebel faction.
