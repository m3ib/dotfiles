local Conf = require("hyprland.config")

local mainMod = "SUPER"
-- apps
local terminal = "kitty"
local browser = "zen-browser"
local browserAlt = "brave"
local files = "thunar"
local filesAlt = "kitty ranger"

---Compute the global id from the local workspace-group one.
---@param w integer ID local to the workspace-group.
---@return integer
local function get_workspace(w)
  local wsGroup = math.floor((hl.get_active_workspace().id - 1) / 10) * 10
  return wsGroup + w
end

---Compute the global id of the given group and group-local workspace id.
---@param g integer 0-index group id in the current monitor.
---@param w integer ID local to the workspace-group.
---@return integer
local function get_workspace_in_group(g, w)
  local mon = hl.get_active_monitor().id * Conf.monWsCount
  return (g * 10) + w + mon
end

---Compute an equivalent workspace id to the current workspace in the given monitor.
---@param monId integer
---@return integer
local function get_equiv_worksapce_in_mon(monId)
  local activeWs = hl.get_active_workspace().id
  local activeMon = hl.get_active_monitor().id
  local mon = monId and monId or activeMon

  local diff = mon - activeMon
  return activeWs + (diff * Conf.monWsCount)
end

---Get a workspace id that's relative to the active one without leaving monitors bound.
---Note: "Monitors bound" means workspaces that are not owned by any monitor.
---@param delta integer A positive or negative value.
---@return integer
local function get_relative_workspace(delta)
  local activeWs = hl.get_active_workspace().id
  return math.max(0, math.min(activeWs + delta, Conf.maxWsId))
end

hl.bind(
  mainMod .. " + Super_L",
  hl.dsp.exec_cmd('rofi -show combi -modes "combi,Emoji:$HOME/.config/hypr/scripts/emoji.sh"')
)

hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(browser))
hl.bind(mainMod .. " + SHIFT + B", hl.dsp.exec_cmd(browserAlt))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(files))
hl.bind(mainMod .. " + SHIFT + E", hl.dsp.exec_cmd(filesAlt))

-- window operations
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + SHIFT + Q", hl.dsp.window.kill())
hl.bind(mainMod .. " + W", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + C", hl.dsp.window.center())
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen())
hl.bind(mainMod .. " + SHIFT + F", hl.dsp.window.fullscreen({ mode = "maximized" }))
hl.bind(mainMod .. " + comma", hl.dsp.window.pin())

-- move focus
hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "down" }))

-- move window
hl.bind(mainMod .. " + SHIFT + H", hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.window.move({ direction = "right" }))
hl.bind(mainMod .. " + SHIFT + K", hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " + SHIFT + J", hl.dsp.window.move({ direction = "down" }))

-- move window to monitor's active workspace
hl.bind(mainMod .. " + CTRL + H", hl.dsp.window.move({ monitor = "l" }))
hl.bind(mainMod .. " + CTRL + L", hl.dsp.window.move({ monitor = "r" }))
-- -- I have no vertical monitors
-- hl.bind(mainMod .. " + CTRL + K", hl.dsp.window.move({ monitor = "u" }))
-- hl.bind(mainMod .. " + CTRL + J", hl.dsp.window.move({ monitor = "d" }))

-- move window to monitor's equivalent workspace
hl.bind(mainMod .. " + ALT + H", function()
  local mon = hl.get_monitor("l")
  hl.dispatch(hl.dsp.window.move({ workspace = get_equiv_worksapce_in_mon(mon and mon.id or nil) }))
end)
hl.bind(mainMod .. " + ALT + L", function()
  local mon = hl.get_monitor("r")
  hl.dispatch(hl.dsp.window.move({ workspace = get_equiv_worksapce_in_mon(mon and mon.id or nil) }))
end)
-- -- I have no vertical monitors
-- hl.bind(mainMod .. " + ALT + K", function()
-- local mon = hl.get_monitor("u")
--   hl.dispatch(hl.dsp.window.move({ workspace = get_equiv_worksapce_in_mon(mon and mon.id or nil) }))
-- end)
-- hl.bind(mainMod .. " + ALT + J", function()
-- local mon = hl.get_monitor("d")
--   hl.dispatch(hl.dsp.window.move({ workspace = get_equiv_worksapce_in_mon(mon and mon.id or nil) }))
-- end)

-- next/prev non-empty workspace
hl.bind(mainMod .. " + N", hl.dsp.focus({ workspace = "e+1" }), { repeating = true })
hl.bind(mainMod .. " + P", hl.dsp.focus({ workspace = "e-1" }), { repeating = true })
-- next/prev any workspace
hl.bind(mainMod .. " + SHIFT + N", function()
  hl.dispatch(hl.dsp.focus({ workspace = get_relative_workspace(1) }), { repeating = true })
end)
hl.bind(mainMod .. " + SHIFT + P", function()
  hl.dispatch(hl.dsp.focus({ workspace = get_relative_workspace(-1) }), { repeating = true })
end)

