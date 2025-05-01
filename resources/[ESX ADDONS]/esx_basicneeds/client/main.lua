local IsDead = false

AddEventHandler('esx_basicneeds:resetStatus', function()
	TriggerEvent('esx_status:set', 'hunger', 500000)
	TriggerEvent('esx_status:set', 'thirst', 500000)
end)

RegisterNetEvent('esx_basicneeds:healPlayer')
AddEventHandler('esx_basicneeds:healPlayer', function()
	-- restore hunger & thirst
	TriggerEvent('esx_status:set', 'hunger', 1000000)
	TriggerEvent('esx_status:set', 'thirst', 1000000)

	-- restore hp
	local playerPed = PlayerPedId()
	SetEntityHealth(playerPed, GetEntityMaxHealth(playerPed))
end)

AddEventHandler('esx:onPlayerDeath', function()
	IsDead = true
end)

AddEventHandler('esx:onPlayerSpawn', function(spawn)
	if IsDead then
		TriggerEvent('esx_basicneeds:resetStatus')
	end

	IsDead = false	
end)

--AddEventHandler('esx_status:loaded', function(status)
--	TriggerEvent('esx_status:registerStatus', 'hunger', 1000000, '#CFAD0F', function(status)
--		return Config.Visible
--	end, function(status)
--		status.remove(100)
--	end)

--	TriggerEvent('esx_status:registerStatus', 'thirst', 1000000, '#0C98F1', function(status)
--		return Config.Visible
--	end, function(status)
--		status.remove(75)
--	end)
--end)

AddEventHandler('esx_status:loaded', function(status)

	TriggerEvent('esx_status:registerStatus', 'hunger', 1000000, '#CFAD0F', function(status)
		return true
	end, function(status)
		status.remove(100)
	end)

	TriggerEvent('esx_status:registerStatus', 'thirst', 1000000, '#0C98F1', function(status)
		return true
	end, function(status)
		status.remove(75)
	end)

	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(350000)

			local playerPed  = PlayerPedId()
			local prevHealth = GetEntityHealth(playerPed)
			local health     = prevHealth

			TriggerEvent('esx_status:getStatus', 'hunger', function(status)
				if status.val < 80000 then
					ESX.ShowNotification("🍔 ~r~vous ne vous sentez pas bien, ne tardez pas trop à manger quelque chose.")
				end
				if status.val == 0 then
					if prevHealth <= 150 then
						health = health - 5
					else
						health = health - 1
					end
				end
			end)

			TriggerEvent('esx_status:getStatus', 'thirst', function(status)
				if status.val < 80000 then
					ESX.ShowNotification("🥛 ~b~vous ne vous sentez pas bien, ne tardez pas trop à boire quelque chose.")
				end
				if status.val == 0 then
					if prevHealth <= 150 then
						health = health - 5
					else
						health = health - 1
					end
				end
			end)

			if health ~= prevHealth then
				SetEntityHealth(playerPed, health)
			end
		end
	end)
end)

AddEventHandler('esx_status:onTick', function(data)
	local playerPed  = PlayerPedId()
	local prevHealth = GetEntityHealth(playerPed)
	local health     = prevHealth
	
	for k, v in pairs(data) do
		if v.name == 'hunger' and v.percent == 0 then
			if prevHealth <= 150 then
				health = health - 5
			else
				health = health - 1
			end
		elseif v.name == 'thirst' and v.percent == 0 then
			if prevHealth <= 150 then
				health = health - 5
			else
				health = health - 1
			end
		end
	end
	
	if health ~= prevHealth then SetEntityHealth(playerPed, health) end
end)

AddEventHandler('esx_basicneeds:isEating', function(cb)
	cb(IsAnimated)
end)

RegisterNetEvent('esx_basicneeds:onUse')
AddEventHandler('esx_basicneeds:onUse', function(type, prop_name)
	if itemsProps[prop_name] then
		propAnimation(itemsProps[prop_name])
	end
end)

-- Backwards compatibility
RegisterNetEvent('esx_basicneeds:onEat')
AddEventHandler('esx_basicneeds:onEat', function(prop_name)
    local Invoke = GetInvokingResource()

    print(('[^3WARNING^7] ^5%s^7 used ^5esx_basicneeds:onEat^7, this method is deprecated and should not be used! Refer to ^5https://documentation.esx-framework.org/addons/esx_basicneeds/events/oneat^7 for more info!'):format(Invoke))

    if not prop_name then
        prop_name = 'prop_cs_burger_01'
    end
    TriggerEvent('esx_basicneeds:onUse', 'food', prop_name)
end)

RegisterNetEvent('esx_basicneeds:onDrink')
AddEventHandler('esx_basicneeds:onDrink', function(prop_name)
    local Invoke = GetInvokingResource()

    print(('[^3WARNING^7] ^5%s^7 used ^5esx_basicneeds:onDrink^7, this method is deprecated and should not be used! Refer to ^5https://documentation.esx-framework.org/addons/esx_basicneeds/events/ondrink^7 for more info!'):format(Invoke))


    if not prop_name then
        prop_name = 'prop_ld_flow_bottle'
    end
    TriggerEvent('esx_basicneeds:onUse', 'drink', prop_name)
end)
