ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


function CheckLicense(source, type, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
	local identifier = xPlayer.identifier

	MySQL.Async.fetchAll('SELECT COUNT(*) as count FROM user_licenses WHERE type = @type AND owner = @owner', {
		['@type']  = type,
		['@owner'] = identifier
	}, function(result)
		if tonumber(result[1].count) > 0 then
			cb(true)
		else
			cb(false)
		end

	end)
end

ESX.RegisterServerCallback('y_ammunation:checkLicense', function(source, cb, type)
	CheckLicense(source, 'weapon', cb)
end)

RegisterServerEvent('y:ammu:addppa')
AddEventHandler('y:ammu:addppa', function(weapon)
	local xPlayer = ESX.GetPlayerFromId(source)
	local playerMoney = xPlayer.getMoney()

	if playerMoney >= 50000 then
    MySQL.Async.execute('INSERT INTO user_licenses (type, owner) VALUES (@type, @owner)', {
        ['@type'] = weapon,
        ['@owner'] = xPlayer.identifier
    })
	xPlayer.removeMoney(50000)
	TriggerClientEvent('esx:showNotification', source, "~g~Achat réussis !")
	else
		TriggerClientEvent('esx:showNotification', source, "~r~Vous n'avez pas assez !")
	end
end)

RegisterServerEvent('give:ammu')
AddEventHandler('give:ammu', function(item)
    local xPlayer = ESX.GetPlayerFromId(source)
    local playerMoney = xPlayer.getMoney()
    if playerMoney >= (item.Price) then
        if not xPlayer.hasWeapon(item.Value) then
        xPlayer.addWeapon(item.Value, 20)
        xPlayer.removeMoney(item.Price)
        else
            TriggerClientEvent('esx:showNotification', source, '~r~Vous avez déjà cette arme')
        end

    else
		TriggerClientEvent('esx:showNotification', source, 'Vous ne pouvez pas acheter ~g~1x ' .. item.Label .. '~s~' .. ' il vous manque ' .. '~r~' .. item.Price - playerMoney .. '$')
    end
end)

RegisterNetEvent('item:acheter')
AddEventHandler('item:acheter', function(item)
	local xPlayer = ESX.GetPlayerFromId(source)
	local playerMoney = xPlayer.getMoney()

	if playerMoney >= (item.Price) then
		xPlayer.addInventoryItem(item.Value, 1)
		xPlayer.removeMoney(item.Price)
	else
		TriggerClientEvent('esx:showNotification', source, "~r~Vous n'avez pas assez !")
	end
end)

RegisterServerEvent('esx_weashop:removeClip')
AddEventHandler('esx_weashop:removeClip', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('clip', 1)
end)

ESX.RegisterUsableItem('clip', function(source)
    TriggerClientEvent('esx_weashop:useClip', source)
end)