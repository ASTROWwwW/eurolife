Config = {

    NewEsx = true,
    BoutonArmes = true,
    BoutonLootBox = true,
    BoutonVoiture = true, 
    BoutonHistorique = true,
    ActiverTebexUrl = true,
    ActiverWebSiteUrl = true,
    ActiverDiscordUrl = true,
    ActiverMusique = true, 
    TebexUrl = 'https://wk-shop.tebex.io/',
    WebsiteUrl = 'https://wk-shop.tebex.io/',
    DiscordUrl = 'https://discord.gg/2GDkRCAv',
    VideoId = 'jYdaQJzcAcw', -- Id youtube vidéo 
    SpawnCarTextHeader = "Boutique",
    SpawnCarText = "Vous avez 20 secondes pour tester",
    CommandeGivePts = "giveidboutique",

    AddItemNormal = function(xPlayer,_src,armeName, prix, Label)
        xPlayer.addInventoryItem(armeName, 1)
        xPlayer.showNotification('Vous avez acheté ' .. Label .. ' pour ' .. prix .. ' PTS')
    end,

    AddItemPerm = function(xPlayer,_src,armeName, prix, Label)
        -- xPlayer.addInventoryPerm(armeName, 1) Mettre votre code pour arme perm serveur side
        xPlayer.showNotification('Vous avez acheté ' .. Label .. ' pour ' .. prix .. ' PTS')
    end,

    LootBoxGainItem  = function(xPlayer,_src,itemagive, labelitemgive, nomlootbox, prixlootbox, labellootbox, pointrestant)
        xPlayer.showNotification('Félicitation , vous avez gagné : '..labelitemgive..' dans la caisse : '..labellootbox..' pour un montant de : '..prixlootbox..' il vous reste actuellement : '..pointrestant)
        xPlayer.addInventoryItem(itemagive, 1)
    end,

    LootBoxGainMoney = function(xPlayer,_src,itemagive, labelitemgive, nomlootbox, prixlootbox, labellootbox, pointrestant)
        xPlayer.showNotification('Félicitation , vous avez gagné : '..labelitemgive..' $ dans la caisse : '..labellootbox..' pour un montant de : '..prixlootbox..' il vous reste actuellement : '..pointrestant)
        xPlayer.addAccountMoney('money', tonumber(itemagive))
    end,

    LootBoxGainArmPerm = function(xPlayer,_src,itemagive, labelitemgive, nomlootbox, prixlootbox, labellootbox, pointrestant)
        -- xPlayer.addInventoryPerm(itemagive, 1) Mettre votre code pour arme perm serveur side
        xPlayer.showNotification('Félicitation , vous avez gagné : '..labelitemgive..' $ dans la caisse : '..labellootbox..' pour un montant de : '..prixlootbox..' il vous reste actuellement : '..pointrestant)

    end,

    LootBoxGainCar = function(xPlayer, _src, itemagive, labelitemgive, nomlootbox, prixlootbox, labellootbox, pointrestant, typeveh, Plate)
    
        local model = itemagive
        local License = xPlayer.getIdentifier()
        
        local Properties = { model = model , plate = ESX.Math.Trim(Plate)}

        MySQL.Async.execute('INSERT INTO owned_vehicles  (owner, type, vehicle, stored, plate) VALUES (@owner, @type, @vehicle, @stored, @plate)', {
            ['@owner'] = License,
            ['@type'] = typeveh,
            ['@vehicle'] = json.encode(Properties),
            ['@plate'] = ESX.Math.Trim(Plate),
            ['stored'] = tonumber(0)
        })

        TriggerClientEvent('Boutique:SetupVeh', _src , model , Plate)

        xPlayer.showNotification('Félicitation , vous avez gagné : '..labelitemgive..' dans la caisse : '..labellootbox..' pour un montant de : '..prixlootbox..'. Il vous reste actuellement : '..pointrestant..' points.')
            

    
    end,

    AchatVeh = function(_src, xPlayer, Name,Label,Prix,generatedPlate,newPts)

        local Properties = { model = Name , plate = ESX.Math.Trim(generatedPlate)}

        MySQL.Async.execute('INSERT INTO owned_vehicles  (owner, type, vehicle, stored, plate) VALUES (@owner, @type, @vehicle, @stored, @plate)', {
            ['@owner'] = License,
            ['@type'] = 'car',
            ['@vehicle'] = json.encode(Properties),
            ['@plate'] = ESX.Math.Trim(generatedPlate),
            ['stored'] = tonumber(0)
        })

        TriggerClientEvent('Boutique:SetupVeh', _src , Name , generatedPlate)

        xPlayer.showNotification('Félicitation , vous avez acheté : '..Label..' pour un montant de : '..Prix..'. Il vous reste actuellement : '..newPts..' points.')

    end,

    FunctionClientAfterSpawnCar = function(model , Plate)

        local Ped = PlayerPedId()
        local Coords = GetEntityCoords(Ped)
        local Heading = GetEntityHeading(Ped)

        ESX.Game.SpawnVehicle(model, { x = Coords.x+2 ,y = Coords.y, z = Coords.z+2 }, Heading, function (vehicle)
            if DoesEntityExist(vehicle) then 
                SetVehicleNumberPlateText(vehicle , Plate )
                SetPedIntoVehicle(PlayerPedId(),vehicle,-1)
            end
        end)

        TriggerServerEvent('Boutique:DeleteSrc')

    end,
    
    SaleWeapon = {
        {label = 'SMG', name = 'weapon_smg', price = 1000, type = 'normal' , image = 'smg'}, -- normal or perm
        {label = 'UZI', name = 'weapon_minismg', price = 2000, type = 'normal' ,  image = 'uzi'}, -- normal or perm
        {label = 'SMG', name = 'weapon_smg', price = 1000, type = 'normal' ,  image = 'smg'}, -- normal or perm
        {label = 'UZI', name = 'weapon_minismg', price = 2000, type = 'normal' ,  image = 'uzi'}, -- normal or perm
        
    },

    SaleCar = {
        {label = 'Sultan', name = 'sultan', price = 2000, image = 'sultan'},
        {label = 'Adder', name = 'adder', price = 2000, image = 'adder'},
        {label = 'Airtug', name = 'airtug', price = 2000, image = 'airtug'},
    }, 

    LootBox = {

        {
            label = 'Basic',
            name = 'basic_lootbox',
            price = 1000,
            image = 'basic_lootbox',
            contents = {
                { label = "Sniper Rifle", item = 'SniperRifle', drop_rate =25, image = 'sniperrifle', type = 'item'}, -- item or perm
                { label = "Sniper Rifle", item = 'SniperRifle', drop_rate =25, image = 'sniperrifle', type = 'item'}, -- item or perm
                { label = "AMG", item = 'sultan', drop_rate = 25, image = 'amg', type = 'car'}, -- Plane or Boat or bike
                { label = "100 000$",item = 100000, drop_rate = 25 ,image = 'money', type = 'money'}
            }
        },
        {
            label = 'Premium',
            name = 'premium_lootbox',
            price = 5000,
            image = 'premium_lootbox',
            contents = {
                { label = "Sniper Rifle", item = 'SniperRifle', drop_rate =25, image = 'sniperrifle', type = 'item'},
                { label = "Sniper Rifle", item = 'SniperRifle', drop_rate =25, image = 'sniperrifle', type = 'perm'},
                { label = "AMG", item = 'sultan', drop_rate = 25, image = 'amg', type = 'car'},
                { label = "100 000$",item = 100000, drop_rate = 25 ,image = 'money', type = 'money'}
            }
        },
        {
            label = 'Ultimate',
            name = 'ultimate_lootbox',
            price = 10000,
            image = 'ultimate_lootbox',
            contents = {
                { label = "Sniper Rifle", item = 'SniperRifle', drop_rate =25, image = 'sniperrifle', type = 'item'},
                { label = "Sniper Rifle", item = 'SniperRifle', drop_rate =25, image = 'sniperrifle', type = 'perm'},
                { label = "AMG", item = 'sultan', drop_rate = 25, image = 'amg', type = 'car'},
                { label = "100 000$",item = 100000, drop_rate = 25 ,image = 'money', type = 'money'}
            }
        },
        {
            label = 'God',
            name = 'basic_lootbox',
            price = 1000,
            image = 'basic_lootbox',
            contents = {
                { label = "Sniper Rifle", item = 'SniperRifle', drop_rate =25, image = 'sniperrifle', type = 'item'},
                { label = "Sniper Rifle", item = 'SniperRifle', drop_rate =25, image = 'sniperrifle', type = 'perm'},
                { label = "AMG", item = 'sultan', drop_rate = 25, image = 'amg', type = 'car'},
                { label = "100 000$",item = 100000, drop_rate = 25 ,image = 'money', type = 'money'}
            }
        },

    },

}