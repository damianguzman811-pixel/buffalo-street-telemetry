# Modding plan

## Goal

Build a small Cyberpunk-hosted, single-player driving benchmark that imports the stock Bravado Buffalo’s actual GTA V Legacy handling data from the user’s installed copy at launch.

## Implementation

1. `RunLocal.ps1` invokes the bundled Rage CLI in read-only extraction mode for two files from GTA V Legacy’s base update archive.
2. The helper validates that the GTA vehicle identity points at handling record `BUFFALO`, converts only the selected scalar fields into `profile.ini`, writes it inside the prototype’s own CET mod folder, and deletes temporary extracted files.
3. CET loads that profile and opens an in-game ImGui panel. While a run is active, the panel records time, distance, and the Cyberpunk vehicle’s `GetCurrentSpeed()` values. The panel presents GTA reference fields by their source field names; it does not claim the two games’ measurements use identical units.
4. The source JSON sheets define the system, source vehicle, and game hooks. `generate_config.py` emits the static Lua configuration from the system and hook sheets. `preflight.py` checks every sheet cell, source reference, and generated-file mapping before packaging.

## Scope and limits

- One player, Cyberpunk 2077 host, GTA V Legacy companion.
- The first slice is a telemetry benchmark, not a new car asset, quest, multiplayer mode, or GTA story-mode patch.
- GTA V Enhanced is not a supported companion build in this prototype.
- No extracted GTA metadata or game assets belong in the distribution.
- The package is not ready for Melty until the rights question is resolved, a Melty recipe is authored and validated, the one-click install is checked, and a genuine gameplay screenshot is captured.

