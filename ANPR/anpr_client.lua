local anprCameras = {
    {name = "205", coords = vector3(223.00, -1042.60, 29.40), radius = 25.0},
    {name = "134", coords = vector3(104.11, -1363.77, 29.10), radius = 25.0},
    {name = "110/109", coords = vector3(-127.66, -1738.60, 29.89), radius = 25.0},
    {name = "81 - Main carrigeway", coords = vector3(-763.85, -2182.47, 15.26), radius = 25.0},
    {name = "361", coords = vector3(-770.00, -1116.10, 10.46), radius = 25.0},
    {name = "663", coords = vector3(-1038.81, -192.10, 37.62), radius = 25.0},
    {name = "595-594", coords = vector3(470.93, -311.69, 46.85), radius = 25.0},
    {name = "62 - bridge", coords = vector3(814.19, -2623.73, 52.42), radius = 25.0},
    {name = "87 - bridge", coords = vector3(-498.72, -2265.92, 61.43), radius = 25.0},
    {name = "191 - A1", coords = vector3(1573.21, -983.65, 59.78), radius = 25.0},
    -- Add more cameras if/when needed
}

local vehicleMarkers = {} -- Store markers for vehicles
local anprCooldowns = {} -- Store cooldowns for ANPR pings
local anprVisible = false -- Toggle for ANPR ping visibility

function GetDistance(coords1, coords2)
    return #(coords1 - coords2)
end

function GetCardinalDirection(heading)
    local cardinalDirections = {"North", "North West", "West", "South West", "South", "South East", "East", "North East"}
    local index = math.floor(((heading + 22.5) % 360) / 45) + 1 -- Rounds a float to the nearest whole integer 
    return cardinalDirections[index]
end

