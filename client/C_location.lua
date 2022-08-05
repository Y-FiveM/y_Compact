ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(100)
	end
end)

local spawnCar = {
    position = vector3(-496.64, -668.13, 32.86),
    heading = 270.22
}

Citizen.CreateThread(function()
	for k, v in pairs(ConfigLoca.Position) do
		local blip = AddBlipForCoord(v.x, v.y, v.z)

		SetBlipSprite(blip, 77)
		SetBlipScale (blip, 0.8)
		SetBlipColour(blip, 0)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName('STRING')
		AddTextComponentSubstringPlayerName('Location')
		EndTextCommandSetBlipName(blip)
	end
end)

Citizen.CreateThread(function()
	while true do
		local wait = 500
		local playerCoords = GetEntityCoords(PlayerPedId())

		for k, v in pairs(ConfigLoca.Position) do
			local distance = GetDistanceBetweenCoords(playerCoords, v.x, v.y, v.z, true)

            if distance < 10.0 then

                wait = 0

                actualZone = v

                zoneDistance = GetDistanceBetweenCoords(playerCoords, actualZone.x, actualZone.y, actualZone.z, true)

				DrawMarker(6, v.x, v.y, v.z-1, 0.0, 0.0, 0.0, -90.0, 0.0, 0.0, 1.5, 1.5, 1.5, 10, 150, 255, 100, false, true, 2, false, nil, nil, false)
            end
            
            if distance <= 1.5 then
                wait = 0
				RageUI.Text({
					message = "Appuyez sur [~b~E~w~] pour acceder a la location",
					time_display = 1
				})

                if IsControlJustPressed(1, 51) then
                    open_location()
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

RMenu.Add('y_location', 'main', RageUI.CreateMenu("Location", "Véhicules de location"))
RMenu.Add('y_location', 'vehicule', RageUI.CreateSubMenu(RMenu:Get('y_location', 'main'), "Location", "Voici nos véhicules de location"))
RMenu:Get("y_location", "main").Closed = function()
    location = false
end

function open_location()
    if location then
        location = false
        RageUI.CloseAll()
    else
        location = true
        RageUI.Visible(RMenu:Get("y_location","main"), true)
        Citizen.CreateThread(function()
            while location do
                Citizen.Wait(1)
        RageUI.IsVisible(RMenu:Get('y_location', 'main'), true, true, true, function()

            RageUI.ButtonWithStyle("Louer un véhicule", nil, {RightLabel = "→"},true, function()
            end, RMenu:Get('y_location', 'vehicule'))

		end, function()
        end)

		RageUI.IsVisible(RMenu:Get('y_location', 'vehicule'), true, true, true, function()

            RageUI.Separator("↓ ~b~Véhicules Disponible~s~ ↓")

			RageUI.ButtonWithStyle("Panto", nil, { }, true, function(Hovered, Active, Selected)
				if Selected then

                    prix = 300
                     model = GetHashKey("panto")
                    RequestModel(model)
                    while (not (HasModelLoaded(model))) do
                    Wait(100)
                    end
                    TriggerServerEvent('y:give', prix)
                    
                     car = CreateVehicle(model, spawnCar.position, spawnCar.heading, true)
                    TaskWarpPedIntoVehicle(PlayerPedId(), car, -1)
                end
            end)

            RageUI.ButtonWithStyle("Moto-Cross", nil, { }, true, function(Hovered, Active, Selected)
				if Selected then

                     prix = 400
                     model = GetHashKey("sanchez")
                    RequestModel(model)
                    while (not (HasModelLoaded(model))) do
                    Wait(100)
                    end
                    TriggerServerEvent('y:give', prix)
                    
                     car = CreateVehicle(model, spawnCar.position, spawnCar.heading, true)
                    TaskWarpPedIntoVehicle(PlayerPedId(), car, -1)
                end
            end)

		end, function()
        end)
	end
end)

Citizen.Wait(0)
    end
end