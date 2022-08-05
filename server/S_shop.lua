ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterNetEvent('y:giveItem')
AddEventHandler('y:giveItem', function(item)
	local xPlayer = ESX.GetPlayerFromId(source)
	local xMoney = xPlayer.getMoney()

	if xMoney >= (item.Price) then
		xPlayer.addInventoryItem(item.Value, 1)
		xPlayer.removeMoney(item.Price)
		TriggerClientEvent('esx:showNotification', source, "~g~Merci pour votre achat ! ~w~\n(Cash)")
	end
end)