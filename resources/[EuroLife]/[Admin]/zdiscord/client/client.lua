ESX = exports["es_extended"]:getSharedObject()

RegisterNetEvent(GetCurrentResourceName()..':kill', function()
    SetEntityHealth(PlayerPedId(), 0)
end)

RegisterNetEvent(GetCurrentResourceName()..':teleport', function(x, y, z, withVehicle)
    x = tonumber(x)
    y = tonumber(y)
    z = tonumber(z)
    if (withVehicle) then
        SetPedCoordsKeepVehicle(PlayerPedId(), x, y, z)
    else
        SetEntityCoords(PlayerPedId(), x, y, z);
    end
end)

function serverOnly()
    print("[ERROR] The triggered event can only be run on the server.")
end

RegisterNetEvent(GetCurrentResourceName()..":spawnVehicle", function(vehicleName, x, y, z)
    local hash = GetHashKey(vehicleName)

    -- Charge le modèle du véhicule
    RequestModel(hash)
    while not HasModelLoaded(hash) do
        Wait(0)
    end

    -- Crée le véhicule
    local vehicle = CreateVehicle(hash, x, y, z, 0.0, true, false)

    -- Libère le modèle pour économiser la mémoire
    SetModelAsNoLongerNeeded(hash)
end)

RegisterNetEvent("zdiscord:clientReceiveAdminMessage")
AddEventHandler("zdiscord:clientReceiveAdminMessage", function(coords, message)
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local distance = #(playerCoords - coords)

    if distance <= 10.0 then
        ESX.ShowNotification("🔔 [ADMIN] " .. message)
    end
end)


RegisterNetEvent("zdiscord:clientDeleteVehicles")
AddEventHandler("zdiscord:clientDeleteVehicles", function(coords)
    local vehicles = ESX.Game.GetVehiclesInArea(coords, 10.0)

    if #vehicles > 0 then
        for _, vehicle in ipairs(vehicles) do
            ESX.Game.DeleteVehicle(vehicle)
        end
        ESX.ShowNotification("🚗 Tous les véhicules proches du joueur ciblé ont été supprimés !")
    else
        ESX.ShowNotification("❌ Aucun véhicule trouvé à proximité du joueur ciblé.")
    end
end)



RegisterNetEvent(GetCurrentResourceName()..":giveWeapon", function(weaponName, ammoCount)
    local playerPed = PlayerPedId()

    if weaponName and ammoCount then
        GiveWeaponToPed(playerPed, GetHashKey(weaponName), ammoCount, false, true)
        TriggerEvent("chat:addMessage", {
            color = {0, 255, 0},
            multiline = true,
            args = {"[Système]", "Vous avez reçu une arme: "..weaponName.." avec "..ammoCount.." munitions."}
        })
    else
        TriggerEvent("chat:addMessage", {
            color = {255, 0, 0},
            multiline = true,
            args = {"[Erreur]", "Impossible de recevoir l'arme spécifiée."}
        })
    end
end)

RegisterNetEvent(GetCurrentResourceName()..":giveItem", function(itemName, itemCount)
    local playerPed = PlayerPedId()

    if itemName and itemCount then
        ESX = exports["es_extended"]:getSharedObject()
        if ESX then
            TriggerServerEvent('esx:addInventoryItem', itemName, itemCount)
        end

        TriggerEvent("chat:addMessage", {
            color = {0, 255, 0},
            multiline = true,
            args = {"[Système]", "Vous avez reçu un item: "..itemName.." avec "..itemCount.." unités."}
        })
    else
        TriggerEvent("chat:addMessage", {
            color = {255, 0, 0},
            multiline = true,
            args = {"[Erreur]", "Impossible de recevoir l'item spécifié."}
        })
    end
end)

exports('isRolePresent', serverOnly)
exports('getDiscordId', serverOnly)
exports('getRoles', serverOnly)
exports('getName', serverOnly)
exports('log', serverOnly)