function GetColorName(color)
    local colorNames = {
        [0] = "Metallic Black",
        [1] = "Metallic Graphite Black",
        [2] = "Metallic Black Steel",
        [3] = "Metallic Dark Silver",
        [4] = "Metallic Silver",
        [5] = "Metallic Blue Silver",
        [6] = "Metallic Steel Gray",
        [7] = "Metallic Shadow Silver",
        [8] = "Metallic Stone Silver",
        [9] = "Metallic Midnight Silver",
        [10] = "Metallic Gun Metal",
        [11] = "Metallic Anthracite Grey",
        [12] = "Matte Black",
        [13] = "Matte Gray",
        [14] = "Matte Light Grey",
        [15] = "Util Black",
        [16] = "Util Black Poly",
        [17] = "Util Dark Silver",
        [18] = "Util Silver",
        [19] = "Util Gun Metal",
        [20] = "Util Shadow Silver",
        [21] = "Worn Black",
        [22] = "Worn Graphite",
        [23] = "Worn Silver Grey",
        [24] = "Worn Silver",
        [25] = "Worn Blue Silver",
        [26] = "Worn Shadow Silver",
        [27] = "Metallic Red",
        [28] = "Metallic Torino Red",
        [29] = "Metallic Formula Red",
        [30] = "Metallic Blaze Red",
        [31] = "Metallic Graceful Red",
        [32] = "Metallic Garnet Red",
        [33] = "Metallic Desert Red",
        [34] = "Metallic Cabernet Red",
        [35] = "Metallic Candy Red",
        [36] = "Metallic Sunrise Orange",
        [37] = "Metallic Classic Gold",
        [38] = "Metallic Orange",
        [39] = "Matte Red",
        [40] = "Matte Dark Red",
        [41] = "Matte Orange",
        [42] = "Matte Yellow",
        [43] = "Util Red",
        [44] = "Util Bright Red",
        [45] = "Util Garnet Red",
        [46] = "Worn Red",
        [47] = "Worn Golden Red",
        [48] = "Worn Dark Red",
        [49] = "Metallic Dark Green",
        [50] = "Metallic Racing Green",
        [51] = "Metallic Sea Green",
        [52] = "Metallic Olive Green",
        [53] = "Metallic Green",
        [54] = "Metallic Gasoline Blue Green",
        [55] = "Matte Lime Green",
        [56] = "Util Dark Green",
        [57] = "Util Green",
        [58] = "Worn Dark Green",
        [59] = "Worn Green",
        [60] = "Worn Sea Wash",
        [61] = "Metallic Midnight Blue",
        [62] = "Metallic Dark Blue",
        [63] = "Metallic Saxony Blue",
        [64] = "Metallic Blue",
        [65] = "Metallic Mariner Blue",
        [66] = "Metallic Harbor Blue",
        [67] = "Metallic Diamond Blue",
        [68] = "Metallic Surf Blue",
        [69] = "Metallic Nautical Blue",
        [70] = "Metallic Bright Blue",
        [71] = "Metallic Purple Blue",
        [72] = "Metallic Spinnaker Blue",
        [73] = "Metallic Ultra Blue",
        [74] = "Metallic Bright Blue",
        [75] = "Util Dark Blue",
        [76] = "Util Midnight Blue",
        [77] = "Util Blue",
        [78] = "Util Sea Foam Blue",
        [79] = "Util Lightning Blue",
        [80] = "Util Maui Blue Poly",
        [81] = "Util Bright Blue",
        [82] = "Matte Dark Blue",
        [83] = "Matte Blue",
        [84] = "Matte Midnight Blue",
        [85] = "Worn Dark Blue",
        [86] = "Worn Blue",
        [87] = "Worn Light Blue",
        [88] = "Metallic Taxi Yellow",
        [89] = "Metallic Race Yellow",
        [90] = "Metallic Bronze",
        [91] = "Metallic Yellow Bird",
        [92] = "Metallic Lime",
        [93] = "Metallic Champagne",
        [94] = "Metallic Pueblo Beige",
        [95] = "Metallic Dark Ivory",
        [96] = "Metallic Choco Brown",
        [97] = "Metallic Golden Brown",
        [98] = "Metallic Light Brown",
        [99] = "Metallic Straw Beige",
        [100] = "Metallic Moss Brown",
        [101] = "Metallic Biston Brown",
        [102] = "Metallic Beechwood",
        [103] = "Metallic Dark Beechwood",
        [104] = "Metallic Choco Orange",
        [105] = "Metallic Beach Sand",
        [106] = "Metallic Sun Bleached Sand",
        [107] = "Metallic Cream",
        [108] = "Util Brown",
        [109] = "Util Medium Brown",
        [110] = "Util Light Brown",
        [111] = "Metallic White",
        [112] = "Metallic Frost White",
        [113] = "Worn Honey Beige",
        [114] = "Worn Brown",
        [115] = "Worn Dark Brown",
        [116] = "Worn Straw Beige",
        [117] = "Brushed Steel",
        [118] = "Brushed Black Steel",
        [119] = "Brushed Aluminium",
        [120] = "Chrome",
        [121] = "Worn Off White",
        [122] = "Util Off White",
        [123] = "Worn Orange",
        [124] = "Worn Light Orange",
        [125] = "Metallic Securicor Green",
        [126] = "Worn Taxi Yellow",
        [127] = "Police Car Blue",
        [128] = "Matte Green",
        [129] = "Matte Brown",
        [130] = "Worn Orange",
        [131] = "Matte White",
        [132] = "Worn White",
        [133] = "Worn Olive Army Green",
        [134] = "Pure White",
        [135] = "Hot Pink",
        [136] = "Salmon Pink",
        [137] = "Metallic Vermillion Pink",
        [138] = "Orange",
        [139] = "Green",
        [140] = "Blue",
        [141] = "Metallic Black Blue",
        [142] = "Metallic Black Purple",
        [143] = "Metallic Black Red",
        [144] = "Hunter Green",
        [145] = "Metallic Purple",
        [146] = "Metallic Very Dark Blue",
        [147] = "Modshop Black",
        [148] = "Matte Purple",
        [149] = "Matte Dark Purple",
        [150] = "Metallic Lava Red",
        [151] = "Matte Forest Green",
        [152] = "Matte Olive Drab",
        [153] = "Matte Desert Brown",
        [154] = "Matte Desert Tan",
        [155] = "Matte Foliage Green",
        [156] = "Default Alloy Color",
        [157] = "Epsilon Blue",
        [158] = "Pure Gold",
        [159] = "Brushed Gold"
        -- Add more colors as needed
    }
    return colorNames[color] or "Unknown Color"
end


