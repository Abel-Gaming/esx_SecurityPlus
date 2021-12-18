ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('esx_SecurityPlus:DutyNotification')
AddEventHandler('esx_SecurityPlus:DutyNotification', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local xPlayerName = xPlayer.getName()
    TriggerClientEvent('esx_SecurityPlus:GlobalNotification', -1, '~b~' .. xPlayerName .. ' ~w~is now on duty as a security guard!')
end)