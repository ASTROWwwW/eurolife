

-- Vérifie si le joueur a une canne à pêche et un hameçon
ESX.RegisterServerCallback('esx_fishing:checkRequirements', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local hasRod = xPlayer.getInventoryItem(Config.FishingRod).count > 0
    local hookFound = false
    local hookType = nil

    if hasRod then
        for hook, data in pairs(Config.Hooks) do
            if xPlayer.getInventoryItem(hook).count > 0 then
                hookFound = true
                hookType = hook
                break
            end
        end
    end

    cb(hasRod and hookFound, hookType)
end)

-- Gestion de la casse de l'hameçon
RegisterServerEvent('esx_fishing:hookBroke')
AddEventHandler('esx_fishing:hookBroke', function(hookType)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem(hookType, 1)
end)

-- Tentative de capture d'un poisson
RegisterServerEvent('esx_fishing:tryCatchFish')
AddEventHandler('esx_fishing:tryCatchFish', function(hookType)
    local xPlayer = ESX.GetPlayerFromId(source)
    
    -- Calcul du poids total
    local totalWeight = 0
    for _, fish in ipairs(Config.Fish) do
        totalWeight = totalWeight + fish.weight
    end
    
    -- Sélection aléatoire basée sur les poids
    local randomWeight = math.random(1, totalWeight)
    local currentWeight = 0
    local caughtFish = nil
    
    for _, fish in ipairs(Config.Fish) do
        currentWeight = currentWeight + fish.weight
        if randomWeight <= currentWeight then
            caughtFish = fish
            break
        end
    end
    
    if caughtFish then
        xPlayer.addInventoryItem(caughtFish.item, 1)
        xPlayer.showNotification("Bien joué ! Tu as attrapé ~g~" .. caughtFish.name .. " !")
    else
        xPlayer.showNotification("Rien n'a mordu cette fois-ci...")
    end
end)


------------------------- VENTE DE POISSONS -------------------------


-- Récupérer l'inventaire du joueur
ESX.RegisterServerCallback('esx_fishing:getPlayerInventory', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local items = xPlayer.inventory
    
    cb({items = items})
end)

-- Vendre un type de poisson
RegisterServerEvent('esx_fishing:sellFish')
AddEventHandler('esx_fishing:sellFish', function(fishItem, amount)
    local xPlayer = ESX.GetPlayerFromId(source)
    local fishCount = xPlayer.getInventoryItem(fishItem).count
    
    -- Vérifier si le joueur a assez de poissons
    if fishCount < amount then
        TriggerClientEvent('esx:showNotification', source, "Vous n'avez pas assez de poissons !")
        return
    end
    
    -- Vérifier si l'item est dans la liste des items vendables
    local isValidFish = false
    for _, item in ipairs(Config.SellableItems) do
        if item == fishItem then
            isValidFish = true
            break
        end
    end
    
    if not isValidFish then
        TriggerClientEvent('esx:showNotification', source, "Ce poisson n'est pas accepté par l'acheteur !")
        return
    end
    
    -- Déterminer le prix basé sur Config.FishPrices
    local price = Config.FishPrices[fishItem] or 0
    local totalPrice = price * amount
    
    -- Trouver le nom du poisson
    local fishName = fishItem  -- Par défaut, utiliser l'identifiant
    for _, fish in ipairs(Config.Fish) do
        if fish.item == fishItem then
            fishName = fish.name
            break
        end
    end
    
    -- Retirer les poissons et donner l'argent
    xPlayer.removeInventoryItem(fishItem, amount)
    xPlayer.addMoney(totalPrice)
    
    TriggerClientEvent('esx:showNotification', source, "Vous avez vendu " .. amount .. "x " .. fishName .. " pour $" .. totalPrice)
end)

-- Vendre tous les poissons
RegisterServerEvent('esx_fishing:sellAllFish')
AddEventHandler('esx_fishing:sellAllFish', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local totalPrice = 0
    local itemsSold = 0
    local soldFishNames = {}
    
    -- Parcourir tous les types de poissons configurés
    for fishItem, price in pairs(Config.FishPrices) do
        local fishCount = xPlayer.getInventoryItem(fishItem).count
        
        if fishCount > 0 then
            -- Calculer le prix pour ce type de poisson
            local fishPrice = price * fishCount
            totalPrice = totalPrice + fishPrice
            itemsSold = itemsSold + fishCount
            
            -- Trouver le nom du poisson pour l'affichage
            local fishName = fishItem
            for _, fish in ipairs(Config.Fish) do
                if fish.item == fishItem then
                    fishName = fish.name
                    break
                end
            end
            
            -- Ajouter à la liste des poissons vendus
            table.insert(soldFishNames, fishCount .. "x " .. fishName)
            
            -- Retirer les poissons
            xPlayer.removeInventoryItem(fishItem, fishCount)
        end
    end
    
    -- Donner l'argent au joueur
    if totalPrice > 0 then
        xPlayer.addMoney(totalPrice)
        TriggerClientEvent('esx:showNotification', source, "Vous avez vendu " .. table.concat(soldFishNames, ", ") .. " pour $" .. totalPrice)
    else
        TriggerClientEvent('esx:showNotification', source, "Vous n'avez pas de poissons à vendre !")
    end
end)