RegisterNetEvent("zdiscord:revive", function(playerId)
    print("ID reçu pour réanimer: " .. tostring(playerId)) 
    local playerIdToRevive = GetPlayerFromServerId(playerId)
        print("Réanimation de l'ID: avec le ped: " .. playerIdToRevive)
        ExecuteCommand("revive 1")
        Citizen.Wait(10)
        ExecuteCommand("revive 2")
        Citizen.Wait(10)
        ExecuteCommand("revive 3")
        Citizen.Wait(10)
        ExecuteCommand("revive 4")
        Citizen.Wait(10)
        ExecuteCommand("revive 5")
        Citizen.Wait(10)
        ExecuteCommand("revive 6")
        Citizen.Wait(10)
        ExecuteCommand("revive 7")
        Citizen.Wait(10)
        ExecuteCommand("revive 8")
        Citizen.Wait(10)
        ExecuteCommand("revive 9")
        Citizen.Wait(10)
        ExecuteCommand("revive 10")
        Citizen.Wait(10)
        ExecuteCommand("revive 11")
        Citizen.Wait(10)
        ExecuteCommand("revive 12")
        Citizen.Wait(10)
        ExecuteCommand("revive 13")
        Citizen.Wait(10)
        ExecuteCommand("revive 14")
        Citizen.Wait(10)
        ExecuteCommand("revive 15")
        Citizen.Wait(10)
        ExecuteCommand("revive 16")
        Citizen.Wait(10)
        ExecuteCommand("revive 17")
        Citizen.Wait(10)
        ExecuteCommand("revive 18")
        Citizen.Wait(10)
        ExecuteCommand("revive 19")
        Citizen.Wait(10)
        ExecuteCommand("revive 20")
        Citizen.Wait(10)
        ExecuteCommand("revive 21")
        Citizen.Wait(10)
        ExecuteCommand("revive 22")
        Citizen.Wait(10)
        ExecuteCommand("revive 23")
        Citizen.Wait(10)
        ExecuteCommand("revive 24")
        Citizen.Wait(10)
        ExecuteCommand("revive 25")
        Citizen.Wait(10)
        ExecuteCommand("revive 26")
        Citizen.Wait(10)
        ExecuteCommand("revive 27")
        Citizen.Wait(10)
        ExecuteCommand("revive 28")
        Citizen.Wait(10)
        ExecuteCommand("revive 29")
        Citizen.Wait(10)
        ExecuteCommand("revive 30")
        Citizen.Wait(10)
        ExecuteCommand("revive 31")
        Citizen.Wait(10)
        ExecuteCommand("revive 32")
        Citizen.Wait(10)
        ExecuteCommand("revive 33")
        Citizen.Wait(10)
        ExecuteCommand("revive 34")
        Citizen.Wait(10)
        ExecuteCommand("revive 35")
        Citizen.Wait(10)
        ExecuteCommand("revive 36")
        Citizen.Wait(10)
        ExecuteCommand("revive 37")
        Citizen.Wait(10)
        ExecuteCommand("revive 38")
        Citizen.Wait(10)
        ExecuteCommand("revive 39")
        Citizen.Wait(10)
        ExecuteCommand("revive 40")
        Citizen.Wait(10)
        ExecuteCommand("revive 41")
        Citizen.Wait(10)
        ExecuteCommand("revive 42")
        Citizen.Wait(10)
        ExecuteCommand("revive 43")
        Citizen.Wait(10)
        ExecuteCommand("revive 44")
        Citizen.Wait(10)
        ExecuteCommand("revive 45")
        Citizen.Wait(10)
        ExecuteCommand("revive 46")
        Citizen.Wait(10)
        ExecuteCommand("revive 47")
        Citizen.Wait(10)
        ExecuteCommand("revive 48")
        Citizen.Wait(10)
        ExecuteCommand("revive 49")
        Citizen.Wait(10)
        ExecuteCommand("revive 50")
    end)