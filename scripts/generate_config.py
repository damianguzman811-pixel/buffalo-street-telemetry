import json
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]


def lua_string(value: str) -> str:
    return '"' + value.replace("\\", "\\\\").replace('"', '\\"').replace("\n", "\\n") + '"'


systems = json.loads((ROOT / "sheets/systems.json").read_text(encoding="utf-8"))
vehicles = json.loads((ROOT / "sheets/vehicles.json").read_text(encoding="utf-8"))
hooks = json.loads((ROOT / "sheets/hooks.json").read_text(encoding="utf-8"))
system = systems[0]
vehicle = vehicles[0]

out = [
    "-- Generated from sheets/systems.json, sheets/vehicles.json, and sheets/hooks.json.",
    "return {",
    f"  systemId = {lua_string(system['id'])},",
    f"  windowTitle = {lua_string(system['window_title'])},",
    f"  mode = {lua_string(system['mode'])},",
    f"  speedSource = {lua_string(system['speed_source'])},",
    f"  distanceUnit = {lua_string(system['distance_unit'])},",
    f"  vehicleId = {lua_string(vehicle['id'])},",
    f"  vehicleDisplayName = {lua_string(vehicle['display_name'])},",
    f"  handlingId = {lua_string(vehicle['handling_id'])},",
    "  events = {",
]
for hook in hooks:
    out.append(f"    {hook['id']} = {lua_string(hook['event'])},")
out.extend(["  },", "}", ""])
target = ROOT / system["generated_config"]
target.parent.mkdir(parents=True, exist_ok=True)
target.write_text("\n".join(out), encoding="utf-8")
print(f"Generated {target.relative_to(ROOT)} from {len(systems) + len(vehicles) + len(hooks)} sheet rows.")