-- move focus to next/prev workspace group
hl.bind(mainMod .. " + Prior", function()
  hl.dispatch(hl.dsp.focus({ workspace = get_relative_workspace(10) }))
end, { repeating = true })
hl.bind(mainMod .. " + Next", function()
  hl.dispatch(hl.dsp.focus({ workspace = get_relative_workspace(-10) }))
end, { repeating = true })

-- move window to next/prev workspace group
hl.bind(mainMod .. " + SHIFT + Prior", function()
  hl.dispatch(hl.dsp.window.move({ workspace = get_relative_workspace(10) }))
end, { repeating = true })
hl.bind(mainMod .. " + SHIFT + Next", function()
  hl.dispatch(hl.dsp.window.move({ workspace = get_relative_workspace(-10) }))
end, { repeating = true })

-- move window to next/prev workspace group (no follow)
hl.bind(mainMod .. " + ALT + Prior", function()
  hl.dispatch(hl.dsp.window.move({ workspace = get_relative_workspace(10), follow = false }))
end, { repeating = true })
hl.bind(mainMod .. " + ALT + Next", function()
  hl.dispatch(hl.dsp.window.move({ workspace = get_relative_workspace(-10), follow = false }))
end, { repeating = true })

-- switch workspaces with mainMod + [0-9]
-- move active window to a workspace with mainMod + SHIFT + [0-9]
for w = 1, 10 do
  local key = w % 10 -- 10 maps to key 0

  hl.bind(mainMod .. " + " .. key, function()
    hl.dispatch(hl.dsp.focus({ workspace = get_workspace(w) }))
  end)
  -- move to group
  hl.bind(mainMod .. " + CTRL + " .. key, function()
    local activeW = hl.get_active_workspace().id
    hl.dispatch(hl.dsp.window.move({ workspace = get_workspace_in_group(w - 1, activeW % 10) }))
  end)
  hl.bind(mainMod .. " + CTRL + ALT + " .. key, function()
    local activeW = hl.get_active_workspace().id
    hl.dispatch(hl.dsp.window.move({ workspace = get_workspace_in_group(w - 1, activeW % 10), follow = false }))
  end)
  -- move to local workspace [1-10]
  hl.bind(mainMod .. " + SHIFT + " .. key, function()
    hl.dispatch(hl.dsp.window.move({ workspace = get_workspace(w) }))
  end)
  hl.bind(mainMod .. " + ALT + " .. key, function()
    hl.dispatch(hl.dsp.window.move({ workspace = get_workspace(w), follow = false }))
  end)
end

-- example special workspace (scratchpad)
hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))
hl.bind(mainMod .. " + ALT + S", hl.dsp.window.move({ workspace = "special:magic", follow = false }))

-- scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- layout specific
hl.bind(mainMod .. " + T", hl.dsp.layout("togglesplit"))
hl.bind(mainMod .. " + M", hl.dsp.layout("swapsplit"))

-- laptop multimedia keys for volume and LCD brightness
hl.bind("XF86AudioRaiseVolume", hl.dsp.global("volume:increment"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.global("volume:decrement"), { locked = true, repeating = true })
hl.bind(
  "XF86AudioMute",
  hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
  { locked = true, repeating = true }
)
hl.bind(
  "XF86AudioMicMute",
  hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
  { locked = true, repeating = true }
)
hl.bind("XF86MonBrightnessUp", hl.dsp.global("brightness:increment"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.global("brightness:decrement"), { locked = true, repeating = true })
-- pretty handy
hl.bind("ALT + XF86AudioRaiseVolume", hl.dsp.global("brightness:increment"), { locked = true, repeating = true })
hl.bind("ALT + XF86AudioLowerVolume", hl.dsp.global("brightness:decrement"), { locked = true, repeating = true })

hl.bind(mainMod .. " + CTRL + SHIFT + P", hl.dsp.exec_cmd("systemctl poweroff"), { locked = true })
hl.bind(mainMod .. " + CTRL + SHIFT + R", hl.dsp.exec_cmd("systemctl reboot"), { locked = true })
hl.bind(mainMod .. " + CTRL + SHIFT + S", hl.dsp.exec_cmd("systemctl suspend"), { locked = true })
hl.bind(mainMod .. " + CTRL + SHIFT + L", hl.dsp.exec_cmd("loginctl lock-session"), { locked = true })

-- requires playerctl
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("Pause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

-- utilities
hl.bind(mainMod .. " + F2", hl.dsp.exec_cmd("echo -n $(hyprpicker) | wl-copy"))

-- quickshell
hl.bind(mainMod .. " + Tab", hl.dsp.exec_cmd("qs ipc call workspaces toggle"))
hl.bind(mainMod .. " + bracketLeft", hl.dsp.exec_cmd("qs ipc call leftBar toggle"))
hl.bind(mainMod .. " + bracketRight", hl.dsp.exec_cmd("qs ipc call rightBar toggle"))
hl.bind("Print", hl.dsp.exec_cmd("qs ipc call screenshot toggle"))
