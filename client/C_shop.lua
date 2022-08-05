ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(100)
	end
end)

Citizen.CreateThread(function()
	for k, v in pairs(ConfigShop.Position) do
		local blip = AddBlipForCoord(v.x, v.y, v.z)

		SetBlipSprite(blip, 59)
		SetBlipScale (blip, 0.8)
		SetBlipColour(blip, 2)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName('STRING')
		AddTextComponentSubstringPlayerName('Magasin')
		EndTextCommandSetBlipName(blip)
	end
end)

Citizen.CreateThread(function()
	while true do
		local wait = 500
		local playerCoords = GetEntityCoords(PlayerPedId())

		for k, v in pairs(ConfigShop.Position) do
			local distance = GetDistanceBetweenCoords(playerCoords, v.x, v.y, v.z, true)

            if distance < 10.0 then

                wait = 0

                actualZone = v

                zoneDistance = GetDistanceBetweenCoords(playerCoords, actualZone.x, actualZone.y, actualZone.z, true)

				DrawMarker(6, v.x, v.y, v.z-1, 0.0, 0.0, 0.0, -90.0, 0.0, 0.0, 1.2, 1.2, 1.2, 10, 300, 255, 200, false, true, 2, false, nil, nil, false)
            end
            
            if distance <= 1.5 then
                wait = 0
				RageUI.Text({
					message = "Appuyez sur [~b~E~w~] pour acceder au magasin",
					time_display = 1
				})

                if IsControlJustPressed(1, 51) then
                    open_shop()
                end
            end

            if zoneDistance ~= nil then
                if zoneDistance > 1.5 then
                    RageUI.CloseAll()
                end
            end
        end
    	Citizen.Wait(wait)
	end
end)

RMenu.Add('y_shop', 'main', RageUI.CreateMenu("Magasin", "Shop"))
RMenu.Add('y_shop', 'objet', RageUI.CreateSubMenu(RMenu:Get('y_shop', 'main'), "Magasin", "Shop"))
RMenu:Get("y_shop", "main").Closed = function()
    shop = false
end

function open_shop()
    if shop then
        shop = false
        RageUI.CloseAll()
    else
        shop = true
        RageUI.Visible(RMenu:Get("y_shop","main"), true)
        Citizen.CreateThread(function()
            while shop do
                Citizen.Wait(1)
        RageUI.IsVisible(RMenu:Get('y_shop', 'main'), true, true, true, function()

            RageUI.ButtonWithStyle("Voir nos articles", nil, {RightLabel = "→→"},true, function()
            end, RMenu:Get('y_shop', 'objet'))

		end, function()
        end)

		RageUI.IsVisible(RMenu:Get('y_shop', 'objet'), true, true, true, function()

            RageUI.Separator("↓ ~b~Articles Disponible~s~ ↓")

            for k, v in pairs(ConfigShop.Items) do
			RageUI.ButtonWithStyle(v.Label, nil, {RightLabel = "~g~"..v.Price.."$"}, true, function(Hovered, Active, Selected)
				if Selected then
                    TriggerServerEvent('y:giveItem', v)
                end
            end)
        end

		end, function()
        end)

	end
end)

Citizen.Wait(0)
    end
end