# Modding log

## 2026-10-07 — Initial local prototype

- **Host:** Cyberpunk 2077 (Epic installation; detected game executable product version `3.0.5294808`).
- **Companion:** Grand Theft Auto V Legacy (`GTA5.exe` version `1.0.3889.0`). GTA V Enhanced was detected separately and is not supported by this prototype.
- **Engine/tooling:** REDengine 4 with CET Lua; GTA V uses RAGE and stores the selected stock records in `update/update.rpf`.
- **Existing setup:** CET, RED4ext, TweakXL, ArchiveXL, REDmod, and other Vortex-managed mods are already present in Cyberpunk. This prototype only adds its own CET mod folder and does not replace or install any loader.
- **Source discovery:** Rage CLI extracted only `common/data/handling.meta` and `common/data/levels/gta5/vehicles.meta` from the user’s local GTA V Legacy `update/update.rpf` into temporary work space. The Buffalo record resolves to model `buffalo`, brand `BRAVADO`, class `VC_SPORT`, handling ID `BUFFALO`.
- **Observed source values:** `fMass=1650`, `fInitialDriveForce=0.27`, `nInitialDriveGears=5`, `fInitialDriveMaxFlatVel=145`, `fBrakeForce=0.9`, `fSteeringLock=40`, `fTractionCurveMax=2.45`, `fTractionCurveMin=2.2`, and `fSuspensionForce=2.1`.
- **Safety:** GTA was read-only; the helper will extract into a temporary directory and remove that directory. It never launches GTA or changes GTA files. The prototype is single-player and does not interact with an online service or anti-cheat.
- **Status:** Source and package are local-only. No Melty listing or upload has been made. Rights review is still needed before publication.

