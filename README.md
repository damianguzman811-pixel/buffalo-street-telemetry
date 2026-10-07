# Buffalo Street Telemetry

**Local single-player prototype** for Cyberpunk 2077, using the player’s installed copy of Grand Theft Auto V Legacy as a live data companion.

At launch, a small helper reads the base-game Buffalo handling record from the player’s GTA V `update/update.rpf`, then writes only the selected numeric fields into this Cyberpunk CET mod’s local profile. In Night City, the CET panel shows that Bravado Buffalo reference beside a live driving benchmark for the Cyberpunk vehicle the player is driving. The helper never launches or writes to GTA V. The extracted game metadata is temporary and is not included in this project package.

## Prototype behavior

- The host is Cyberpunk 2077. The player drives in Cyberpunk and opens the **Buffalo Street Telemetry** CET panel.
- Grand Theft Auto V Legacy is a required companion. The local launcher reads the Buffalo’s `handling.meta` and its `vehicles.meta` identity from the player’s own `update/update.rpf` each time it runs.
- A driving benchmark records time spent in a vehicle, distance traveled, the peak Cyberpunk speed value, and the last speed value. GTA’s Buffalo values are shown as the companion reference; values from the different game engines are not presented as directly interchangeable units.
- Solo only. No network, GTA launch, online mode, or save editing is involved.

This is a small playable prototype, not a finished mission or a Melty-ready release. It requires CET, which is already installed in the local Cyberpunk folder. The source includes a local helper and Rage CLI so the prototype can be refreshed from each player’s own GTA copy. Melty’s one-click recipe and install test have not been created or checked.

## Local test

Open PowerShell with **Run as administrator**, then pass the two installed game folders. This is needed because the Cyberpunk installation is under `Program Files`; the script will not elevate itself.

```powershell
.\RunLocal.ps1 -CyberpunkPath 'C:\Program Files\Epic Games\Cyberpunk2077' -GtaPath 'D:\Grand Theft Auto V'
```

The script adds one uniquely named folder under Cyberpunk’s CET mods directory, refreshes `profile.ini` from GTA’s base-game RPF, and starts Cyberpunk. It refuses to replace an existing mod folder. Use `-NoLaunch` to install and refresh without starting the game. To remove only this prototype, run `UninstallLocal.ps1` with the same Cyberpunk path.

In game, open CET’s overlay and select **Buffalo Street Telemetry** from the Mods tab. Start and finish a benchmark with the buttons in the panel. The CET overlay can be toggled with its configured key.

## Credits and rights

- Rage CLI by VIRUXE, downloaded from its official GitHub release. Rage CLI is released under the Unlicense; the license text is in `licenses/RAGE-CLI-UNLICENSE.txt`.
- The prototype code’s redistribution license has not been selected. This package is for local testing only.
- Cyberpunk 2077 and Grand Theft Auto V Legacy remain required player-owned games. No game assets or extracted game files are included.
- This is an unofficial fan prototype and is not affiliated with CD Projekt Red, Rockstar Games, or Take-Two Interactive.

