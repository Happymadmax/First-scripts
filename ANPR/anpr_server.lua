local plateInfo = {} -- Store information about plates, including markers - allowing them to ping ANPR cameras

RegisterServerEvent('anpr:setVehicleMarker')
AddEventHandler('anpr:setVehicleMarker', function(plate, marker)
    plateInfo[plate] = {marker = marker}
end)

RegisterServerEvent('anpr:checkPlate')
AddEventHandler('anpr:checkPlate', function(plate)
    local info = plateInfo[plate] or {marker = nil}
    TriggerClientEvent('anpr:displayPlate', -1, plate, info.marker)
end)

RegisterCommand('getvehiclemarker', function(source, args)
    local player = source
    local plate = args[1] or ''
    
    local info = plateInfo[plate] or {marker = nil}
    local marker = info.marker

    if marker then
        TriggerClientEvent('chatMessage', player, 'SYSTEM', {255, 0, 0}, 'Vehicle marker info: ' .. plate .. ' is marked as ' .. marker)
    else
        TriggerClientEvent('chatMessage', player, 'SYSTEM', {255, 0, 0}, 'No marker found for vehicle: ' .. plate)
    end
end, false)

RegisterServerEvent('anpr:plateDetected')
AddEventHandler('anpr:plateDetected', function(plate, status, colorInfo)
    local info = plateInfo[plate] or {marker = nil}
    TriggerClientEvent('anpr:displayPlate', -1, plate, info.marker, colorInfo)
    -- Additional sever side action can be added here accordingly
end)