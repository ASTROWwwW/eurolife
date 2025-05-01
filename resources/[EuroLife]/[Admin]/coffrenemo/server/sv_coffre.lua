
RegisterNetEvent('eurolife_coffre:addItem', function(coffreId, itemName, amount)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local itemLabel = ESX.GetItemLabel(itemName) or itemName
    if not xPlayer then return end

    if amount <= 0 then return end

    local item = xPlayer.getInventoryItem(itemName)
    if not item or item.count < amount then
        return xPlayer.showNotification("~r~Tu n'as pas assez de cet item.")
    end

    xPlayer.removeInventoryItem(itemName, amount)

    exports.oxmysql:execute('SELECT * FROM eurolife_coffre_items WHERE coffre_id = ? AND item_name = ?', {coffreId, itemName}, function(result)
        if result[1] then
            exports.oxmysql:update('UPDATE eurolife_coffre_items SET item_count = item_count + ? WHERE id = ?', {amount, result[1].id}, function()
                TriggerClientEvent('eurolife_coffre:refreshSingleCoffre', src, coffreId)
                TriggerClientEvent('esx:showNotification', src, ("~g~Vous avez déposé %sx %s."):format(amount, itemLabel))

            end)
        else
            exports.oxmysql:insert('INSERT INTO eurolife_coffre_items (coffre_id, item_name, item_count) VALUES (?, ?, ?)', {coffreId, itemName, amount}, function()
                TriggerClientEvent('eurolife_coffre:refreshSingleCoffre', src, coffreId)
                TriggerClientEvent('esx:showNotification', src, ("~g~Vous avez déposé %sx %s."):format(amount, itemLabel))

                

            end)
        end
    end)
end)

-- Retrait d'un item
RegisterNetEvent('eurolife_coffre:removeItem', function(coffreId, itemName, amount)
    local src = source
    local itemLabel = ESX.GetItemLabel(itemName) or itemName
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then return end
    if amount <= 0 then return end

    exports.oxmysql:execute('SELECT * FROM eurolife_coffre_items WHERE coffre_id = ? AND item_name = ?', {coffreId, itemName}, function(result)
        if result[1] and result[1].item_count >= amount then
            xPlayer.addInventoryItem(itemName, amount)

            if result[1].item_count == amount then
                exports.oxmysql:execute('DELETE FROM eurolife_coffre_items WHERE id = ?', {result[1].id}, function()
                    TriggerClientEvent('eurolife_coffre:refreshSingleCoffre', src, coffreId)
                    TriggerClientEvent('esx:showNotification', src, ("~g~Vous avez retiré %sx %s."):format(amount, itemLabel))
                end)
            else
                exports.oxmysql:update('UPDATE eurolife_coffre_items SET item_count = item_count - ? WHERE id = ?', {amount, result[1].id}, function()
                    TriggerClientEvent('eurolife_coffre:refreshSingleCoffre', src, coffreId)
                    TriggerClientEvent('esx:showNotification', src, ("~g~Vous avez retiré %sx %s."):format(amount, itemLabel))

                end)
            end
        else
            xPlayer.showNotification("~r~Pas assez de cet item dans le coffre.")
        end
    end)
end)

-- Dépôt argent propre
RegisterNetEvent('eurolife_coffre:depositMoney', function(coffreId, amount)
    
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then return end
   
    amount = tonumber(amount)
    if not amount or amount <= 0 then return end
    
    if xPlayer.getMoney() < amount then
        return xPlayer.showNotification("~r~Pas assez d'argent.")
    end

    xPlayer.removeMoney(amount)
    

    exports.oxmysql:update('UPDATE eurolife_coffres SET money = money + ? WHERE id = ?', {amount, coffreId}, function(affectedRows)
        if affectedRows  then
         
    
        TriggerClientEvent('eurolife_coffre:refreshSingleCoffre', src, coffreId)
        print("[DEBUG EUROLIFE] Argent propre déposé dans le coffre | ID:", coffreId, "| Amount:", amount)
        TriggerClientEvent('esx:showNotification', src, ("~g~Vous avez déposé %s$ en argent propre."):format(amount))
        end
            end)
end)


