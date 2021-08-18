ESX = nil;
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterNetEvent('esx_speedcamera:addFine')
AddEventHandler('esx_speedcamera:addFine', function(maxSpeed)
    local xPlayer = ESX.GetPlayerFromId(source); if (not xPlayer) then return end; local totalFine = maxSpeed * 100;
    TriggerEvent('esx_billing:sendBill', xPlayer.source, 'society_police', string.format('Kiiruse ületamine! - %s', totalFine), totalFine);
end)