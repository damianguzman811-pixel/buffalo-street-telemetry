local CONFIG = require("config")

local state = {
  open = true,
  profile = nil,
  profileError = "Companion profile missing. Start with RunLocal.ps1.",
  active = false,
  finished = false,
  elapsed = 0.0,
  distance = 0.0,
  peakSpeed = 0.0,
  currentSpeed = 0.0,
  previousPosition = nil,
}

local function readProfile()
  local file = io.open("profile.ini", "r")
  if file == nil then
    state.profile = nil
    state.profileError = "Companion profile missing. Start with RunLocal.ps1."
    return
  end

  local profile = {}
  for line in file:lines() do
    local key, value = string.match(line, "^([%w_]+)=(.*)$")
    if key ~= nil then
      profile[key] = value
    end
  end
  file:close()

  if profile.handling_id ~= CONFIG.handlingId or profile.model_name ~= "buffalo" then
    state.profile = nil
    state.profileError = "GTA companion file did not resolve to the stock Buffalo record."
    return
  end
  state.profile = profile
  state.profileError = nil
end

local function resetRun()
  state.elapsed = 0.0
  state.distance = 0.0
  state.peakSpeed = 0.0
  state.currentSpeed = 0.0
  state.previousPosition = nil
  state.finished = false
end

registerForEvent(CONFIG.events.load_companion_profile, function()
  readProfile()
  print("[Buffalo Street Telemetry] Ready; companion profile " .. (state.profile and "loaded." or "not loaded."))
end)

registerForEvent(CONFIG.events.sample_vehicle_telemetry, function(deltaTime)
  if not state.active then
    return
  end

  local ok, vehicle = pcall(function()
    local player = Game.GetPlayer()
    if player == nil then return nil end
    return Game["GetMountedVehicle;GameObject"](player)
  end)
  if not ok or vehicle == nil then
    state.previousPosition = nil
    return
  end

  local sampleOk, position, speed = pcall(function()
    return vehicle:GetWorldPosition(), vehicle:GetCurrentSpeed()
  end)
  if not sampleOk or position == nil then
    state.previousPosition = nil
    return
  end

  local dt = math.max(0.0, math.min(tonumber(deltaTime) or 0.0, 0.25))
  state.elapsed = state.elapsed + dt
  state.currentSpeed = tonumber(speed) or 0.0
  state.peakSpeed = math.max(state.peakSpeed, state.currentSpeed)

  local previous = state.previousPosition
  if previous ~= nil then
    local dx = position.x - previous.x
    local dy = position.y - previous.y
    local dz = position.z - previous.z
    local step = math.sqrt(dx * dx + dy * dy + dz * dz)
    -- Ignore large teleports so they cannot inflate a benchmark.
    if step <= 15.0 then
      state.distance = state.distance + step
    end
  end
  state.previousPosition = position
end)

registerForEvent(CONFIG.events.draw_benchmark_panel, function()
  if not state.open then
    return
  end

  ImGui.SetNextWindowSize(430, 410, ImGuiCond.FirstUseEver)
  local visible = ImGui.Begin(CONFIG.windowTitle, true)
  if visible then
    ImGui.Text("NIGHT CITY RUN // GTA V LEGACY COMPANION")
    ImGui.Separator()
    if state.profile == nil then
      ImGui.Text("GTA V profile: unavailable")
      ImGui.Text(state.profileError or "Run the local launcher to refresh the profile.")
    else
      ImGui.Text("Reference: " .. (state.profile.brand or "BRAVADO") .. " " .. (state.profile.model_name or "BUFFALO"))
      ImGui.Text("GTA handling ID: " .. state.profile.handling_id)
      ImGui.Text("fMass: " .. (state.profile.fMass or "—"))
      ImGui.Text("fInitialDriveForce: " .. (state.profile.fInitialDriveForce or "—"))
      ImGui.Text("nInitialDriveGears: " .. (state.profile.nInitialDriveGears or "—"))
      ImGui.Text("fInitialDriveMaxFlatVel: " .. (state.profile.fInitialDriveMaxFlatVel or "—"))
      ImGui.Text("fBrakeForce: " .. (state.profile.fBrakeForce or "—"))
      ImGui.Text("fSteeringLock: " .. (state.profile.fSteeringLock or "—"))
      ImGui.Text("fTractionCurveMax / Min: " .. (state.profile.fTractionCurveMax or "—") .. " / " .. (state.profile.fTractionCurveMin or "—"))
      ImGui.Text("fSuspensionForce: " .. (state.profile.fSuspensionForce or "—"))
      ImGui.Text("Source: player-owned GTA V Legacy base update.rpf")
    end

    ImGui.Separator()
    if not state.active then
      if ImGui.Button(state.finished and "Start new benchmark" or "Start driving benchmark") then
        resetRun()
        state.active = true
      end
    else
      if ImGui.Button("Finish benchmark") then
        state.active = false
        state.finished = true
        state.previousPosition = nil
      end
    end
    ImGui.SameLine()
    if ImGui.Button("Hide panel") then
      state.open = false
    end

    ImGui.Text(state.active and "Status: RECORDING — drive any Cyberpunk vehicle" or (state.finished and "Status: RUN COMPLETE" or "Status: READY"))
    ImGui.Text(string.format("Time in vehicle: %.1f s", state.elapsed))
    ImGui.Text(string.format("Distance: %.1f m", state.distance))
    ImGui.Text(string.format("Current Cyberpunk speed value: %.2f", state.currentSpeed))
    ImGui.Text(string.format("Peak Cyberpunk speed value: %.2f", state.peakSpeed))
    ImGui.Text("Speed values keep each game's native scale; compare as references, not equal units.")
  end
  ImGui.End()
end)

registerHotkey("BuffaloStreetTelemetryToggle", "Show Buffalo Street Telemetry", function()
  state.open = not state.open
end)