-- Retrait argent propre
RegisterNetEvent('eurolife_coffre:withdrawMoney', function(coffreId, amount)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then return end
    amount = tonumber(amount)
    if not amount or amount <= 0 then return end

    exports.oxmysql:execute('SELECT money FROM eurolife_coffres WHERE id = ?', {coffreId}, function(result)
        if result[1] and result[1].money >= amount then
            xPlayer.addMoney(amount)
            exports.oxmysql:update('UPDATE eurolife_coffres SET money = money - ? WHERE id = ?', {amount, coffreId}, function()
                TriggerClientEvent('eurolife_coffre:refreshSingleCoffre', src, coffreId)
                TriggerClientEvent('esx:showNotification', src, ("~g~Vous avez retiré %s$ en argent propre."):format(amount))
            end)
        else
            xPlayer.showNotification("~r~Pas assez d'argent dans le coffre.")
        end
    end)
end)


-- Dépôt argent sale
RegisterNetEvent('eurolife_coffre:depositBlackMoney', function(coffreId, amount)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then return end
    amount = tonumber(amount)
    if not amount or amount <= 0 then return end

    local blackMoney = xPlayer.getAccount('black_money').money
    if blackMoney < amount then
        return xPlayer.showNotification("~r~Pas assez d'argent sale.")
    end

    xPlayer.removeAccountMoney('black_money', amount)

    exports.oxmysql:update('UPDATE eurolife_coffres SET black_money = black_money + ? WHERE id = ?', {amount, coffreId}, function()
        TriggerClientEvent('eurolife_coffre:refreshSingleCoffre', src, coffreId)
        TriggerClientEvent('esx:showNotification', src, ("~g~Vous avez déposé %s$ d'argent sale."):format(amount))
    end)
end)


-- Retrait argent sale
RegisterNetEvent('eurolife_coffre:withdrawBlackMoney', function(coffreId, amount)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then return end
    amount = tonumber(amount)
    if not amount or amount <= 0 then return end

    exports.oxmysql:execute('SELECT black_money FROM eurolife_coffres WHERE id = ?', {coffreId}, function(result)
        if result[1] and result[1].black_money >= amount then
            xPlayer.addAccountMoney('black_money', amount)
            exports.oxmysql:update('UPDATE eurolife_coffres SET black_money = black_money - ? WHERE id = ?', {amount, coffreId}, function()
                TriggerClientEvent('eurolife_coffre:refreshSingleCoffre', src, coffreId)
                TriggerClientEvent('esx:showNotification', src, ("~g~Vous avez retiré %s$ d'argent sale."):format(amount))
            end)
        else
            xPlayer.showNotification("~r~Pas assez d'argent sale dans le coffre.")
        end
    end)
end)

-- Refresh Single Coffre
RegisterNetEvent('eurolife_coffre:refreshSingleCoffre', function(coffreId)
    local src = source

    exports.oxmysql:execute('SELECT * FROM eurolife_coffres WHERE id = ?', {coffreId}, function(result)
        if result[1] then
            local items = {}

            exports.oxmysql:execute('SELECT * FROM eurolife_coffre_items WHERE coffre_id = ?', {coffreId}, function(itemResult)
                if itemResult then
                    for _, v in ipairs(itemResult) do
                        if v.item_name then
                            local itemLabel = ESX.GetItemLabel(v.item_name) or v.item_name
                            table.insert(items, {name = v.item_name, label = itemLabel, count = v.item_count})
                        end
                    end
                end

                TriggerClientEvent('eurolife_coffre:updateCurrentCoffre', src, {
                    id = coffreId,
                    items = items,
                    money = result[1].money or 0,
                    black_money = result[1].black_money or 0
                })
            end)
        end
    end)
end)


RegisterNetEvent('eurolife_coffre:requestCoffreData', function(coffreId)
    local src = source
    local items = {}
    local money = 0
    local black_money = 0

    -- Lire items dans eurolife_coffre_items
    exports.oxmysql:execute('SELECT item_name, item_count FROM eurolife_coffre_items WHERE coffre_id = ?', {coffreId}, function(itemResult)
        if itemResult then
            for _, v in pairs(itemResult) do
                table.insert(items, {name = v.item_name, count = v.item_count})
            end
        end

        -- Puis lire money + black_money dans eurolife_coffres
        exports.oxmysql:execute('SELECT money, black_money FROM eurolife_coffres WHERE id = ?', {coffreId}, function(coffreResult)
            if coffreResult and coffreResult[1] then
                money = coffreResult[1].money or 0
                black_money = coffreResult[1].black_money or 0
            end

            -- Envoyer l'ensemble
            TriggerClientEvent('eurolife_coffre:updateCurrentCoffre', src, {
                id = coffreId,
                items = items,
                money = money,
                black_money = black_money
            })
        end)
    end)
end)

