-- Generated from sheets/systems.json, sheets/vehicles.json, and sheets/hooks.json.
return {
  systemId = "buffalo_driving_benchmark",
  windowTitle = "Buffalo Street Telemetry",
  mode = "single-player",
  speedSource = "Cyberpunk vehicle GetCurrentSpeed; show raw engine value without unit conversion",
  distanceUnit = "world coordinate meters",
  vehicleId = "bravado_buffalo",
  vehicleDisplayName = "Bravado Buffalo",
  handlingId = "BUFFALO",
  events = {
    load_companion_profile = "onInit",
    sample_vehicle_telemetry = "onUpdate",
    draw_benchmark_panel = "onDraw",
  },
}
