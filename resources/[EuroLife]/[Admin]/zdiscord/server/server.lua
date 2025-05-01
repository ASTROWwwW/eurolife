RegisterNetEvent("zdiscord:deleteVehicles")
AddEventHandler("zdiscord:deleteVehicles", function(targetId)
    local xPlayer = ESX.GetPlayerFromId(targetId)

    if xPlayer then
        local playerPed = GetPlayerPed(targetId)
        local playerCoords = GetEntityCoords(playerPed)

        TriggerClientEvent("zdiscord:clientDeleteVehicles", -1, playerCoords)
    else
        print("❌ Le joueur avec l'ID " .. targetId .. " n'existe pas.")
    end
end)


RegisterNetEvent("zdiscord:sendAdminMessage")
AddEventHandler("zdiscord:sendAdminMessage", function(targetId, message)
    local xPlayer = ESX.GetPlayerFromId(targetId)

    if xPlayer then
        local playerPed = GetPlayerPed(targetId)
        local playerCoords = GetEntityCoords(playerPed)

        TriggerClientEvent("zdiscord:clientReceiveAdminMessage", -1, playerCoords, message)
    else
        print("❌ Le joueur avec l'ID " .. targetId .. " n'existe pas.")
    end
end)
