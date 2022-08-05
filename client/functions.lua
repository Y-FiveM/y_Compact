function verifsolde()
    TriggerServerEvent("banque:solde", action)
end

function verifpoche()
    TriggerServerEvent("banque:poche", action)
end

RegisterNetEvent("banque:solderefresh")
AddEventHandler("banque:solderefresh", function(money, cash)
    argentsolde = tonumber(money)
end)

RegisterNetEvent("banque:pocherefresh")
AddEventHandler("banque:pocherefresh", function(money, cash)
    argentpoche = tonumber(money)
end)

function KeyboardInput(TextEntry, ExampleText, MaxStringLenght)


    AddTextEntry('FMMC_KEY_TIP1', TextEntry) 
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLenght)
    blockinput = true

    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do 
        Citizen.Wait(0)
    end
        
    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult() 
        Citizen.Wait(500) 
        blockinput = false
        return result 
    else
        Citizen.Wait(500) 
        blockinput = false 
        return nil 
    end
end

function saisieretrait()
			local amount = KeyboardInput("Retrait banque", "", 15)
		
			if amount ~= nil then
				amount = tonumber(amount)
		
				if type(amount) == 'number' then
					TriggerServerEvent('banque:retrait', amount)
				else
					ESX.ShowNotification("Vous n'avez pas saisi un montant")
				end
			end
end	

function saisiedepot()
			local amount = KeyboardInput("Dépot banque", "", 15)
		
			if amount ~= nil then
				amount = tonumber(amount)
		
				if type(amount) == 'number' then
					TriggerServerEvent('banque:depo', amount)
				else
					ESX.ShowNotification("Vous n'avez pas saisi un montant")
				end
			end
end