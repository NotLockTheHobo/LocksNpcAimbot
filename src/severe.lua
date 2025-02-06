--[[
    Optimized Lock's Npc Aimbot | Version 1.02
    Original by: Lock the hobo
]]

if not settings then
	print("No settings found!")
	return
end

-- CORE SETTINGS
local REFRESH_RATE = 1 / 1000

-- Idk if this help
local sqrt = math.sqrt
local floor = math.floor
local pairs = pairs
local drawingnew = Drawing.new
local drawingclear = Drawing.clear
local getchildren = getchildren
local getposition = getposition
local worldtoscreenpoint = worldtoscreenpoint
local findservice = findservice
local findfirstchild = findfirstchild
local time = time
local spawn = spawn
local wait = wait
local mousemoverel = mousemoverel

local Workspace = findservice(Game, "Workspace")
local Camera = findfirstchild(Workspace, "Camera")

local screenDimensions = getscreendimensions()
local centerOfScreen = { screenDimensions.x / 2, screenDimensions.y / 2 }

local cachedNpcs = {}
local cachedPaths = {}

local function calculateDistance(p1, p2)
	local px, py, pz = p2.x - p1.x, p2.y - p1.y, p2.z - p1.z
	return sqrt(px * px + py * py + pz * pz)
end

local function Draw(drawingType, properties)
	local drawing = drawingnew(drawingType)
	for key, value in pairs(properties) do
		drawing[key] = value
	end
	return drawing
end

local fovCircle = Draw("Circle", {
	Color = settings.Aimbot.fov_color,
	Radius = settings.Aimbot.fov_size,
	Position = centerOfScreen,
	Thickness = 1,
	Visible = settings.Aimbot.show_fov,
})

local targetDot = Draw("Circle", {
	Visible = false,
	Color = settings.Aimbot.target_dot_color,
	Thickness = 1,
	Radius = settings.Aimbot.target_dot_size,
})

local function getInstanceFromPath(StartingInstance, pathTable, IGNORE_FIRST_INDEX)
	if not StartingInstance then
		return false
	end

	local CurrentInstance = StartingInstance
	local startIndex = IGNORE_FIRST_INDEX and 2 or 1

	for i = startIndex, #pathTable do
		CurrentInstance = findfirstchild(CurrentInstance, pathTable[i])
		if not CurrentInstance then
			return false
		end
	end

	return CurrentInstance
end

local espFunctions = {
	name = {
		init = function(cachedData)
			return Draw("Text", {
				Text = settings.Esp.name_custom_text ~= "" and settings.Esp.name_custom_text or cachedData.name,
				Color = settings.Esp.name_color,
				Outline = true,
				Center = true,
				Font = 1,
				Size = 10,
				Visible = settings.Esp.name,
			})
		end,

		update = function(drawing, cachedData)
			if not settings.Esp.name then
				drawing.Visible = false
				return
			end

			local offset = settings.Esp.name_offset
			local screenPos = cachedData.screenPos

			drawing.Position = { screenPos.x + offset.x, screenPos.y + offset.y }
			drawing.Visible = cachedData.onScreen
		end,
	},
}

local function getClosestTarget()
	local closestDistance = math.huge
	local closestNpc = nil
	local closestScreenPos = nil

	for _, cachedData in pairs(cachedNpcs) do
		if not cachedData.onScreen then
			continue
		end

		if cachedData.distance > settings.Aimbot.max_distance then
			continue
		end

		local screenPos = cachedData.screenPos

		local dx = screenPos.x - centerOfScreen[1]
		local dy = screenPos.y - centerOfScreen[2]
		local distFromCenter = sqrt(dx * dx + dy * dy)

		if distFromCenter > settings.Aimbot.fov_size then
			continue
		end

		local targetDistance = settings.Aimbot.closes_to_crosshair and distFromCenter or cachedData.distance

		if targetDistance < closestDistance then
			closestDistance = targetDistance
			closestNpc = cachedData
			closestScreenPos = screenPos
		end
	end

	return closestNpc, closestScreenPos
end

local function smoothMove(currentX, currentY, targetX, targetY)
	local smoothness = settings.Aimbot.smoothness

	local dx = (targetX - currentX) / smoothness
	local dy = (targetY - currentY) / smoothness

	return dx, dy
end

local function updateAimbot()
	if not settings.Aimbot.enabled or not isrightpressed() then
		targetDot.Visible = false
		return
	end

	local target, screenPos = getClosestTarget()
	if not target then
		targetDot.Visible = false
		return
	end

	if settings.Aimbot.target_dot then
		targetDot.Position = { screenPos.x, screenPos.y }
		targetDot.Visible = true
	end

	local aimX = screenPos.x + settings.Aimbot.aimbot_offset.x
	local aimY = screenPos.y + settings.Aimbot.aimbot_offset.y
	local moveX, moveY = smoothMove(centerOfScreen[1], centerOfScreen[2], aimX, aimY)

	mousemoverel(moveX, moveY)
end

local function updateCache(npc, cachedData)
	local position = getposition(cachedData.part)
	local screenPos, onScreen = worldtoscreenpoint({ position.x, position.y, position.z })

	cachedData.position = position
	cachedData.distance = calculateDistance(position, getposition(Camera))
	cachedData.screenPos = screenPos
	cachedData.onScreen = onScreen
end

local function cleanupDrawings(cachedData)
	for _, drawing in pairs(cachedData.drawings) do
		drawing:Remove()
	end
end

local function run()
	local currentActive = {}

	for _, Parent in pairs(cachedPaths) do
		for _, npc in pairs(getchildren(Parent)) do
			if getname(npc) == "shibadot" then
				continue
			end

			local cachedData = cachedNpcs[npc]

			if not cachedData then
				local npcPart = getInstanceFromPath(npc, settings["In Npc Path"])
				if not npcPart then
					continue
				end

				cachedData = {
					name = getname(npc),
					part = npcPart,
					npc = npc,
					position = nil,
					distance = nil,
					screenPos = nil,
					onScreen = nil,
					drawings = {},
				}

				for funcName, func in pairs(espFunctions) do
					cachedData.drawings[funcName] = func.init(cachedData)
				end

				cachedNpcs[npc] = cachedData
			end

			currentActive[npc] = true

			updateCache(npc, cachedData)

			for funcName, func in pairs(espFunctions) do
				func.update(cachedData.drawings[funcName], cachedData)
			end
		end
	end

	for npc, cachedData in pairs(cachedNpcs) do
		if not currentActive[npc] then
			cleanupDrawings(cachedData)
			cachedNpcs[npc] = nil
		end
	end

	updateAimbot()
end

local function initializePaths()
	for index, pathTable in pairs(settings["Npc Path"]) do
		cachedPaths[index] = getInstanceFromPath(Workspace, pathTable, true)
	end
end

local function initialize()
	initializePaths()

	spawn(function()
		while wait(REFRESH_RATE) do
			run()
		end
	end)
end

initialize()
