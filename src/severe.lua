--[[
    Lock's Npc Aimbot (ported from dx9 to severe) | Version 1.1
	Coded by: Lock the hobo
	Game: No big deal
]]

if not settings then 
    print("No settings found!")
    
    return
end

local REFRESH_RATE = 1/100

local Workspace = findservice(Game, "Workspace")
local Camera = findfirstchild(Workspace, "Camera")

local sqrt = math.sqrt
local floor = math.floor

local screenDimensions = getscreendimensions()
local centerOfScreen = {screenDimensions.x / 2, screenDimensions.y / 2}

local cachedNpcs = {}
local cachedBlacklistedNpcs = {}
local cachedPaths = {}
local lastUpdate = 0

local function calculateDistance(p1, p2)
    local dx = p2.x - p1.x
    local dy = p2.y - p1.y
    local dz = p2.z - p1.z
    return sqrt(dx * dx + dy * dy + dz * dz)
end

local function getInstanceFromPath(StartingInstance, pathTable, IGNORE_FIRST_INDEX)
    if not StartingInstance then return nil end
    
    local CurrentInstance = StartingInstance
    local startIndex = IGNORE_FIRST_INDEX and 2 or 1
    
    for i = startIndex, #pathTable do
        CurrentInstance = findfirstchild(CurrentInstance, pathTable[i])
        if not CurrentInstance then return nil end
    end
    
    return CurrentInstance
end

local function Draw(drawingType, properties)
    local drawing = Drawing.new(drawingType)
    for key, value in pairs(properties) do
        drawing[key] = value
    end
    return drawing
end

local espFunctions = {
    headdot = {
        init = function(cachedData)
            local settings = settings["Esp"]
            return Draw("Circle", {
                Color = settings["head_dot_color"],
                Radius = settings["head_dot_size"],
                Thickness = 1,
                Visible = settings["head_dot"]
            })
        end,
        update = function(drawing, cachedData, screenPos, onScreen)
            if not settings["Esp"]["head_dot"] then return end
            
            drawing.Position = {screenPos.x, screenPos.y}
            drawing.Radius = settings["Esp"]["head_dot_size"] / (cachedData.distance / 100)
            drawing.Visible = onScreen
        end
    },
    
    stick = {
        init = function(cachedData)
            local settings = settings["Esp"]
            return Draw("Line", {
                Color = settings["stick_color"],
                Thickness = 1,
                Visible = settings["stick"]
            })
        end,
        update = function(drawing, cachedData, screenPos, onScreen)
            if not settings["Esp"]["stick"] then return end
            
            local bottomScreenPos, bottomOnScreen = WorldToScreenPoint({
                cachedData.position.x,
                cachedData.position.y + settings["Esp"]["stick_offset"]["y"],
                cachedData.position.z
            })
            
            drawing.To = {screenPos.x, screenPos.y}
            drawing.From = {bottomScreenPos.x, bottomScreenPos.y}
            drawing.Visible = onScreen and bottomOnScreen
        end
    },
    
    tracer = {
        init = function(cachedData)
            local settings = settings["Esp"]
            return Draw("Line", {
                Color = settings["tracer_color"],
                Thickness = 1,
                Visible = settings["tracer"]
            })
        end,
        update = function(drawing, cachedData, screenPos, onScreen)
            if not settings["Esp"]["tracer"] then return end
            
            drawing.To = {screenPos.x, screenPos.y}
            drawing.From = centerOfScreen
            drawing.Visible = onScreen
        end
    },
    
    distance = {
        init = function(cachedData)
            local settings = settings["Esp"]
            return Draw("Text", {
                Text = cachedData.name .. settings["distance_behind_text"],
                Color = settings["distance_color"],
                Outline = true,
                Center = true,
                Font = 1,
                Size = 10,
                Visible = settings["distance"]
            })
        end,
        update = function(drawing, cachedData, screenPos, onScreen)
            if not settings["Esp"]["distance"] then return end
            
            local offset = settings["Esp"]["distance_offset"]
            drawing.Position = {screenPos.x + offset["x"], screenPos.y + offset["y"]}
            drawing.Text = floor(cachedData.distance) .. settings["Esp"]["distance_behind_text"]
            drawing.Visible = onScreen
        end
    },
    
    name = {
        init = function(cachedData)
            local settings = settings["Esp"]
            local customText = settings["name_custom_text"]
            return Draw("Text", {
                Text = customText ~= "" and customText or cachedData.name,
                Color = settings["name_color"],
                Outline = true,
                Center = true,
                Font = 1,
                Size = 10,
                Visible = settings["name"]
            })
        end,
        update = function(drawing, cachedData, screenPos, onScreen)
            if not settings["Esp"]["name"] then return end
            
            local offset = settings["Esp"]["name_offset"]
            drawing.Position = {screenPos.x + offset["x"], screenPos.y + offset["y"]}
            drawing.Visible = onScreen
        end
    }
}

local function updateNPC(npc, cachedData)
    local position = getposition(cachedData.part)
    local screenPos, onScreen = WorldToScreenPoint({position.x, position.y, position.z})
    
    if not onScreen then
        for _, drawing in pairs(cachedData.drawings) do
            drawing.Visible = false
        end
        return
    end
    
    cachedData.position = position
    cachedData.distance = calculateDistance(position, getposition(Camera))
    
    for funcName, func in pairs(espFunctions) do
        func.update(cachedData.drawings[funcName], cachedData, screenPos, onScreen)
    end
end

local function cleanupDrawings(cachedData)
    for _, drawing in pairs(cachedData.drawings) do
        drawing:Remove()
    end
    cachedData.drawings = {}
end

local function run()
    for _, Parent in pairs(cachedPaths) do
        if not Parent then continue end
        
        -- Remove nil npcs
        for npc, cachedData in pairs(cachedNpcs) do
            if not cachedData.part then
                cleanupDrawings(cachedData)
                cachedNpcs[npc] = nil
            end
        end
        
        -- Main loop
        for _, npc in pairs(getchildren(Parent)) do
            if cachedBlacklistedNpcs[npc] then continue end
            
            local cachedData = cachedNpcs[npc]
            if not cachedData then
                -- Init new NPC data
                local npcPart = getInstanceFromPath(npc, settings["In Npc Path"])
                if not npcPart then
                    cachedBlacklistedNpcs[npc] = true
                    continue
                end
                
                cachedData = {
                    name = getname(npc),
                    part = npcPart,
                    position = nil,
                    distance = nil,
                    drawings = {}
                }
                
                -- Init drawings
                for funcName, func in pairs(espFunctions) do
                    cachedData.drawings[funcName] = func.init(cachedData)
                end
                
                cachedNpcs[npc] = cachedData
            end
            
            -- Update esp
            updateNPC(npc, cachedData)
        end
    end
end

local function initializePaths()
    for index, pathTable in pairs(settings["Npc Path"]) do
        cachedPaths[index] = getInstanceFromPath(Workspace, pathTable, true)
    end
end

-- Main
local function initialize()
    initializePaths()
    
    spawn(function()
        local currentTick = time()
        _G.e = currentTick
        Drawing.clear()
        
        while currentTick == _G.e do
            
			local currentTime = time()
			if currentTime - lastUpdate < REFRESH_RATE then continue end

			lastUpdate = currentTime

            run()

        end
    end)
end

initialize()