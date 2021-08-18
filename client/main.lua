ESX = nil;
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Wait(10)
	end

    while not ESX.GetPlayerData().job do
        Wait(10)
    end

    ESX.PlayerData = ESX.GetPlayerData(); CreateBlips();

    if (ESX.PlayerData.job.name ~= 'police' or ESX.PlayerData.job.name ~= 'ambulance') then StartThread() end
end)

local SpeedCameras = {
    [60] = {
        vector3(-524.2645, -1776.3569, 21.3384)
    },

    [80] = {
        vector3(2506.0671, 4145.2431, 38.1054),
        vector3(1258.2006, 789.4199, 103.219),
        vector3(980.9982, 407.4164, 92.2374)
    },

    [120] = {
        vector3(1584.9281, -993.4557, 59.3923),
        vector3(2442.2006, -134.6004, 88.7765),
        vector3(2871.7951, 3540.5795, 53.0930)
    }
}

function CreateBlips()
    local blipStyle = {
        colourId = 1,
        spriteId = 184
    };

    for maxSpeed, zone in pairs(SpeedCameras) do
        for i=1, #zone, 1 do
            local zoneCoords = vector3(zone[i].x, zone[i].y, zone[i].z);
            local blip = AddBlipForCoord(zoneCoords);
  
            SetBlipSprite(blip, blipStyle.spriteId)
            SetBlipDisplay(blip, 4)
            SetBlipScale(blip, 0.5)
            SetBlipColour(blip, blipStyle.colourId)
            SetBlipAsShortRange(blip, true)

            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString( string.format('Kiiruskaamera (%s km/h)', maxSpeed) )
            EndTextCommandSetBlipName(blip)
        end
    end
end

function StartThread()
    local hasBeenFined = false;

    while true do

        local letSleep = true;

        for maxSpeed, zone in pairs(SpeedCameras) do
            local playerPed = PlayerPedId();

            local currentVehicle = GetVehiclePedIsIn(playerPed, false);
            if currentVehicle ~= 0 and DoesEntityExist(currentVehicle) then
                if GetPedInVehicleSeat(currentVehicle, -1) == playerPed then
                    local playerCoords = GetEntityCoords(playerPed); 

                    for i=1, #zone, 1 do
                        local zoneCoords = vector3(zone[i].x, zone[i].y, zone[i].z);
                        local Distance = #(playerCoords - zoneCoords);

                        if Distance <= 100 then letSleep = false; end

                        local vehicleSpeed = GetEntitySpeed(currentVehicle) * 3.6;
                        if Distance <= 20 then
                            if vehicleSpeed > maxSpeed and not hasBeenFined then
                                flashScreen(); hasBeenFined = true;
                                TriggerServerEvent('esx_speedcamera:addFine', maxSpeed);
                            end
                        else
                            if vehicleSpeed < maxSpeed and hasBeenFined then
                                hasBeenFined = false;
                            end
                        end
                    end
                end
            end
        end
        
        if letSleep then Wait(500) end

        Wait(10);
    end
end

function flashScreen() 
    SendNUIMessage({type = 'openSpeedcamera'}); 
    Wait(200); 
    SendNUIMessage({type = 'closeSpeedcamera'});
end