function GetVehicleClassName(class)
    local classNames = {
        [0] = "Compact",
        [1] = "Sedan",
        [2] = "SUV",
        [3] = "Coupe",
        [4] = "Muscle",
        [5] = "Sports Classic",
        [6] = "Sport",
        [7] = "Super",
        [8] = "Motorcycle",
        [9] = "Off-road",
        [10] = "Industrial",
        [11] = "Utility",
        [12] = "Van",
        [13] = "Cycles",
        [14] = "Service",
        [15] = "Emergency",
        [16] = "Military",
        [17] = "Commercial",
    }
    return classNames[class] or "Unknown"
end

-- Modify CheckANPRCameras to show ANPR events for all plates if no active ping plate
function CheckANPRCameras()
    local playerPed = GetPlayerPed(-1)
    local coords = GetEntityCoords(playerPed)

    for _, camera in ipairs(anprCameras) do
        local distance = GetDistance(coords, camera.coords)

        if distance <= camera.radius then
            local vehicle = GetVehiclePedIsIn(playerPed, false)
            if DoesEntityExist(vehicle) and IsEntityAVehicle(vehicle) then
                local plate = GetVehicleNumberPlateText(vehicle)

                local markers = vehicleMarkers[plate] or {}
                local status = #markers > 0 and "Markers: " .. table.concat(markers, ", ") or "No Status"

                if status ~= "No Status" then
                    local heading = GetEntityHeading(vehicle)
                    local direction = GetCardinalDirection(heading)

                    local primaryColor, _ = GetVehicleColours(vehicle)
                    local primaryColorName = GetColorName(primaryColor)

                    -- Get the type of the vehicle
                    local vehicleClass = GetVehicleClass(vehicle)

                    if not anprCooldowns[plate] or anprCooldowns[plate] <= 0 then
                        if anprVisible and (not activePingPlate or activePingPlate == plate) then
                            local vehicleClass = GetVehicleClass(vehicle)
                            local vehicleClassName = GetVehicleClassName(vehicleClass)
                
                            TriggerServerEvent('anpr:plateDetected', plate, status, heading, direction, camera.name, primaryColorName, vehicleClassName)
                            TriggerEvent('chatMessage', 'Attention', {255, 255, 0}, '~r~VRN:  ' .. plate .. ' ~w~- ~b~Postal: ' .. camera.name .. ' ~w~-~r~ ' .. status .. ' ~w~- ~g~Heading: ' .. direction .. ' ~w~- ~y~Color: ' .. primaryColorName .. ' ~w~- ~g~Type: ' .. vehicleClassName)
                        end
                        anprCooldowns[plate] = 20 -- Default cooldown for when /pinganpr is not active - can be changed
                    end
                end
            end
        end
    end
end


-- Define allowed marker types that can be added to a plate
local allowedMarkers = {"FTS", "Stolen", "Scrapped", "Written off", "Firearms", "Drugs intel", "Wanted", "Mot", "Tax", "Insurance"}

-- Command to set a marker on the vehicle
RegisterCommand('setmarker', function(source, args, rawCommand)
    local playerPed = GetPlayerPed(-1)
    local vehicle = GetVehiclePedIsIn(playerPed, false)

    if DoesEntityExist(vehicle) and IsEntityAVehicle(vehicle) then
        local plate = GetVehicleNumberPlateText(vehicle)

        -- Ensures the markers table is initialized -> reduces chance of errors
        vehicleMarkers[plate] = vehicleMarkers[plate] or {}

        -- Check if a marker argument is provided and if it's allowed
        if args[1] then
            local marker = table.concat(args, ' ', 1) -- Combine all words into a single string as the marker
            marker = string.upper(marker) -- Convert to uppercase for case-insensitivity

            -- Checks if the marker is in the allowedMarkers table -> reduce the chance of incorrect data being input
            if table.contains(allowedMarkers, marker) then
                -- Checks if the marker is not already added to the plate
                if not table.contains(vehicleMarkers[plate], marker) then
                    table.insert(vehicleMarkers[plate], marker)
                    TriggerEvent('chatMessage', '~b~SYSTEM', {0, 150, 255}, 'Marker set for vehicle: ' .. plate .. ' - ' .. marker)
                else
                    TriggerEvent('chatMessage', 'ERROR', {255, 0, 0}, '~r~Marker type ' .. marker .. ' already added to the vehicle.')
                end
            else
                TriggerEvent('chatMessage', 'ERROR', {255, 0, 0}, '~r~Invalid marker type. Allowed types: ' .. table.concat(allowedMarkers, ", "))
            end
        else
            TriggerEvent('chatMessage', '~b~SYSTEM', {0, 150, 255}, 'Usage: /setmarker [marker]')
        end
    else
        TriggerEvent('chatMessage', 'ERROR', {255, 0, 0}, '~r~You need to be in a vehicle to set a marker.')
    end
end, false)

