ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(100)
	end
end)

Citizen.CreateThread(function()
	for k, v in pairs(ConfigBanque.Position) do
		local blip = AddBlipForCoord(v.x, v.y, v.z)

		SetBlipSprite(blip, 207)
		SetBlipScale (blip, 0.8)
		SetBlipColour(blip, 39)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName('STRING')
		AddTextComponentSubstringPlayerName('Banque')
		EndTextCommandSetBlipName(blip)
	end
end)

Citizen.CreateThread(function()
	while true do
		local wait = 500
		local playerCoords = GetEntityCoords(PlayerPedId())

		for k, v in pairs(ConfigBanque.Position) do
			local distance = GetDistanceBetweenCoords(playerCoords, v.x, v.y, v.z, true)

            if distance < 10.0 then

                wait = 0

                actualZone = v

                zoneDistance = GetDistanceBetweenCoords(playerCoords, actualZone.x, actualZone.y, actualZone.z, true)

				DrawMarker(6, v.x, v.y, v.z-1, 0.0, 0.0, 0.0, -90.0, 0.0, 0.0, 1.5, 1.5, 1.5, 10, 150, 255, 50, false, true, 2, false, nil, nil, false)
            end
            
            if distance <= 1.5 then
                wait = 0
				RageUI.Text({
					message = "Appuyez sur [~b~E~w~] pour acceder a votre compte",
					time_display = 1
				})

                if IsControlJustPressed(1, 51) then
                    open_banque()
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

RMenu.Add('y_banque', 'main', RageUI.CreateMenu("Banque", "Compte en banque"))
RMenu.Add('y_banque', 'retrait', RageUI.CreateSubMenu(RMenu:Get('y_banque', 'main'), "Banque", "Compte en banque"))
RMenu.Add('y_banque', 'depo', RageUI.CreateSubMenu(RMenu:Get('y_banque', 'main'), "Banque", "Compte en banque"))
RMenu:Get("y_banque", "main").Closed = function()
    banque = false
end

function open_banque()
    if banque then
        banque = false
        RageUI.CloseAll()
    else
        banque = true
        RageUI.Visible(RMenu:Get("y_banque","main"), true)
        Citizen.CreateThread(function()
            while banque do
                Citizen.Wait(1)
        RageUI.IsVisible(RMenu:Get('y_banque', 'main'), true, true, true, function()


					--RageUI.Separator("Argent liquide : ~g~" .. ESX.Math.GroupDigits(ESX.PlayerData.money .. "$"))

            RageUI.Separator("↓ ~b~Catégories~s~ ↓")

            RageUI.ButtonWithStyle("Retirer de l'argent", "Pour faire un retrait d'argent", {RightLabel = "→"},true, function()
            end, RMenu:Get('y_banque', 'retrait'))

			RageUI.ButtonWithStyle("Déposer de l'argent", "Pour faire un dépot d'argent", {RightLabel = "→"},true, function()
            end, RMenu:Get('y_banque', 'depo'))
		--end
		end, function()
        end)

		RageUI.IsVisible(RMenu:Get('y_banque', 'retrait'), true, true, true, function()

			RageUI.ButtonWithStyle("Montant", nil, { }, true, function(Hovered, Active, Selected)
				if Selected then
					saisieretrait()
                    verifsolde()
                    verifpoche()
				end
			end)

		end, function()
        end)

		RageUI.IsVisible(RMenu:Get('y_banque', 'depo'), true, true, true, function()

			RageUI.ButtonWithStyle("Montant", nil, { }, true, function(Hovered, Active, Selected)
				if Selected then
					saisiedepot()
                    verifsolde()
                    verifpoche()
				end
			end)

		end, function()
        end)

	end
end)

Citizen.Wait(0)
    end
end