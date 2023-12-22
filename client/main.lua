local PULSE = false
local PULSE_RADIUS = 0.1
local PULSE_RADIUS_NAX = 30.0
local PULSE_SPEED = 0.3
local PULSE_COLOR = {r = 119, g = 11, b = 227, a = 155}
local ORIGIN_COORDS = vec3(0.0, 0.0, 0.0)
local CLOSEST_TARGET = vec3(0.0, 0.0, 0.0)
local CLOSEST_ID = 0
local DISPLAYING = false
local DISPLAYING_OPTIONS = false

-- CACHE
local PlayerPedId = PlayerPedId
local GetEntityCoords = GetEntityCoords
local DrawMarker = DrawMarker
local Wait = Wait
local GetScreenCoordFromWorldCoord = GetScreenCoordFromWorldCoord

local function CheckInteract()
    if CLOSEST_TARGET ~= vec3(0.0, 0.0, 0.0) then
        local coords = GetEntityCoords(PlayerPedId())
        local dst = #(CLOSEST_TARGET - coords)
        if dst <= 1.2 and not DISPLAYING_OPTIONS then
            SendNUIMessage({
                type = "openOptions",
                id = CLOSEST_ID
            })
            SetNuiFocus(true, true)
            DISPLAYING_OPTIONS = true
        end
    end
end

local function GetNearbyTargets()
    local nearby = {}
    for id,target in pairs(TARGETS) do
        local coords = GetEntityCoords(PlayerPedId())
        local dst = #(target.coords - coords)
        if dst <= 30.0 then
            local id = #nearby + 1
            nearby[id] = target

            if dst <= 1.5 then
                if CLOSEST_TARGET ~= target.coords then 
                    local current_dst = #(CLOSEST_TARGET - coords)
                    local new_dst = #(target.coords - coords)

                    if current_dst > new_dst then
                        print("new closest target")
                        CLOSEST_TARGET = target.coords
                        CLOSEST_ID = target.id
                        if CLOSEST_ID == id and DISPLAYING_OPTIONS then
                            nearby[id].displayOptions = true
                        else
                            nearby[id].displayOptions = false
                        end
                        nearby[id].closest = true
                    else
                        nearby[id].closest = false
                    end
                end
            else
                if CLOSEST_TARGET == target.coords then
                    CLOSEST_TARGET = vec3(0.0, 0.0, 0.0)
                    CLOSEST_ID = 0
                    DISPLAYING_OPTIONS = false
                end
                nearby[id].closest = false
            end
        end
    end
    return nearby
end

local function CreatePulseTargets()
    local nearby = GetNearbyTargets()
    if CLOSEST_ID ~= 0 then
        nearby[CLOSEST_ID].displayOptions = DISPLAYING_OPTIONS
    end
    for k,v in pairs(nearby) do
        local _,x,y = GetScreenCoordFromWorldCoord(v.coords.x, v.coords.y, v.coords.z)
        nearby[k].x = x * 100
        nearby[k].y = y * 100
        SendNUIMessage({
            type = "update",
            target = nearby[k]
        })
    end
end

local function ResetPulse()
    PULSE_RADIUS = 0.1
    ORIGIN_COORDS = vec3(0.0, 0.0, 0.0)
    CLOSEST_TARGET = vec3(0.0, 0.0, 0.0)
    DISPLAYING = false
    DISPLAYING_OPTIONS = false
    SetNuiFocus(false, false)
    SendNUIMessage({
        type = "close",
    })
end

local function FadeDelay()
    local delay = 5000
    CreateThread(function()
        while delay >= 0 do
            if not DISPLAYING_OPTIONS then
                delay -= 1000
            end
            Wait(1000)
        end
        ResetPulse()
    end)
end

local function UpdatePulse()
    if PULSE_RADIUS >= PULSE_RADIUS_NAX then
        PULSE = false
    else
        PULSE_RADIUS = PULSE_RADIUS + PULSE_SPEED

        DrawMarker(1, -- Marker Type
            ORIGIN_COORDS.x, ORIGIN_COORDS.y, ORIGIN_COORDS.z + 0.2, -- Coords
            0.0, 0.0, 0.0,  -- Direction
            0.0, 0.0, 0.0,  -- Rotation
            PULSE_RADIUS, PULSE_RADIUS, 0.5, -- Scale
            PULSE_COLOR.r, PULSE_COLOR.g, PULSE_COLOR.b, PULSE_COLOR.a, -- Color
            false, -- Bob up and down.
            false, -- face player camera.
            2, -- unknown : set to 2
            false, -- rotate ? applies to heading.
            nil, -- texture dict
            nil, -- texture name
            false -- Draw on entity.
        )
    end
end

local function CreatePulse()
    if not PULSE then return end
    local ped = PlayerPedId()
    ORIGIN_COORDS = GetEntityCoords(ped)

    SendNUIMessage({
        type = "open",
    })

    CreateThread(function()
        while PULSE do          
            UpdatePulse()
            Wait(0)
        end
    end)

    if not DISPLAYING then
        DISPLAYING = true
        CreateThread(function()
            FadeDelay()
            while DISPLAYING do
                CreatePulseTargets()
                Wait(0)
            end
        end)
    end
    
end

-- NUI Callbacks
RegisterNUICallback('close', function(data, cb)
    SetNuiFocus(false, false)
    DISPLAYING_OPTIONS = false
    cb('ok')
end)

RegisterNUICallback('SelectedOption', function(data, cb)
    local target = TARGETS[data.target]
    if target then
        if target.options[data.option] then
            if target.options[data.option].client then
                TriggerEvent(target.options[data.option].client, target)
            elseif target.options[data.option].server then
                TriggerServerEvent(target.options[data.option].server, target)
            else
                print("Invalid Selection Event")
            end
        end
    end
    SetNuiFocus(false, false)
    ResetPulse()
    cb('ok')
end)

-- Command Stuff
RegisterCommand('+pulse', function()
    PULSE = true
    CreatePulse()
end, false)
RegisterKeyMapping('+pulse', 'activate pulse', 'keyboard', 'o')

RegisterCommand('+interactpulse', function()
    CheckInteract()
end, false)
RegisterKeyMapping('+interactpulse', 'Interact with a pulse target', 'keyboard', 'e')
