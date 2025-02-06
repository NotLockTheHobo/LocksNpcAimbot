<div align="center">
    <img src="assets/logo_censored.png" alt="" style="width: 20%">
    <h3>Lock's Npc Aimbot</h3>
</div>

### Status: [DISCONTINUED]
> I've lost interest in this project. It may contain bugs or performance issues.

## Contents
- [Download](#download)
- [Documentation](#documentation)


## Download
<details>
<summary> <b>Dx9ware [DISCONTINUED]</b> </summary>

[Source code](https://raw.githubusercontent.com/NotLockTheHobo/LocksNpcAimbot/refs/heads/main/src/dx9ware.lua)

</details>

<details>
<summary> <b>Severe [DISCONTINUED] - Last updated 6 feb 2025</b> </summary>
The current settings are configured for ESP items (No Big Deal).

```lua
-- v1.02
-- game: No Big Deal
-- type: items esp
_G.settings = {
	["Aimbot"] = {
		["enabled"] = false,
		["jitter_fix"] = true,
		["max_distance"] = 200,
		["closes_to_crosshair"] = true,
		["aimbot_offset"] = {
			["x"] = 0,
			["y"] = 0,
		},

		["show_fov"] = false, -- false > off | true > on
		["fov_size"] = 220,
		["fov_color"] = { 255, 255, 255 },

		["smoothness"] = 1,
		["sensitivity"] = 1,

		["target_dot"] = true, -- false > off | true > on
		["target_dot_size"] = 3,
		["target_dot_color"] = { 255, 5 - 0, 50 }, -- 5 - 0 = 5 WHY IS THIS HERE ????
	},

	["Esp"] = {
		["enabled"] = true, -- false > off | true > on

		["tracer"] = false, -- false > off | true > on
		["tracer_color"] = { 100, 100, 255 },
		["tracer_offset"] = {
			["y"] = -2,
		},

		["stick"] = false, -- false > off | true > on
		["stick_color"] = { 255, 255, 255 },
		["stick_offset"] = {
			["y"] = 2,
		},

		["name"] = true,
		["name_custom_text"] = "",
		["name_color"] = { 255, 255, 255 },
		["name_offset"] = {
			["x"] = 20,
			["y"] = -7,
		},

		["distance"] = false, -- false > off | true > on
		["distance_behind_text"] = "m",
		["distance_color"] = { 100, 100, 100 },
		["distance_offset"] = {
			["x"] = 20,
			["y"] = 5,
		},

		["head_dot"] = true, -- false > off | true > on
		["head_dot_size"] = 1,
		["head_dot_color"] = { 255, 255, 255 },
	},

	["Npc Path"] = { -- the path from game to the folder/model where the npc is located and you can make it select more then one model/folder
		[1] = { "Workspace" },
	},
	["In Npc Path"] = { "Root" }, -- the path from the npc model to the target part
}

-- Main
loadstring(game:HttpGet("https://raw.githubusercontent.com/NotLockTheHobo/LocksNpcAimbot/refs/heads/main/src/severe.lua"))()
```
</details>

## Documentation
> Being made
