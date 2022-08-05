ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterNetEvent('y:give')
AddEventHandler('y:give', function(prix)
	local xPlayer = ESX.GetPlayerFromId(source)
	local xMoney = xPlayer.getMoney()

	if xMoney >= (prix) then
		xPlayer.removeMoney(prix)
		TriggerClientEvent('esx:showNotification', source, "~g~Merci pour votre achat !")
	end
end)