-- Function to check if a value is in the table -> stops a player from putting the same marker on the vehicle 
function table.contains(table, value)
    for _, v in ipairs(table) do
        if string.lower(v) == string.lower(value) then
            return true
        end
    end
    return false
end


-- Command to remove all markers from the vehicle
RegisterCommand('removemarkers', function()
    local playerPed = GetPlayerPed(-1)
    local vehicle = GetVehiclePedIsIn(playerPed, false)

    if DoesEntityExist(vehicle) and IsEntityAVehicle(vehicle) then
        local plate = GetVehicleNumberPlateText(vehicle)

        -- Remove all markers from the vehicle
        vehicleMarkers[plate] = {}

        TriggerEvent('chatMessage', 'SYSTEM', {0, 150, 255}, 'Markers removed for vehicle: ' .. plate)
    else
        TriggerEvent('chatMessage', 'ERROR', {255, 0, 0}, '~r~You need to be in a vehicle to remove markers.')
    end
end, false)

-- Command to toggle ANPR ping visibility
RegisterCommand('anpr', function()
    local playerPed = GetPlayerPed(-1)
    local vehicle = GetVehiclePedIsIn(playerPed, false)

    if DoesEntityExist(vehicle) and IsEntityAVehicle(vehicle) then
        anprVisible = not anprVisible
        local status = anprVisible and "visible" or "hidden"
        TriggerEvent('chatMessage', 'SYSTEM', {0, 150, 255}, 'ANPR pings are now ' .. status)

        -- Triggers in-game notification popup
        local notificationMessage = 'ANPR pings are now ' .. status
        TriggerEvent('anpr:showNotification', notificationMessage)
    else
        TriggerEvent('chatMessage', 'ERROR', {255, 0, 0}, '~r~You need to be in a vehicle to toggle ANPR pings.')
    end
end, false)

-- Event handler for showing notifications
RegisterNetEvent('anpr:showNotification')
AddEventHandler('anpr:showNotification', function(message)
    SetNotificationTextEntry('STRING')
    AddTextComponentString(message)
    DrawNotification(false, false)
end)

-- Command to initiate a specific ANPR ping
RegisterCommand('pinganpr', function(source, args, rawCommand)
    local plate = args[1]
    if plate then
        print("Debug: ANPR ping initiated for plate: " .. plate)
        anprCooldowns[plate] = 3 -- Cooldown for this specific plate
        activePingPlate = plate -- Set the active ping plate
        TriggerEvent('chatMessage', 'SYSTEM', {0, 150, 255}, 'ANPR ping initiated for plate: ' .. plate)
    else
        activePingPlate = nil -- Reset active ping plate to show pings for all plates
        TriggerEvent('chatMessage', 'SYSTEM', {0, 150, 255}, 'ANPR ping now searching for all plates')
    end
end, false)

-- Command to unping ANPR for a specific plate
RegisterCommand('unpinganpr', function(source, args, rawCommand)
    local plate = args[1]
    if plate then
        anprCooldowns[plate] = nil -- Remove cooldown for this specific plate
        TriggerEvent('chatMessage', 'SYSTEM', {0, 150, 255}, 'ANPR ping removed for plate: ' .. plate)
    else
        TriggerEvent('chatMessage', 'SYSTEM', {0, 150, 255}, 'Usage: /unpinganpr [plate]')
    end
end, false)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(900) -- delay can be adjusted dependant on time between ANPR pings
        for plate, cooldown in pairs(anprCooldowns) do
            if cooldown > 0 then
                anprCooldowns[plate] = cooldown - 1
            end
        end
        CheckANPRCameras()
    end
end)