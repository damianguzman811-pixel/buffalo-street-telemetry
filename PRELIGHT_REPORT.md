# Sheet preflight report

Result: **PASS**
Checked 102 cells and references across 5 rows in 3 sheets.

## Cell and reference audit

| Check | Result | Detail |
|---|---:|---|
| `systems[buffalo_driving_benchmark].id` | ✓ | filled |
| `systems[buffalo_driving_benchmark].host_game` | ✓ | filled |
| `systems[buffalo_driving_benchmark].companion_game` | ✓ | filled |
| `systems[buffalo_driving_benchmark].mode` | ✓ | filled |
| `systems[buffalo_driving_benchmark].window_title` | ✓ | filled |
| `systems[buffalo_driving_benchmark].description` | ✓ | filled |
| `systems[buffalo_driving_benchmark].mod_folder` | ✓ | filled |
| `systems[buffalo_driving_benchmark].generated_config` | ✓ | filled |
| `systems[buffalo_driving_benchmark].codegen` | ✓ | filled |
| `systems[buffalo_driving_benchmark].speed_source` | ✓ | filled |
| `systems[buffalo_driving_benchmark].distance_unit` | ✓ | filled |
| `vehicles[bravado_buffalo].id` | ✓ | filled |
| `vehicles[bravado_buffalo].game` | ✓ | filled |
| `vehicles[bravado_buffalo].game_build` | ✓ | filled |
| `vehicles[bravado_buffalo].display_name` | ✓ | filled |
| `vehicles[bravado_buffalo].model_name` | ✓ | filled |
| `vehicles[bravado_buffalo].vehicle_class` | ✓ | filled |
| `vehicles[bravado_buffalo].handling_id` | ✓ | filled |
| `vehicles[bravado_buffalo].archive_path` | ✓ | filled |
| `vehicles[bravado_buffalo].vehicle_meta_path` | ✓ | filled |
| `vehicles[bravado_buffalo].handling_meta_path` | ✓ | filled |
| `vehicles[bravado_buffalo].source_fields[0]` | ✓ | filled |
| `vehicles[bravado_buffalo].source_fields[1]` | ✓ | filled |
| `vehicles[bravado_buffalo].source_fields[2]` | ✓ | filled |
| `vehicles[bravado_buffalo].source_fields[3]` | ✓ | filled |
| `vehicles[bravado_buffalo].source_fields[4]` | ✓ | filled |
| `vehicles[bravado_buffalo].source_fields[5]` | ✓ | filled |
| `vehicles[bravado_buffalo].source_fields[6]` | ✓ | filled |
| `vehicles[bravado_buffalo].source_fields[7]` | ✓ | filled |
| `vehicles[bravado_buffalo].source_fields[8]` | ✓ | filled |
| `vehicles[bravado_buffalo].profile_fields.fMass` | ✓ | filled |
| `vehicles[bravado_buffalo].profile_fields.fInitialDriveForce` | ✓ | filled |
| `vehicles[bravado_buffalo].profile_fields.nInitialDriveGears` | ✓ | filled |
| `vehicles[bravado_buffalo].profile_fields.fInitialDriveMaxFlatVel` | ✓ | filled |
| `vehicles[bravado_buffalo].profile_fields.fBrakeForce` | ✓ | filled |
| `vehicles[bravado_buffalo].profile_fields.fSteeringLock` | ✓ | filled |
| `vehicles[bravado_buffalo].profile_fields.fTractionCurveMax` | ✓ | filled |
| `vehicles[bravado_buffalo].profile_fields.fTractionCurveMin` | ✓ | filled |
| `vehicles[bravado_buffalo].profile_fields.fSuspensionForce` | ✓ | filled |
| `vehicles[bravado_buffalo].profile_file` | ✓ | filled |
| `vehicles[bravado_buffalo].runtime_parser` | ✓ | filled |
| `vehicles[bravado_buffalo].generated_config` | ✓ | filled |
| `vehicles[bravado_buffalo].profile_schema_version` | ✓ | filled |
| `hooks[load_companion_profile].id` | ✓ | filled |
| `hooks[load_companion_profile].system_id` | ✓ | filled |
| `hooks[load_companion_profile].event` | ✓ | filled |
| `hooks[load_companion_profile].operation` | ✓ | filled |
| `hooks[load_companion_profile].code_file` | ✓ | filled |
| `hooks[sample_vehicle_telemetry].id` | ✓ | filled |
| `hooks[sample_vehicle_telemetry].system_id` | ✓ | filled |
| `hooks[sample_vehicle_telemetry].event` | ✓ | filled |
| `hooks[sample_vehicle_telemetry].operation` | ✓ | filled |
| `hooks[sample_vehicle_telemetry].code_file` | ✓ | filled |
| `hooks[draw_benchmark_panel].id` | ✓ | filled |
| `hooks[draw_benchmark_panel].system_id` | ✓ | filled |
| `hooks[draw_benchmark_panel].event` | ✓ | filled |
| `hooks[draw_benchmark_panel].operation` | ✓ | filled |
| `hooks[draw_benchmark_panel].code_file` | ✓ | filled |
| `systems[buffalo_driving_benchmark].host_game -> cyberpunk-2077` | ✓ | resolved game slug |
| `systems[buffalo_driving_benchmark].companion_game -> gta-v` | ✓ | resolved game slug |
| `hooks[load_companion_profile].system_id -> buffalo_driving_benchmark` | ✓ | resolved |
| `hooks[load_companion_profile].code_file -> src/CetMod/init.lua` | ✓ | resolved file |
| `hooks[load_companion_profile].event -> onInit` | ✓ | resolved hook event |
| `hooks[sample_vehicle_telemetry].system_id -> buffalo_driving_benchmark` | ✓ | resolved |
| `hooks[sample_vehicle_telemetry].code_file -> src/CetMod/init.lua` | ✓ | resolved file |
| `hooks[sample_vehicle_telemetry].event -> onUpdate` | ✓ | resolved hook event |
| `hooks[draw_benchmark_panel].system_id -> buffalo_driving_benchmark` | ✓ | resolved |
| `hooks[draw_benchmark_panel].code_file -> src/CetMod/init.lua` | ✓ | resolved file |
| `hooks[draw_benchmark_panel].event -> onDraw` | ✓ | resolved hook event |
| `systems[buffalo_driving_benchmark].generated_config -> src/CetMod/config.lua` | ✓ | resolved file |
| `systems[buffalo_driving_benchmark].codegen -> scripts/generate_config.py` | ✓ | resolved file |
| `vehicles[bravado_buffalo].game -> gta-v` | ✓ | resolved game slug |
| `vehicles[bravado_buffalo].runtime_parser -> RunLocal.ps1` | ✓ | resolved file |
| `vehicles[bravado_buffalo].profile_file -> profile.ini` | ✓ | resolved CET profile contract |
| `vehicles[bravado_buffalo].generated_config -> src/CetMod/config.lua` | ✓ | resolved generated config |
| `vehicles[bravado_buffalo].profile_fields.fMass -> fMass` | ✓ | resolved field mapping |
| `vehicles[bravado_buffalo].runtime_parser includes fMass` | ✓ | parser writes field |
| `vehicles[bravado_buffalo].CET panel reads fMass` | ✓ | CET displays field |
| `vehicles[bravado_buffalo].profile_fields.fInitialDriveForce -> fInitialDriveForce` | ✓ | resolved field mapping |
| `vehicles[bravado_buffalo].runtime_parser includes fInitialDriveForce` | ✓ | parser writes field |
| `vehicles[bravado_buffalo].CET panel reads fInitialDriveForce` | ✓ | CET displays field |
| `vehicles[bravado_buffalo].profile_fields.nInitialDriveGears -> nInitialDriveGears` | ✓ | resolved field mapping |
| `vehicles[bravado_buffalo].runtime_parser includes nInitialDriveGears` | ✓ | parser writes field |
| `vehicles[bravado_buffalo].CET panel reads nInitialDriveGears` | ✓ | CET displays field |
| `vehicles[bravado_buffalo].profile_fields.fInitialDriveMaxFlatVel -> fInitialDriveMaxFlatVel` | ✓ | resolved field mapping |
| `vehicles[bravado_buffalo].runtime_parser includes fInitialDriveMaxFlatVel` | ✓ | parser writes field |
| `vehicles[bravado_buffalo].CET panel reads fInitialDriveMaxFlatVel` | ✓ | CET displays field |
| `vehicles[bravado_buffalo].profile_fields.fBrakeForce -> fBrakeForce` | ✓ | resolved field mapping |
| `vehicles[bravado_buffalo].runtime_parser includes fBrakeForce` | ✓ | parser writes field |
| `vehicles[bravado_buffalo].CET panel reads fBrakeForce` | ✓ | CET displays field |
| `vehicles[bravado_buffalo].profile_fields.fSteeringLock -> fSteeringLock` | ✓ | resolved field mapping |
| `vehicles[bravado_buffalo].runtime_parser includes fSteeringLock` | ✓ | parser writes field |
| `vehicles[bravado_buffalo].CET panel reads fSteeringLock` | ✓ | CET displays field |
| `vehicles[bravado_buffalo].profile_fields.fTractionCurveMax -> fTractionCurveMax` | ✓ | resolved field mapping |
| `vehicles[bravado_buffalo].runtime_parser includes fTractionCurveMax` | ✓ | parser writes field |
| `vehicles[bravado_buffalo].CET panel reads fTractionCurveMax` | ✓ | CET displays field |
| `vehicles[bravado_buffalo].profile_fields.fTractionCurveMin -> fTractionCurveMin` | ✓ | resolved field mapping |
| `vehicles[bravado_buffalo].runtime_parser includes fTractionCurveMin` | ✓ | parser writes field |
| `vehicles[bravado_buffalo].CET panel reads fTractionCurveMin` | ✓ | CET displays field |
| `vehicles[bravado_buffalo].profile_fields.fSuspensionForce -> fSuspensionForce` | ✓ | resolved field mapping |
| `vehicles[bravado_buffalo].runtime_parser includes fSuspensionForce` | ✓ | parser writes field |
| `vehicles[bravado_buffalo].CET panel reads fSuspensionForce` | ✓ | CET displays field |

## Unfilled cells and unresolved references

None.
