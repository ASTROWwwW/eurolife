if ConfigWCambriolage.NewEsx == true then 
    ESX = exports['es_extended']:getSharedObject()
else
    ESX = nil
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
end


RegisterNetEvent("buildermenu:callpolice")
AddEventHandler("buildermenu:callpolice", function( posx, posxy, posz )

    local coords = {x = posx, y = posxy, z = posz}
    local xPlayers = ESX.GetExtendedPlayers()
    for i = 1, #xPlayers, 1 do
        local thePlayer = xPlayers[i]
        for k,v in pairs(ConfigWCambriolage.TableJobsAlerter) do 
            if thePlayer.job.name == v  then 
                TriggerClientEvent('createBlipForFailure', thePlayer.source, coords)
                TriggerClientEvent('esx:showNotification', thePlayer.source, "Activité suspecte detecté !")
            end
        end
    end

end)

ESX.RegisterServerCallback('buildermenu:CheckItems', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local items = {}

    for _, item in pairs(ConfigWCambriolage.ItemVendable) do
        local inventoryItem = xPlayer.getInventoryItem(item.Name)
        if inventoryItem.count > 0 then
            table.insert(items, {Name = item.Name, Label = item.Label, Prix = item.Prix, Count = inventoryItem.count})
        end
    end

    cb(items)
end)

RegisterServerEvent('buildermenu:SellItem')
AddEventHandler('buildermenu:SellItem', function(itemName, itemCount, itemPrice, Coords)

    local xPlayer = ESX.GetPlayerFromId(source)
    local inventoryItem = xPlayer.getInventoryItem(itemName)

    local CoordsJoueurs = Coords
    local CoordsVente = ConfigWCambriolage.MenuVente
    local distance = #(CoordsJoueurs - CoordsVente )

    if distance <= ConfigWCambriolage.DistanceMarker then 

        if inventoryItem.count >= itemCount then
            xPlayer.removeInventoryItem(itemName, itemCount)
            if ConfigWCambriolage.ArgentPropre then 
                xPlayer.addAccountMoney('money' ,itemCount * itemPrice )
            else 
                xPlayer.addAccountMoney('black' ,itemCount * itemPrice )
            end
            TriggerClientEvent('esx:showNotification', source, string.format("Vous avez vendu %d %s pour $%d", itemCount, inventoryItem.label, itemCount * itemPrice))
        else
            TriggerClientEvent('esx:showNotification', source, "Vous n'avez pas assez de cet item.")
        end

        local heure = os.date("%d/%m/%Y %X")
        local idr1= xPlayer.getIdentifier()
        local NomJoueur = xPlayer.getName()
        local contenta = {
            {
                ["color"] = '5897984',
                ["title"] = "Menu Builder Cambriolage",
                ["description"] = '**Joueur ID : **' ..tostring(source) ..'\n ** A Vendu : **'..itemCount.. inventoryItem.label.. '\n ** Pour : **'..itemCount * itemPrice,
                ["footer"] = {
                    ["text"] = heure ..'\nlicense:'..idr1,
                },
            }
        }
    
        TriggerEvent("buildermenu:VenteItem",contenta) 

    else

        Customban("Trigger Vente Cambriolage", _src)

    end

end)

