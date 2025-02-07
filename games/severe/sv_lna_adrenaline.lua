-- v1.02
-- game: Adrenaline
-- type: Players Esp
_G.settings = {
	["Aimbot"] = {
		["enabled"] = true,
		["jitter_fix"] = true,
		["max_distance"] = 400,
		["closes_to_crosshair"] = true,
		["aimbot_offset"] = {
			["x"] = 0,
			["y"] = 0,
		},

		["show_fov"] = true, -- false > off | true > on
		["fov_size"] = 220,
		["fov_color"] = { 255, 255, 255 },

		["smoothness"] = 1,
		["sensitivity"] = 1,

		["target_dot"] = true, -- false > off | true > on
		["target_dot_size"] = 5,
		["target_dot_color"] = { 255, 0, 0 },
	},

	["Esp"] = {
		["enabled"] = true, -- false > off | true > on

		["tracer"] = false, -- false > off | true > on
		["tracer_color"] = { 100, 100, 255 },
		["tracer_offset"] = {
			["y"] = -5,
		},

		["stick"] = false, -- false > off | true > on
		["stick_color"] = { 255, 255, 255 },
		["stick_offset"] = {
			["y"] = -2,
		},

		["name"] = true,
		["name_custom_text"] = "",
		["name_color"] = { 255, 255, 255 },
		["name_offset"] = {
			["x"] = 20,
			["y"] = -7,
		},

		["distance"] = true, -- false > off | true > on
		["distance_behind_text"] = "m",
		["distance_color"] = { 100, 100, 100 },
		["distance_offset"] = {
			["x"] = 20,
			["y"] = 5,
		},

		["head_dot"] = true, -- false > off | true > on
		["head_dot_size"] = 5,
		["head_dot_color"] = { 255, 255, 255 },
	},

	["Npc Path"] = { -- the path from game to the folder/model where the npc is located
		[1] = { "Workspace", "Players" },
	},
	["In Npc Path"] = { "Head" }, -- the path from the npc model to the target part
}

local localName = getname(getlocalplayer())
_G.cust_func = function(cachedData)
	return cachedData.name == localName
end

-- Main
loadstring(
	game:HttpGet("https://raw.githubusercontent.com/NotLockTheHobo/LocksNpcAimbot/refs/heads/main/src/severe.lua")
)()
