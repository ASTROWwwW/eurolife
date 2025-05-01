-- Charger ESX
ESX = exports["es_extended"]:getSharedObject()

local playerProgress = {}

-- Charger la progression au démarrage du joueur (quand il se connecte)
AddEventHandler("esx:playerLoaded", function(source, xPlayer)
    local identifier = xPlayer.identifier
    -- Correction dans esx:playerLoaded (ligne 9)
    MySQL.Async.fetchScalar("SELECT muscle FROM users WHERE identifier = @identifier", {
        ["@identifier"] = identifier
    }, function(result)
        playerProgress[source] = result or 0
        TriggerClientEvent("gym:setProgress", source, playerProgress[source])
    end)
end)

-- Sauvegarder la progression quand elle est mise à jour
RegisterNetEvent("gym:updateProgress")
AddEventHandler("gym:updateProgress", function(value)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    
    if xPlayer then -- Ensure xPlayer is not nil
        -- Stockage dans la base de données
        MySQL.Async.execute('UPDATE users SET muscle = @muscle WHERE identifier = @identifier', {
            ['@muscle'] = value,
            ['@identifier'] = xPlayer.identifier
        })
    else
        print(("[Gym] Error: xPlayer is nil for source %s"):format(source))
    end
end)

-- Envoyer la progression au client à la demande (par exemple, au spawn)
RegisterNetEvent("gym:requestProgress")
AddEventHandler("gym:requestProgress", function()
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    
    if xPlayer then -- Ensure xPlayer is not nil
        MySQL.Async.fetchScalar('SELECT muscle FROM users WHERE identifier = @identifier', {
            ['@identifier'] = xPlayer.identifier
        }, function(muscle)
            TriggerClientEvent("gym:setProgress", source, muscle or 0)
        end)
    else
        print(("[Gym] Error: xPlayer is nil for source %s"):format(source))
    end
end)

-- Nettoyer les données quand le joueur se déconnecte
AddEventHandler("playerDropped", function()
    local source = source
    playerProgress[source] = nil
end)